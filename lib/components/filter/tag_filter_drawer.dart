import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youcomic/components/filter/filter_drawer.dart';
import 'package:youcomic/components/filter/tag_select_section.dart';

class TagFilterDrawer extends StatelessWidget {
  final Function() onClose;
  final Function(List<String> updatedActiveTypeFilters) onTypeFilterChange;
  final List<String> activeTypeFilters;
  final bool random;
  final Function(bool) onRandomChange;

  TagFilterDrawer(
      {this.onClose,
      this.onTypeFilterChange,
      this.activeTypeFilters,
      this.random,
      this.onRandomChange});

  @override
  Widget build(BuildContext context) {
    updateTypeFilter(String key, bool isSelected) {
      if (isSelected && !activeTypeFilters.contains(key)) {
        onTypeFilterChange([...activeTypeFilters, key]);
      } else if (!isSelected && activeTypeFilters.contains(key)) {
        activeTypeFilters.remove(key);
        onTypeFilterChange(activeTypeFilters.toList());
      }
    }

    final List<TagItem> items = [
      TagItem(
          name: "Artist",
          key: "artist",
          onActiveChange: (dynamic key, bool isSelect) =>
              updateTypeFilter(key, isSelect),
          isSelected: activeTypeFilters.contains("artist")),
      TagItem(
          name: "Theme",
          key: "theme",
          onActiveChange: (dynamic key, bool isSelect) =>
              updateTypeFilter(key, isSelect),
          isSelected: activeTypeFilters.contains("theme")),
      TagItem(
          name: "Series",
          key: "series",
          onActiveChange: (dynamic key, bool isSelect) =>
              updateTypeFilter(key, isSelect),
          isSelected: activeTypeFilters.contains("series")),
      TagItem(
          name: "Translator",
          key: "translator",
          onActiveChange: (dynamic key, bool isSelect) =>
              updateTypeFilter(key, isSelect),
          isSelected: activeTypeFilters.contains("translator")),
    ];
    return FilterDrawer(
      onClose: onClose,
      children: [
        TagSelectFilterSection(
          items: items,
        ),
        Wrap(
          children: [
            ActionChip(
              label: Text("Random"),
              backgroundColor: random ? Colors.blue : null,
              onPressed: () {
                onRandomChange(!random);
              },
            )
          ],
        )
      ],
    );
  }
}
