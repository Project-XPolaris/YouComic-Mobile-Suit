import 'package:flutter/material.dart';
import 'package:youcomic/components/filter/filter_section.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:intl/intl.dart';

class QuickTimeRangePick {
  final String title;

  final String key;

  QuickTimeRangePick({this.title, this.key});
}

class TimeRangeFilterSection extends StatelessWidget {
  final String selectMode;
  final List<DateTime> customDateRange;
  final Function onCustomTimeRangeUpdate;
  final Function onClearCustomTimeRange;
  final Function onTimeRangeChange;

  TimeRangeFilterSection({this.selectMode,
    this.customDateRange,
    this.onCustomTimeRangeUpdate,
    this.onClearCustomTimeRange,
    this.onTimeRangeChange});

  _onCustomTimeSelect(BuildContext context) async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
      context: context,
      initialFirstDate: new DateTime.now(),
      initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
      firstDate: new DateTime(2015),
      lastDate: new DateTime(2022),
    );
    if (picked != null && picked.length == 2) {
      onCustomTimeRangeUpdate(picked);
    }
  }

  Widget renderCustomDateRange(BuildContext context) {
    if (customDateRange == null) {
      return ActionChip(
        onPressed: () {
          _onCustomTimeSelect(context);
        },
        label: Text("点击选择时间"),
      );
    }

    final formatter = new DateFormat("yyyy-MM-dd");
    final String startText = formatter.format(this.customDateRange[0]);
    final String endText = formatter.format(this.customDateRange[1]);
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
        .map((item) =>
        Padding(
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
