class CollectionEntity {
  int id;
  String name;
  int owner;

  CollectionEntity({this.id, this.name, this.owner});

  CollectionEntity.fromJson(json) {
    id = json['id'];
    name = json['name'];
    owner = json['owner'];
  }

  static List<CollectionEntity> parseList(List<dynamic> list) {
    return list.map((elm) => CollectionEntity.fromJson(elm)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['owner'] = this.owner;
    return data;
  }
}
