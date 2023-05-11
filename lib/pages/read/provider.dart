import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/history.dart';
import 'package:youcomic/datasource/history.dart';
import 'package:youcomic/datasource/pages.dart';

enum PageStatus { UnLoad, Loading, Done }

class PageImageItem {
  String url;
  PageStatus status;

  PageImageItem(this.url, this.status);
}

class ReadProvider extends ChangeNotifier {
  final PageDataSource dataSource = new PageDataSource();
  bool _first = true;
  final List<int> loadedPage = [];
  int currentDisplayPage = 0;
  final List<PageImageItem> pageImages = [];
  HistoryEntity? historyEntity;
  final int id;
  var hasJumpToPage = true;
  getPageImage(id, path) {
    CachedNetworkImageProvider(path);
  }
  updateCurrentDisplayPage(page) {
    currentDisplayPage = page;
    notifyListeners();
  }
  ReadProvider({required this.id}){
    dataSource.extraQueryParam = {"book": id, "template": "withSize"};
    _first = true;
    loadedPage.clear();
    dataSource.pages.clear();
  }

  loadPage() async {
    if (!_first) {
      return;
    }
    _first = false;
    await dataSource.loadPages(true);
    try {
      HistoryDataSource historyDataSource = new HistoryDataSource()..extraQueryParam = {"bookId": id};
      await historyDataSource.loadData(true);
      if (historyDataSource.data.length > 0) {
        historyEntity = historyDataSource.data[0];
      }

    }catch(e){
      print(e);
    }
   
    notifyListeners();
  }
}
