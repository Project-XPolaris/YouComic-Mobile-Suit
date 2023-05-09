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
  late int pageCount;

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
    pageCount = json['pageCount'];
  }
  String? getBookCover(){
    return getRealThumbnailCover(this.id, this.cover);
  }
  String get displayAuthor {
    for (TagEntity tag in tags) {
      if (tag.type == "artist") {
        return tag.name ?? "Unknown";
      }
    }
    return "Unknown";
  }
  String get displayTheme {
    for (TagEntity tag in tags) {
      if (tag.type == "theme") {
        return tag.name ?? "Unknown";
      }
    }
    return "Unknown";
  }
  String get displaySeries {
    for (TagEntity tag in tags) {
      if (tag.type == "series") {
        return tag.name ?? "Unknown";
      }
    }
    return "Unknown";
  }
}
