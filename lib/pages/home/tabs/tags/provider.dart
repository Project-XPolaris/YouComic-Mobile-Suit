import 'package:flutter/foundation.dart';
import 'package:youcomic/datasource/tags.dart';

class TagsProvider with ChangeNotifier {
  TagDataSource dataSource = new TagDataSource();
  bool first = true;
  final List<String> typesFilter = [];
  List<String> orderFilter = ["-id"];
  bool random = false;


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


  updateOrderFilter(newFilter) {
    print(newFilter);
    if (newFilter[0] == "random") {
      random = true;
    }
    orderFilter = newFilter;
    first = true;
    notifyListeners();
    onLoad();
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
      if (random) {
        dataSource.extraQueryParam["random"] = "1";
      }else{
        dataSource.extraQueryParam["order"] =  orderFilter[0];
      }
      print(dataSource.extraQueryParam);
      await dataSource.loadTags(true);
      notifyListeners();
    }
  }
}
