import 'package:flutter/material.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/datasource/books.dart';
import 'package:youcomic/datasource/collections.dart';
import 'package:youcomic/datasource/tags.dart';

class HomeProvider with ChangeNotifier {
  BookDataSource recentlyBookDataSource = new BookDataSource();
  bool isRecentlyBookLoaded = false;

  List<CollectionEntity> recentlyCollections = [];
  bool isRecentlyCollections = true;
  CollectionDataSource collectionDataSource = new CollectionDataSource();
  bool isRandomTagLoading = true;
  TagDataSource tagDataSource = new TagDataSource();

  bool isRandomBookLoading = true;
  BookDataSource randomBookDataSource = new BookDataSource();

  onLoadRecentlyAdd(bool force) async {
    if (!isRecentlyBookLoaded || force) {
      this.isRecentlyBookLoaded = true;
      recentlyBookDataSource.extraQueryParam = {"order": "-id"};
      await recentlyBookDataSource.loadBooks(true);
      notifyListeners();
    }
  }

  onLoadRecentlyCollection(bool force) async {
    if (!isRecentlyCollections && !force) {
      return;
    }
    isRecentlyCollections = false;
    collectionDataSource.extraQueryParam = {"order": "-id"};
    await collectionDataSource.loadCollections(true);
    notifyListeners();
  }

  onLoadRandomTag(bool force) async {
    if (!isRandomTagLoading && !force) {
      return;
    }
    isRandomTagLoading = false;
    tagDataSource.extraQueryParam = { "random": "1","page_size":"20"};
    await tagDataSource.loadTags(true);
    notifyListeners();
  }
  onLoadRandomBook(bool force) async {
    if (!isRandomBookLoading && !force) {
      return;
    }
    isRandomBookLoading = false;
    randomBookDataSource.extraQueryParam = { "random": "1","page_size":"10"};
    await randomBookDataSource.loadBooks(true);
    notifyListeners();
  }

  onLoad(bool force) async {
    onLoadRecentlyAdd(force);
    onLoadRecentlyCollection(force);
    onLoadRandomTag(force);
    onLoadRandomBook(force);
  }
}
