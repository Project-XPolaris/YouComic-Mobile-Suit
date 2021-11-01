class ListContainer<T> {
  int count = 0;
  String next = "";
  String prev = "";
  int page = 0;
  int pageSize = 20;
  List<T> result = [];

  ListContainer.fromJSON(dynamic json, Function(dynamic json) converter) {
    this.count = json['count'];
    this.next = json['next'] ?? "";
    this.prev = json['prev'] ?? "";
    this.page = json['page'];
    this.pageSize = json['pageSize'];
    var rawList = json['result'];
    if (rawList != null) {
      rawList.forEach((element) {
        this.result.add(converter(element));
      });
    }
  }
}
