import 'package:flutter/material.dart';
import 'package:youcomic/datasource/books.dart';
import 'package:youcomic/util/filter_book.dart';

import '../../../../config/application.dart';

class BookListProvider with ChangeNotifier {
  BookDataSource dataSource = new BookDataSource();
  bool isFilterOpen = false;
  List<DateTime>? customDateRange;
  bool first = true;
  String viewMode = ApplicationConfig().HomeBooksView;

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
    ApplicationConfig().updateHomeBooksView(mode);
    notifyListeners();
  }

  loadBooks(bool force) async {
    if (!first && !force) {
      return;
    }
    first = false;
    dataSource.extraQueryParam = bookFilter.getParams();
    await dataSource.loadBooks(force);
    notifyListeners();
  }
}
