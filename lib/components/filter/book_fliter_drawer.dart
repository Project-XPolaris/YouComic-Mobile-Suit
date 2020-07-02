import 'package:flutter/material.dart';
import 'package:youcomic/components/filter/tag_select_section.dart';
import 'package:youcomic/components/filter/time_range_section.dart';

class BookFilterDrawer extends StatelessWidget {
  final Function() onClose;
  final List<String> activeOrders;
  final Function(List<String>) onOrderUpdate;
  final Function(List<DateTime>) onCustomTimeRangeChange;
  final List<DateTime> customTimeRange;
  final Function() onClearCustomTimeRange;
  final Function(String newRange) onTimeRangeChange;
  final String timeRangeSelectMode;

  BookFilterDrawer({
    this.onClose,
    this.activeOrders,
    this.onOrderUpdate,
    this.onCustomTimeRangeChange,
    this.customTimeRange,
    this.onClearCustomTimeRange,
    this.onTimeRangeChange,
    this.timeRangeSelectMode
  });

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
          onActiveChange: onSelectChange)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Filter",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ),
                  IconButton(
                    onPressed: () {
                      onClose();
                    },
                    icon: Icon(Icons.close),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: TagSelectFilterSection(
                      items: _buildOrderOptions(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: TimeRangeFilterSection(
                      onCustomTimeRangeUpdate: this.onCustomTimeRangeChange,
                      customDateRange: this.customTimeRange,
                      selectMode: this.timeRangeSelectMode,
                      onClearCustomTimeRange: this.onClearCustomTimeRange,
                      onTimeRangeChange: this.onTimeRangeChange,
                    ),
                  )
                ],
              ),
            )

          ],
        )
      ),
    );
  }
}
