import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/datasource/tags.dart';

class SubscribeProvider with ChangeNotifier {
  TagDataSource dataSource = new TagDataSource();
  bool first = true;
  Map<String,String?> _getExtraParams(){
    return{
      "subscription": ApplicationConfig().uid,
      "page_size":"100"
    };
  }
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
      dataSource.extraQueryParam = _getExtraParams();
      await dataSource.loadTags(true);
      notifyListeners();
    }
  }
}
