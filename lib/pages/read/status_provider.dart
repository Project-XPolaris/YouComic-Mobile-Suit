
import 'package:flutter/material.dart';

class ReadStatusProvider extends ChangeNotifier{
  int currentDisplayPage = 1;
  bool displayPageJump = false;
  switchPageJumper(){
    displayPageJump = !displayPageJump;
    notifyListeners();
  }
  updateCurrentDisplayPage(int currentPage){
    currentDisplayPage = currentPage;
    notifyListeners();
  }
}