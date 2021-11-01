class PageEntity {
  int? id;
  String? createdAt;
  int? order;
  int? bookId;
  String? path;
  late int width;
  late int height;

  PageEntity({this.id, this.createdAt, this.order, this.bookId, this.path,required this.width,required this.height});

  PageEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    order = json['page_order'];
    bookId = json['book_id'];
    path = json['path'];
    height = json['height'];
    width = json['width'];
  }
  static List<PageEntity> parseList(List<dynamic> list) {
    return list.map((elm) => PageEntity.fromJson(elm)).toList();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['order'] = this.order;
    data['book_id'] = this.bookId;
    data['path'] = this.path;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }

}
