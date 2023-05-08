import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/collection.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/datasource/collections.dart';

class CollectionProvider with ChangeNotifier {
  CollectionDataSource dataSource = new CollectionDataSource();
  bool first = true;

  onLoadMoreCollection() async {
    await dataSource.loadMore();
    notifyListeners();
  }

  onForceReload() async {
    await dataSource.loadCollections(true);
    notifyListeners();
  }

  onLoad() async {
    if (first) {
      first = false;
      dataSource.extraQueryParam = {"owner": ApplicationConfig().uid};
      await dataSource.loadCollections(true);
      notifyListeners();
    }
  }

  updateCollection(int collectionId, String text) async {
    var response = await ApiClient().updateCollection(collectionId, text);
    CollectionEntity updateCollectionEntity =
        CollectionEntity.fromJson(response.data);
    dataSource.collections = dataSource.collections.map((collectionEntity) {
      if (updateCollectionEntity.id == collectionEntity.id) {
        return updateCollectionEntity;
      }
      return collectionEntity;
    }).toList();
    notifyListeners();
  }

  deleteCollection(int id) async {
    await ApiClient().deleteCollection(id);
    dataSource.collections.removeWhere((collection) => collection.id == id);
    notifyListeners();
  }

  createCollection(name) async {
    await ApiClient().createCollection(name);
    await dataSource.loadCollections(true);
    notifyListeners();
  }
}
