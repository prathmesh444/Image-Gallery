class ImageModel {
  int total;
  int totalHits;
  List<Hits> hits;

  ImageModel({required this.total, required this.totalHits, required this.hits});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    var list = json['hits'] as List;
    List<Hits> hitsList = list.map((i) => Hits.fromJson(i)).toList();
    return ImageModel(total: json['total'], totalHits: json['totalHits'], hits: hitsList);
  }
}

class Hits {
  String? id;
  String? pageURL;
  String? type;
  String? tags;
  String? previewURL;
  String? previewWidth;
  String? previewHeight;
  String? webformatURL;
  String? webformatWidth;
  String? webformatHeight;
  String? largeImageURL;
  String? imageWidth;
  String? imageHeight;
  String? imageSize;
  String? views;
  String? downloads;
  String? favorites;
  String? likes;
  String? comments;
  String? user_id;
  String? user;
  String? userImageURL;

  Hits(
      {this.id,
      this.pageURL,
      this.type,
      this.tags,
      this.previewURL,
      this.previewWidth,
      this.previewHeight,
      this.webformatURL,
      this.webformatWidth,
      this.webformatHeight,
      this.largeImageURL,
      this.imageWidth,
      this.imageHeight,
      this.imageSize,
      this.views,
      this.downloads,
      this.favorites,
      this.likes,
      this.comments,
      this.user_id,
      this.user,
      this.userImageURL});

  factory Hits.fromJson(Map<String, dynamic> json) {
    return Hits(
        id: json['id'].toString(),
        pageURL: json['pageURL'].toString(),
        type: json['type'].toString(),
        tags: json['tags'].toString(),
        previewURL: json['previewURL'].toString(),
        previewWidth: json['previewWidth'].toString(),
        previewHeight: json['previewHeight'].toString(),
        webformatURL: json['webformatURL'].toString(),
        webformatWidth: json['webformatWidth'].toString(),
        webformatHeight: json['webformatHeight'].toString(),
        largeImageURL: json['largeImageURL'].toString(),
        imageWidth: json['imageWidth'].toString(),
        imageHeight: json['imageHeight'].toString(),
        imageSize: json['imageSize'].toString(),
        views: json['views'].toString(),
        downloads: json['downloads'].toString(),
        favorites: json['favorites'].toString(),
        likes: json['likes'].toString(),
        comments: json['comments'].toString(),
        user_id: json['user_id'].toString(),
        user: json['user'].toString(),
        userImageURL: json['userImageURL'].toString());
  }
}
