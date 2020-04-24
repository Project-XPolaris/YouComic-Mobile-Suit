import 'package:flutter/material.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/datasource/books.dart';
import 'package:youcomic/datasource/collections.dart';

class HomeProvider with ChangeNotifier {
  BookDataSource recentlyBookDataSource = new BookDataSource();
  bool isRecentlyBookLoaded = false;

  List<CollectionEntity> recentlyCollections;
  bool isRecentlyCollections = true;
  CollectionDataSource collectionDataSource = new CollectionDataSource();
  onLoadRecentlyAdd() async {
    if (!isRecentlyBookLoaded){
      this.isRecentlyBookLoaded = true;
      recentlyBookDataSource.loadBooks(true);
      notifyListeners();
    }
  }

  onLoadRecentlyCollection() async {
    if (!isRecentlyCollections){
      return;
    }
    isRecentlyCollections = false;
    collectionDataSource.extraQueryParam = {"order":"-id"};
    await collectionDataSource.loadCollections(true);
    notifyListeners();
  }

  onLoad() async {
    onLoadRecentlyAdd();
    onLoadRecentlyCollection();
  }
}
