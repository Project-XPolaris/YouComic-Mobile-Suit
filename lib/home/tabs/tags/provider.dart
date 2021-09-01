import 'package:flutter/foundation.dart';
import 'package:youcomic/datasource/tags.dart';

class TagsProvider with ChangeNotifier {
  TagDataSource dataSource = new TagDataSource();
  bool first = true;
  final List<String> typesFilter = List();
  bool randomPick = false;
  onLoadMore() async {
    await dataSource.loadMore();
    notifyListeners();
  }

  onForceReload() async {
    await dataSource.loadTags(true);
    notifyListeners();
  }

  refreshTagTypeFilter(List<String> typeFilter) {
    this.typesFilter.clear();
    this.typesFilter.addAll(typeFilter);
    this.first = true;
    this.onLoad();
  }

  refreshRandom(bool isRandom ) {
    this.randomPick = isRandom;
    this.first = true;
    this.onLoad();
  }

  onLoad() async {
    if (first) {
      first = false;
      dataSource.extraQueryParam = {};
      if (typesFilter.length > 0) {
        dataSource.extraQueryParam["type"] = typesFilter;
      } else {
        dataSource.extraQueryParam.remove("type");
      }
      if (randomPick) {
        dataSource.extraQueryParam["random"] = "1";
      }else{
        dataSource.extraQueryParam.remove("random");
      }
      await dataSource.loadTags(true);
      notifyListeners();
    }
  }
}
