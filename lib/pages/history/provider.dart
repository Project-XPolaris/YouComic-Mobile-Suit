import 'package:flutter/widgets.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/datasource/history.dart';
import 'package:youcomic/config/application.dart';

class HistoryProvider with ChangeNotifier {
  HistoryDataSource dataSource = new HistoryDataSource();
  bool first = true;
  bool isLoading = false;

  final VIEW_MODE_KEY = "history/viewMode";
  String viewMode = ApplicationConfig().getOrDefault(
      "history/viewMode", ApplicationConfig().width > 600 ? "Grid" : "List");

  final VIEW_GRID_SIZE_KEY = "history/gridSize";
  String gridSize =
      ApplicationConfig().getOrDefault("history/gridSize", "Medium");

  changeViewMode(String mode) {
    viewMode = mode;
    ApplicationConfig().updateConfig(VIEW_MODE_KEY, mode);
    notifyListeners();
  }

  changeGridSize(String size) {
    gridSize = size;
    ApplicationConfig().updateConfig(VIEW_GRID_SIZE_KEY, size);
    notifyListeners();
  }

  int get gridWidth {
    switch (gridSize) {
      case "Small":
        return 120;
      case "Medium":
        return 180;
      case "Large":
        return 240;
      default:
        return 180;
    }
  }

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

  onDeleteHistory(int id) async {
    await ApiClient().deleteHistory(id);
  }
}
