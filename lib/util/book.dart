import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/api/model/tag_entity.dart';

String getBookTagName(
    {BookEntity bookEntity, String tagType, String defaultText = ""}) {
  if (bookEntity.tags == null) {
    return defaultText;
  }
  var target = bookEntity.tags
      .firstWhere((tag) => tag.type == tagType, orElse: () => null);

  if (target != null) {
    return target.name;
  }
  return defaultText;
}

TagEntity getBookTag(
    {BookEntity bookEntity, String tagType}) {
  var target = bookEntity.tags
      .firstWhere((tag) => tag.type == tagType, orElse: () => null);
  if (target != null) {
    return target;
  }
  return null;
}