import 'package:flutter/material.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/datasource/books.dart';
import 'package:youcomic/datasource/collections.dart';

class HomeProvider with ChangeNotifier {
  BookDataSource recentlyBookDataSource = new BookDataSource();
  bool isRecentlyBookLoaded = false;

  List<CollectionEntity> recentlyCollections = [];
  bool isRecentlyCollections = true;
  CollectionDataSource collectionDataSource = new CollectionDataSource();
  onLoadRecentlyAdd(bool force) async {
    if (!isRecentlyBookLoaded || force){
      this.isRecentlyBookLoaded = true;
      recentlyBookDataSource.extraQueryParam = {"order":"-id"};
      await recentlyBookDataSource.loadBooks(true);
      notifyListeners();
    }
  }

  onLoadRecentlyCollection(bool force) async {
    if (!isRecentlyCollections || force){
      return;
    }
    isRecentlyCollections = false;
    collectionDataSource.extraQueryParam = {"order":"-id"};
    await collectionDataSource.loadCollections(true);
    notifyListeners();

  }

  onLoad(bool force) async {
    onLoadRecentlyAdd(force);
    onLoadRecentlyCollection(force);
  }
}
