import 'package:flutter/material.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/datasource/books.dart';

class TagProvider extends ChangeNotifier {
  TagEntity tag;
  var title = "标签";
  BookDataSource bookDataSource = new BookDataSource();
  var isFirst = true;
  TagProvider({this.tag});
  loadMoreBooks() async{
    await bookDataSource.loadMore();
    notifyListeners();
  }
  onLoad() async {
    if (!isFirst) {
      return;
    }
    isFirst = false;
    title = "标签：${tag.name}";
    notifyListeners();
    bookDataSource.extraQueryParam = {"tag":tag.id};
    await bookDataSource.loadBooks(true);
    notifyListeners();
  }
}
