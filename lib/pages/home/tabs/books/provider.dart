import 'package:flutter/material.dart';
import 'package:youcomic/datasource/books.dart';
import 'package:youcomic/util/filter_book.dart';

import '../../../../config/application.dart';

class BookListProvider with ChangeNotifier {
  BookDataSource dataSource = new BookDataSource();
  bool isFilterOpen = false;
  List<DateTime>? customDateRange;
  bool first = true;

  final VIEW_MODE_KEY = "home/book/viewMode";
  String viewMode = ApplicationConfig().getOrDefault("home/book/viewMode", ApplicationConfig().width > 600 ? "Grid" : "List");

  final VIEW_GRID_SIZE_KEY = "home/book/gridSize";
  String gridSize = ApplicationConfig().getOrDefault("home/book/gridSize", "Medium");

  BookFilter bookFilter = new BookFilter();


  BookListProvider() {
    this.bookFilter.onUpdate = () {
      loadBooks(true);
    };
  }

  switchFilterDrawer() {
    isFilterOpen = !isFilterOpen;
    notifyListeners();
  }

  loadMore() async {
    dataSource.extraQueryParam = bookFilter.getParams();
    await dataSource.loadMore();
    notifyListeners();
  }


  changeViewMode(String mode) {
    viewMode = mode;
    ApplicationConfig().updateConfig(VIEW_MODE_KEY, mode);
    notifyListeners();
  }
  changeGridSize(String size) {
    gridSize = size;
    ApplicationConfig().updateConfig(VIEW_GRID_SIZE_KEY, size);
    notifyListeners();
  }

  get gridWidth {
    switch (gridSize) {
      case "Small":
        return 120;
      case "Medium":
        return 180;
      case "Large":
        return 240;
      default:
        return 180;
    }
  }

  loadBooks(bool force) async {
    if (!first && !force) {
      return;
    }
    first = false;
    dataSource.extraQueryParam = {...bookFilter.getParams(),"page_size":"100"};
    await dataSource.loadBooks(force);
    notifyListeners();
  }
}
