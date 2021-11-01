import 'package:flutter/material.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/util/icon.dart';

class TagItem extends StatelessWidget {
  final TagEntity tag;
  final Function()? onTap;
  TagItem({required this.tag,this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(tag.getName()),
      subtitle: Text(tag.getType()),
      leading: CircleAvatar(
        child: Icon(selectIconByTagType(tag.getType())),
      ),
    );
  }
}
