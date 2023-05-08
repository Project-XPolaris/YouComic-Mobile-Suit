import 'package:flutter/material.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/datasource/books.dart';
import 'package:youcomic/util/filter_book.dart';

enum SubscribeStatus { Unknown, Subscribed, UnSubscribed }

class TagProvider extends ChangeNotifier {
  TagEntity tag;
  var title = "标签";
  BookDataSource bookDataSource = new BookDataSource();
  var isFirst = true;
  SubscribeStatus? subscribeStatus = null;
  String viewMode = ApplicationConfig().TagBooksView;
  BookFilter bookFilter = new BookFilter();
  TagProvider({required this.tag}){
    this.bookFilter.onUpdate = () {
      onLoad(force: true);
    };
  }

  loadMoreBooks() async {
    await bookDataSource.loadMore();
    notifyListeners();
  }

  onLoad({force = false}) async {
    if (!isFirst && !force) {
      return;
    }
    isFirst = false;
    title = "标签：${tag.name}";
    bookDataSource.extraQueryParam = {"tag": tag.id,...bookFilter.getParams()};
    await bookDataSource.loadBooks(force);
    notifyListeners();
  }

  onSubscribe() async {
    var id = tag.id;
    if (id == null) {
      return;
    }
    ApiClient().subscribeTag(id);
    subscribeStatus = SubscribeStatus.Subscribed;
    notifyListeners();
  }

  onCancelSubscribe() async {
    var id = tag.id;
    if (id == null) {
      return;
    }
    ApiClient().cancelSubscribeTag(id);
    subscribeStatus = SubscribeStatus.UnSubscribed;
    notifyListeners();
  }

  checkIsSubscribe() async {
    if (subscribeStatus != null) {
      return;
    }
    if (ApplicationConfig().uid == null) {
      return;
    }
    final response = await ApiClient().fetchTags({"subscription": int.parse(ApplicationConfig().uid ?? "0"), "id": tag.id});
    final count = response.data["count"];
    if (count > 0) {
      this.subscribeStatus = SubscribeStatus.Subscribed;
    } else {
      this.subscribeStatus = SubscribeStatus.UnSubscribed;
    }
    notifyListeners();
  }
  changeViewMode(String value) {
    this.viewMode = value;
    ApplicationConfig().updateTagBooksView(value);
    notifyListeners();
  }
}
