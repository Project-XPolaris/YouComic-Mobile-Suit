import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/datasource/tags.dart';

class SubscribeProvider with ChangeNotifier {
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dataSource.extraQueryParam = {"subscription": prefs.getInt("uid")};
      await dataSource.loadTags(true);
      notifyListeners();
    }
  }
}
