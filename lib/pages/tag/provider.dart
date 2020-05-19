import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/tag_entity.dart';
import 'package:youcomic/datasource/books.dart';

enum SubscribeStatus { Unknown, Subscribed, UnSubscribed }

class TagProvider extends ChangeNotifier {
  TagEntity tag;
  var title = "标签";
  BookDataSource bookDataSource = new BookDataSource();
  var isFirst = true;
  SubscribeStatus subscribeStatus = null;

  TagProvider({this.tag});

  loadMoreBooks() async {
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
    bookDataSource.extraQueryParam = {"tag": tag.id};
    await bookDataSource.loadBooks(true);
    notifyListeners();
  }

  onSubscribe() async {
    ApiClient().subscribeTag(tag.id);
    subscribeStatus = SubscribeStatus.Subscribed;
    notifyListeners();
  }

  onCancelSubscribe() async {
    ApiClient().cancelSubscribeTag(tag.id);
    subscribeStatus = SubscribeStatus.UnSubscribed;
    notifyListeners();
  }

  checkIsSubscribe() async {
    if (subscribeStatus != null) {
      return;
    }
    subscribeStatus = SubscribeStatus.Unknown;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("uid")) {
      return;
    }
    final uid = prefs.getInt("uid");
    final response = await ApiClient().fetchTags({"subscription": uid, "id": tag.id});
    final count = response.data["count"];
    if (count > 0) {
      this.subscribeStatus = SubscribeStatus.Subscribed;
    } else {
      this.subscribeStatus = SubscribeStatus.UnSubscribed;
    }
    notifyListeners();
  }
}
