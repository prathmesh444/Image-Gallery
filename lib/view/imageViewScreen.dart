import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:image_gallery/controllers/image_controller.dart';

class ImageBuilderScreen extends StatefulWidget {
  const ImageBuilderScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageBuilderScreenState();
}

class _ImageBuilderScreenState extends State<ImageBuilderScreen> {
  ImageController imageCtrl = Get.put(ImageController());
  Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 1500));
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GetBuilder<ImageController>(
        init: imageCtrl,
        builder: (imageCtrl) {
          return Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: TextField(
                            controller: textController,
                            onChanged: (value) {
                              debouncer.call(() { imageCtrl.getImageSet(topic: value); });
                            },
                            decoration:  InputDecoration(
                              hintText: 'Search for images',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: Icon(Icons.search),
                              suffix: InkWell(
                                  onTap: () {
                                    textController.clear();
                                  },
                                  child: Icon(Icons.clear)
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      imageCtrl.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          :Flexible(
                          child: GridView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: imageCtrl.imageData?.hits.length ?? 0,
                            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              if(index == (imageCtrl.imageData?.hits.length ?? 120) - 20) {
                                imageCtrl.loadMoreImages();
                              }
                              Widget image = Image.network(
                                imageCtrl.imageData?.hits[index].webformatURL ?? "",
                                fit: BoxFit.cover,
                              );
                              return imageCtrl.imageData != null
                                  ? OpenContainer(
                                  transitionDuration: const Duration(milliseconds: 700),
                                  transitionType: ContainerTransitionType.fadeThrough,
                                  openShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  openBuilder: (context, action) {
                                    return SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.5,
                                      child: Stack(
                                        children: [
                                          Center(
                                          child: image,
                                        ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.5),
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  action();
                                                },
                                                icon: Icon(Icons.close, color: Colors.grey,),
                                              ),
                                            ),
                                          )
                                    ]
                                      ),
                                    );
                                  },
                                  closedBuilder: (BuildContext context, void Function() action) {
                                    return Column(
                                        children: [
                                         Container(
                                           height: screenHeight * 0.12 * (screenHeight * 0.002),
                                             width: screenWidth * 0.2,
                                             child: image
                                         ),
                                         Flexible(
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                             children: [
                                               Row(
                                                 children: [
                                                   Icon(Icons.favorite, color: Colors.red, size: screenWidth * 0.005,),
                                                    Text(" ${imageCtrl.imageData?.hits[index].likes ?? 0}", style: TextStyle(fontSize: screenWidth * 0.006),),
                                                 ],
                                               ),
                                                SizedBox(width: screenWidth * 0.005),
                                                Row(
                                                  children: [
                                                    Icon(Icons.remove_red_eye_outlined, color: Colors.blue, size: screenWidth * 0.005,),
                                                    Text(" ${imageCtrl.imageData?.hits[index].downloads ?? 0}", style: TextStyle(fontSize: screenWidth * 0.006)),
                                                  ],
                                                ),
                                             ],
                                           ),
                                         )
                                        ]
                                    );
                                  },
                                  )
                                  : Container();
                            },
                          ),
                        ),
                      ])),
          );
        });
  }
}
