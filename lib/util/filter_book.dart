import 'package:intl/intl.dart';
import 'package:youcomic/components/filter/range_save_filter.dart';

class BookFilter {
  List<String> orderFilter = ["-id"];
  List<DateTime>? customDateRange;
  String? timeRangeSelect = null;
  bool random = false;
  RangeItem pageRangeItem = RangeItem(id: "all", max: null, min: null);
  Function()? onUpdate;


  _getTimeRange() {
    if (this.timeRangeSelect == null) {
      return {};
    }
    var dateRange = customDateRange;
    final now = DateTime.now().add(Duration(days: 1));
    final nowEnd = new DateTime(now.year, now.month, now.day);
    final DateFormat df = new DateFormat("yyyy-MM-dd");
    if (timeRangeSelect == "7d") {
      final startTime = nowEnd.subtract(Duration(days: 7));
      return {"startTime": df.format(startTime), "endTime": df.format(nowEnd)};
    } else if (timeRangeSelect == "td") {
      final startTime = nowEnd.subtract(Duration(days: 1));
      return {"startTime": df.format(startTime), "endTime": df.format(nowEnd)};
    } else if (timeRangeSelect == "30d") {
      final startTime = nowEnd.subtract(Duration(days: 30));
      return {"startTime": df.format(startTime), "endTime": df.format(nowEnd)};
    } else if (dateRange != null &&
        dateRange.length > 1 &&
        timeRangeSelect == "custom") {
      final startTime = df.format(new DateTime(
          dateRange[0].year, dateRange[0].month, dateRange[0].day));
      final nextDayOfEnd = dateRange[1].add(Duration(days: 1));
      return {
        "startTime": startTime,
        "endTime": df.format(new DateTime(
            nextDayOfEnd.year, nextDayOfEnd.month, nextDayOfEnd.day))
      };
    }
    return {};
  }

  onTimeRangeChange(String value) {
    timeRangeSelect = value;
    onUpdate?.call();
  }

  onClearTimeRange() {
    customDateRange = null;
    onUpdate?.call();
  }

  updateCustomDateRange(List<DateTime> newRange) {
    customDateRange = newRange;
    onTimeRangeChange("custom");
    onUpdate?.call();
  }

  updateOrderFilter(newFilter) {
    if (newFilter[0] == "random") {
      random = true;
    }
    orderFilter = newFilter;
    onUpdate?.call();
  }
  updatePageRange(RangeItem item) {
    pageRangeItem = item;
    onUpdate?.call();
  }

  Map<String,dynamic> getParams() {
    Map<String, String> param = {};
    if (random) {
      param["random"] = "1";
    } else {
      param["order"] = orderFilter[0];
    }
    if (pageRangeItem.id != "all") {
      if (pageRangeItem.min != null) {
        param["pageMin"] = pageRangeItem.min.toString();
      }
      if (pageRangeItem.max != null) {
        param["pageMax"] = pageRangeItem.max.toString();
      }
    }
    return {...param, ..._getTimeRange()};
  }
}
