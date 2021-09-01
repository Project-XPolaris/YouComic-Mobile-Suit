import 'package:flutter/material.dart';
import 'package:youcomic/components/filter/filter_section.dart';

class TagItem {
  final String name;
  final Function(dynamic, bool) onActiveChange;
  final bool isSelected;
  final key;

  TagItem({this.name, this.onActiveChange, this.key, this.isSelected = false});
}

class TagSelectFilterSection extends StatelessWidget {
  final List<TagItem> items;
  final bool showDivider;
  final String title;
  TagSelectFilterSection({this.items, this.showDivider = false,this.title = "排序"});

  @override
  Widget build(BuildContext context) {
    return FilterSection(
      title: title,
      showDivider: true,
      child: Wrap(
        children: <Widget>[
          ...items.map(
            (tag) => Padding(
                padding: EdgeInsets.only(right: 8,bottom: 8),
                child: ChoiceChip(
                  label: Text(tag.name),
                  onSelected: (isSelected) {
                    tag.onActiveChange(tag.key, isSelected);
                  },
                  selected: tag.isSelected,
                )),
          )
        ],
      ),
    );
  }
}
