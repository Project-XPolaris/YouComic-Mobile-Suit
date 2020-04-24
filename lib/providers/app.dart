import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ApplicationProvider with ChangeNotifier {
  bool isLogin;
  onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.containsKey("sign");
  }
}