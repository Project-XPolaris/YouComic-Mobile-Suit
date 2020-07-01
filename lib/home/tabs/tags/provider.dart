import 'package:flutter/foundation.dart';
import 'package:youcomic/datasource/tags.dart';

class TagsProvider with ChangeNotifier {
  TagDataSource dataSource = new TagDataSource();
  bool first = true;

  onLoadMore() async {
    await dataSource.loadMore();
    notifyListeners();
  }

  onForceReload() async {
    await dataSource.loadTags(true);
    notifyListeners();
  }

  onLoad() async {
    if (first) {
      first = false;
      dataSource.extraQueryParam = {};
      await dataSource.loadTags(true);
      notifyListeners();
    }
  }
}