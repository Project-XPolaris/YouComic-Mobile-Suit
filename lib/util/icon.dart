import 'package:flutter/material.dart';

selectIconByTagType(String type) {
  var icon = {
    "artist": Icons.person,
    "theme": Icons.tag_faces,
    "series": Icons.library_books,
    "translator": Icons.translate,
    "local": Icons.location_on
  }[type];
  return icon == null ? Icons.bookmark : icon;
}
