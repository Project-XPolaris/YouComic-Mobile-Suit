import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/api/util.dart';
import 'package:youcomic/config/application.dart';

class BookEntity {
  int? id;
  String? createdAt;
  String? updatedAt;
  late String name ;
  String? cover;
  List<TagEntity> tags = [];

  BookEntity(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name =  "Unknown",
      this.cover,
      this.tags = const []});

  static List<BookEntity> parseList(List<dynamic> list) {
    return list.map((elm) => BookEntity.fromJson(elm)).toList();
  }

  BookEntity.fromJson(json) {
    print(json);
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'] ?? "Unknown";
    cover = json['cover'];
    if (json['tags'] != null) {
      json['tags'].forEach((v) {
        tags.add(new TagEntity.fromJson(v));
      });
    }
  }
  String? getBookCover(){
    return getRealThumbnailCover(this.id, this.cover);
  }
}
