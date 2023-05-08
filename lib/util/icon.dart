import 'package:flutter/material.dart';

selectIconByTagType(String? type) {
  var icon = {
    "artist": Icons.person_rounded,
    "theme": Icons.tag_faces_rounded,
    "series": Icons.library_books_rounded,
    "translator": Icons.translate_rounded,
    "local": Icons.location_on_rounded
  }[type];
  return icon == null ? Icons.bookmark_rounded : icon;
}
