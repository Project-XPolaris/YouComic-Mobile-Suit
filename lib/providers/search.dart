import 'package:flutter/material.dart';
import 'package:youcomic/datasource/books.dart';
import 'package:youcomic/datasource/collections.dart';
import 'package:youcomic/datasource/tags.dart';

class SearchProvider extends ChangeNotifier {
  var searchKey = "";
  var title = "搜索";
  BookDataSource bookDataSource = new BookDataSource();
  TagDataSource tagsDataSource = new TagDataSource();
  CollectionDataSource collectionDataSource = new CollectionDataSource();
  bool first = true;
  onLoadMoreBook() async{
    await bookDataSource.loadMore();
    notifyListeners();
  }
  onLoadMoreTag() async{
    await tagsDataSource.loadMore();
    notifyListeners();
  }
  onLoadMoreCollections() async{
    await collectionDataSource.loadMore();
    notifyListeners();
  }
  onLoad() async {
    if (!first){
      return;
    }
    first = false;
    bookDataSource.extraQueryParam = {"nameSearch": searchKey};
    await bookDataSource.loadBooks(true);
    notifyListeners();
    tagsDataSource.extraQueryParam = {"nameSearch": searchKey};
    await tagsDataSource.loadTags(true);
    notifyListeners();

    collectionDataSource.extraQueryParam = {"nameSearch": searchKey};
    await collectionDataSource.loadCollections(true);
    notifyListeners();
  }
}
