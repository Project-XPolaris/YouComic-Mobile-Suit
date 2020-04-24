import 'package:flutter/material.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/datasource/books.dart';

class CollectionDetailProvider with ChangeNotifier {
  CollectionEntity collection;
  BookDataSource dataSource = BookDataSource();
  CollectionDetailProvider({this.collection});
  var isFirst = true;
  onLoad() async {
    if (!isFirst) {
      return;
    }
    isFirst = false;
    notifyListeners();
    dataSource.extraQueryParam = {"collection":collection.id};
    await dataSource.loadBooks(true);
    notifyListeners();
  }
  onLoadMore() async {
    await dataSource.loadMore();
    notifyListeners();
  }
}