import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/main.dart';

class StartProvider extends ChangeNotifier {
  var storeUsername = "";
  var username = "";
  var password = "";
  var apiUrl = "";

  onLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (this.username.length == 0 && prefs.containsKey("username")) {
      this.username = prefs.getString("username");
    }
    if (this.password.length == 0 && prefs.containsKey("password")) {
      this.password = prefs.getString("password");
    }
    if (this.apiUrl.length == 0 && prefs.containsKey("apiUrl")) {
      this.apiUrl = prefs.getString("apiUrl");
    }
    return;
  }

  onUsernameChange(String username) {
    this.username = username;
  }

  onPasswordChange(String password) {
    this.password = password;
    notifyListeners();
  }

  onApiUrlChange(String url) {
    this.apiUrl = url;
  }

  loginAsNano(BuildContext context) async {
    ApplicationConfig().useNanoMode = true;
    login(context);
  }

  loginAccount(BuildContext context) async {
    login(context);
  }

  login(BuildContext context) async {
    ApiClient().baseUrl = apiUrl;
    var response = await ApiClient().authUser(username, password);
    ApiClient().token = response.data["sign"];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("apiUrl", apiUrl);
    prefs.setString("username", username);
    prefs.setString("password", password);
    prefs.setInt("uid", response.data["id"]);
    prefs.setString("sign", response.data["sign"]);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }
}
