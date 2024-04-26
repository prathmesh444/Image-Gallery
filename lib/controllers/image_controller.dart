import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery/models/ImageModel.dart';

class ImageController extends GetxController {
  bool isLoading = false;
  bool isInitialized = false;
  String prevTopic = "";
  ImageModel? imageData;
  int PageNo = 1;
  static const String APIKEY = '43540399-b18d8318fba8ee32583bee349';
  static const baseUrl = 'https://pixabay.com/api/';

  @override
  void onInit() {
    _fetchImages(topic: "", pageNo: PageNo).then((value) {
      imageData = value;
      update();
    });
    super.onInit();
  }

  getImageSet({required String topic}) async {
    if(prevTopic != topic) {
      PageNo = 1;
      prevTopic = topic;
      imageData = await _fetchImages(topic: topic, pageNo: PageNo);
    }
    else {
      prevTopic = topic;
      await loadMoreImages();
    }
    update();
  }

  Future<ImageModel?> _fetchImages({required String topic, required int pageNo}) async {
    try {
      isInitialized = topic != "";

      final Map<String, dynamic> queryParams = {
        'key': APIKEY,
        if(isInitialized) 'q': topic,
        'page': pageNo.toString(),
        'per_page': '100',
      };
      final Uri url = Uri.parse(baseUrl).replace(queryParameters: queryParams);

      http.Response response = await http.get(
        url,
      );
      Get.log("Response status: ${response.statusCode}");
      Get.log("Response body: ${response.body}");

      return ImageModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      Get.log("Error: $e");
    } finally {
      // changeLoadingValue(false);
    }
    update();
    return null;
  }

  loadMoreImages() async {
    PageNo++;
    if((imageData?.hits.length ?? 0) >= (imageData?.total ?? 1)) {
      Get.log("No more data to fetch");
      return;
    }
    ImageModel? newImageModel = await _fetchImages(topic: prevTopic, pageNo: PageNo);
    if(newImageModel != null) {
      imageData?.hits.addAll(newImageModel.hits);
    }
    update();
  }

  changeLoadingValue(bool value) {
    isLoading = value;
    update();
  }
}
