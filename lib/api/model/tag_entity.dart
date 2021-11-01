

class TagEntity {
  int? id;
  String? createdAt;
  String? name;
  String? type;

  TagEntity({this.id, this.createdAt, this.name, this.type});

  TagEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    name = json['name'];
    type = json['type'];
  }

  static List<TagEntity> parseList(List<dynamic> list) {
    return list.map((elm) => TagEntity.fromJson(elm)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
  getName(){
    return this.name ?? "";
  }
  getType(){
    return this.type ?? "";
  }
}
