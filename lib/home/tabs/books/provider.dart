import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/util.dart';
import 'package:youcomic/datasource/books.dart';

class BookListProvider with ChangeNotifier {
  BookDataSource dataSource = new BookDataSource();
  bool isFilterOpen;
  List<String> orderFilter = ["-id"];
  List<DateTime> customDateRange;
  String timeRangeSelect = null;
  bool first = true;

  _getTimeRange() {
    if (this.timeRangeSelect == null) {
      return {};
    }
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
    } else if (customDateRange != null &&
        customDateRange.length > 1 &&
        timeRangeSelect == "custom") {
      final startTime = df.format(new DateTime(customDateRange[0].year,
          customDateRange[0].month, customDateRange[0].day));
      final nextDayOfEnd = customDateRange[1].add(Duration(days: 1));
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
    loadBooks(true);
    notifyListeners();
  }

  onClearTimeRange() {
    customDateRange = null;
    notifyListeners();
  }

  updateCustomDateRange(List<DateTime> newRange) {
    customDateRange = newRange;
    onTimeRangeChange("custom");
    notifyListeners();
  }

  updateOrderFilter(newFilter) {
    orderFilter = newFilter;
    loadBooks(true);
    notifyListeners();
  }

  switchFilterDrawer() {
    isFilterOpen = !isFilterOpen;
    notifyListeners();
  }

  loadMore() async {
    dataSource.extraQueryParam = {"order": orderFilter[0], ..._getTimeRange()};
    await dataSource.loadMore();
    notifyListeners();
  }

  loadBooks(bool force) async {
    print(!(!first || force));
    if (!first && !force){
      return;
    }
    first = false;
    dataSource.extraQueryParam = {"order": orderFilter[0], ..._getTimeRange()};
    await dataSource.loadBooks(force);
    print(dataSource.books);
    notifyListeners();
  }
}
