import 'package:youcomic/api/model/book_entity.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:collection/collection.dart';

String getBookTagName(
    {required BookEntity bookEntity,
    required String tagType,
    String defaultText = ""}) {
  if (bookEntity.tags.isEmpty) {
    return defaultText;
  }
  var target = bookEntity.tags
      .firstWhereOrNull((tag) => tag.type == tagType);

  if (target != null) {
    return target.getName();
  }
  return defaultText;
}

TagEntity? getBookTag({required BookEntity bookEntity, String? tagType}) {
  if (tagType == null) {
    return null;
  }
  var target = bookEntity.tags
      .firstWhereOrNull((tag) => tag.type == tagType);
  if (target != null) {
    return target;
  }
  return null;
}
