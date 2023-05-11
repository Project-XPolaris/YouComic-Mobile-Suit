
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:youcomic/api/client.dart';

class ReadStatusProvider extends ChangeNotifier{
  int currentDisplayPage = 1;
  bool displayPageJump = false;
  final int bookId;
  ReadStatusProvider({required this.bookId});
  switchPageJumper(){
    displayPageJump = !displayPageJump;
    notifyListeners();
  }
  updateCurrentDisplayPage(int currentPage){
    currentDisplayPage = currentPage;
    notifyListeners();
  }

  saveReadProgress(int pos){
    EasyDebounce.debounce(
        'saveReadStat',                 // <-- An ID for this particular debouncer
        Duration(milliseconds: 1000),    // <-- The debounce duration
            () => save(pos)                // <-- The target method
    );
  }
  save(int pos)async{
    await ApiClient().createHistory(bookId: bookId,pagePos: pos);
  }
}