class PageEntity {
  int id;
  String createdAt;
  int pageOrder;
  int bookId;
  String path;
  int width;
  int height;

  PageEntity({this.id, this.createdAt, this.pageOrder, this.bookId, this.path,this.width,this.height});

  PageEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    pageOrder = json['page_order'];
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
    data['page_order'] = this.pageOrder;
    data['book_id'] = this.bookId;
    data['path'] = this.path;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
