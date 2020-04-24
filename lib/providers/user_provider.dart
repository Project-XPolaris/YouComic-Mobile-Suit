import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/user_entity.dart';

class UserProvider with ChangeNotifier {
  bool isUserLogin;
  int uid = -1;
  String nickname = "未知";

  onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentUid = prefs.getInt("uid");
    if (this.uid != currentUid) {
      var response = await ApiClient().fetchUser(currentUid);
      var user = UserEntity().fromJson(response.data);
      this.uid = user.id;
      this.nickname = user.nickname;
      notifyListeners();
    }
  }
}
