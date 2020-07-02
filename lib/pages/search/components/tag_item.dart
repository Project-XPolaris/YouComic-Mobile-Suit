import 'package:flutter/material.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/util/icon.dart';

class TagItem extends StatelessWidget {
  final TagEntity tag;
  TagItem({this.tag});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tag.name),
      subtitle: Text(tag.type),
      leading: CircleAvatar(
        child: Icon(selectIconByTagType(tag.type)),
      ),
    );
  }
}
