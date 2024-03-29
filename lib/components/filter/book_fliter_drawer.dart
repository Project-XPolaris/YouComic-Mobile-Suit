import 'package:flutter/material.dart';
import 'package:youcomic/components/filter/range_save_filter.dart';
import 'package:youcomic/components/filter/tag_select_section.dart';
import 'package:youcomic/components/filter/time_range_section.dart';

class BookFilterDrawer extends StatelessWidget {
  final Function() onClose;
  final List<String> activeOrders;
  final Function(List<String>) onOrderUpdate;
  final Function(List<DateTime>) onCustomTimeRangeChange;
  final List<DateTime>? customTimeRange;
  final Function() onClearCustomTimeRange;
  final Function(String newRange) onTimeRangeChange;
  final String? timeRangeSelectMode;
  final Function(RangeItem item) onPageRangeChange;
  final String? pageRangeSelectId;

  BookFilterDrawer({
    required this.onClose,
    required this.activeOrders,
    required this.onOrderUpdate,
    required this.onCustomTimeRangeChange,
    this.customTimeRange,
    required this.onClearCustomTimeRange,
    required this.onTimeRangeChange,
    required this.onPageRangeChange,
    this.timeRangeSelectMode,
    this.pageRangeSelectId
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
          onActiveChange: onSelectChange),
      new TagItem(
          name: "随机",
          key: "random",
          isSelected: activeOrders.contains("random"),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      onPressed: () {
                        onClose();
                      },
                      icon: Icon(Icons.close_rounded),
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: RangeSaveFilterSection(
                        selectId: this.pageRangeSelectId,
                        onSelectChange: onPageRangeChange,
                        storeKey: "global/pageRange",
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
