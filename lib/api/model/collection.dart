class CollectionEntity {
  int id;
  String name;
  int owner;
  bool contain;

  CollectionEntity({this.id, this.name, this.owner, this.contain});

  CollectionEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    owner = json['owner'];
    if (json.containsKey("contain")) {
      contain = json["contain"];
    }
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
