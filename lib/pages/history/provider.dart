import 'package:flutter/widgets.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/datasource/history.dart';

class HistoryProvider with ChangeNotifier {
  HistoryDataSource dataSource = new HistoryDataSource();
  bool first = true;
  bool isLoading = false;
  onLoadMore() async {
    await dataSource.loadMore();
    notifyListeners();
  }

  onForceReload() async {
    isLoading = true;
    notifyListeners();
    await dataSource.loadData(true);
    isLoading = false;
    notifyListeners();
  }

  onLoad() async {
    if (first) {
      isLoading = true;
      first = false;
      dataSource.extraQueryParam = {};
      await dataSource.loadData(true);
      isLoading = false;
      notifyListeners();
    }
  }
  onDeleteHistory(int id) async{
    await ApiClient().deleteHistory(id);
  }
}
