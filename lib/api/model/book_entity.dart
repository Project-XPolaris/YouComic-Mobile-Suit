import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/generated/json/base/json_convert_content.dart';
import 'package:youcomic/generated/json/base/json_filed.dart';

class BookEntity {
  int id;
  String createdAt;
  String updatedAt;
  String name;
  String cover;
  List<TagEntity> tags;

  BookEntity(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.cover,
      this.tags});

  static List<BookEntity> parseList(List<dynamic> list) {
    return list.map((elm) => BookEntity.fromJson(elm)).toList();
  }

  BookEntity.fromJson(json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    cover = json['cover'];
    if (json['tags'] != null) {
      tags = new List<TagEntity>();
      json['tags'].forEach((v) {
        tags.add(new TagEntity.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['cover'] = this.cover;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
