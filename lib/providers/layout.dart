import 'package:flutter/material.dart';

class LayoutProvider with ChangeNotifier {
  int _tabIdx = 0;
  bool isSearching = false;

  LayoutProvider(this._tabIdx);

  void switchSearch(){
    isSearching = !isSearching;
    notifyListeners();
  }
  void setTabIdx(int tabIdx) {
    this._tabIdx = tabIdx;
    notifyListeners();
  }

  get tabIdx => _tabIdx;
}
