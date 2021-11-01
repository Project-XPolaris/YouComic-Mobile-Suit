import 'package:flutter/material.dart';
import 'package:youcomic/components/filter/filter_section.dart';
import 'package:intl/intl.dart';

class QuickTimeRangePick {
  final String title;

  final String key;

  QuickTimeRangePick({required this.title, required this.key});
}

class TimeRangeFilterSection extends StatelessWidget {
  final String? selectMode;
  final List<DateTime>? customDateRange;
  final Function onCustomTimeRangeUpdate;
  final Function onClearCustomTimeRange;
  final Function onTimeRangeChange;

  TimeRangeFilterSection(
      {this.selectMode,
      this.customDateRange,
      required this.onCustomTimeRangeUpdate,
      required this.onClearCustomTimeRange,
      required this.onTimeRangeChange});

  _onCustomTimeSelect(BuildContext context) async {
    var range = await showDateRangePicker(
        context: context,
        firstDate: new DateTime.now(),
        lastDate: (new DateTime.now()).add(new Duration(days: 7)));
    if (range != null) {
      onCustomTimeRangeUpdate([range.start, range.end]);
    }
  }

  Widget renderCustomDateRange(BuildContext context) {
    var customDateRange = this.customDateRange;
    if (customDateRange == null) {
      return ActionChip(
        onPressed: () {
          _onCustomTimeSelect(context);
        },
        label: Text("点击选择时间"),
      );
    }

    final formatter = new DateFormat("yyyy-MM-dd");
    final String startText = formatter.format(customDateRange[0]);
    final String endText = formatter.format(customDateRange[1]);
    final ChipThemeData chipTheme = ChipTheme.of(context);
    final selected = this.selectMode != null && this.selectMode == "custom";
    return RawChip(
      showCheckmark: false,
      selectedColor: chipTheme.secondarySelectedColor,
      labelStyle: selected ? chipTheme.secondaryLabelStyle : null,
      onPressed: () {
        if (selectMode == "custom") {
          this.onTimeRangeChange(null);
        } else {
          this.onTimeRangeChange("custom");
        }
      },
      onDeleted: () {
        this.onClearCustomTimeRange();
      },
      selected: selected,
      label: Text(
        "$startText To $endText",
      ),
    );
  }

  List<Widget> renderQuickPickChip(BuildContext context) {
    final List<QuickTimeRangePick> _quickPick = [
      new QuickTimeRangePick(title: "今日", key: "td"),
      new QuickTimeRangePick(title: "7日", key: "7d"),
      new QuickTimeRangePick(title: "30日", key: "30d")
    ];
    onSelect(key, isSelect) {
      if (isSelect) {
        this.onTimeRangeChange(key);
        return;
      }
      if (key == this.selectMode && isSelect == false) {
        this.onTimeRangeChange(null);
        return;
      }
    }

    return _quickPick
        .map((item) => Padding(
              padding: EdgeInsets.only(right: 8),
              child: ChoiceChip(
                onSelected: (isSelect) => onSelect(item.key, isSelect),
                selected: selectMode != null && selectMode == item.key,
                label: Text(item.title),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FilterSection(
      title: "添加时间",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            children: <Widget>[...renderQuickPickChip(context)],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: renderCustomDateRange(context),
          )
        ],
      ),
    );
  }
}
