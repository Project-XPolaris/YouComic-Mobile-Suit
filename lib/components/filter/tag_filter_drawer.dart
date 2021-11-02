import 'package:flutter/widgets.dart';
import 'package:youcomic/components/filter/filter_drawer.dart';
import 'package:youcomic/components/filter/tag_select_section.dart';

class TagFilterDrawer extends StatelessWidget {
  final Function() onClose;
  final Function(List<String> updatedActiveTypeFilters) onTypeFilterChange;
  final List<String> activeTypeFilters;
  final List<String> activeOrders;
  final Function(List<String>) onOrderUpdate;

  TagFilterDrawer({
    required this.onClose,
    required this.onTypeFilterChange,
    required this.activeTypeFilters,
    required this.activeOrders,
    required this.onOrderUpdate,
  });

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
    _buildOrderOptions() {
      onSelectChange(dynamic key, bool isSelected) {
        if (isSelected) {
          onOrderUpdate([
            key,
          ]);
        }
      }

      return [
        new TagItem(
            name: "id升序",
            key: "id",
            isSelected: activeOrders.contains("id"),
            onActiveChange: onSelectChange),
        new TagItem(
            name: "id降序",
            key: "-id",
            isSelected: activeOrders.contains("-id"),
            onActiveChange: onSelectChange),
        new TagItem(
            name: "名称升序",
            key: "name",
            isSelected: activeOrders.contains("name"),
            onActiveChange: onSelectChange),
        new TagItem(
            name: "名称降序",
            key: "-name",
            isSelected: activeOrders.contains("-name"),
            onActiveChange: onSelectChange),
        new TagItem(
            name: "创建时间升序",
            key: "created_at",
            isSelected: activeOrders.contains("created_at"),
            onActiveChange: onSelectChange),
        new TagItem(
            name: "创建时间降序",
            key: "-created_at",
            isSelected: activeOrders.contains("-created_at"),
            onActiveChange: onSelectChange),
        new TagItem(
            name: "随机",
            key: "random",
            isSelected: activeOrders.contains("random"),
            onActiveChange: onSelectChange)
      ];
    }

    return FilterDrawer(
      onClose: onClose,
      children: [
        TagSelectFilterSection(
          items: items,
        ),
        TagSelectFilterSection(
          items: _buildOrderOptions(),
        )
      ],
    );
  }
}
