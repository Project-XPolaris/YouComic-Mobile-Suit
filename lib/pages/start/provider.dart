import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/datasource/database/account_entity.dart';
import 'package:youcomic/main.dart';

class StartProvider extends ChangeNotifier {
  var username = "";
  var password = "";
  var apiUrl = "";

  StartProvider({this.username, this.password, this.apiUrl});

  onUsernameChange(String username) {
    this.username = username;
  }

  onPasswordChange(String password) {
    this.password = password;
  }

  onApiUrlChange(String url) {
    this.apiUrl = url;
  }

  loginAsNano(BuildContext context) async {
    login(context, "nano");
  }

  loginAccount(BuildContext context) async {
    login(context, "server");
  }

  login(BuildContext context, String mode) async {
    if (mode == "nano") {
      ApplicationConfig().useNanoMode = true;
    }
    ApiClient().baseUrl = apiUrl;
    var response = await ApiClient().authUser(username, password);
    ApiClient().token = response.data["sign"];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("apiUrl", apiUrl);
    prefs.setString("username", username);
    prefs.setString("password", password);
    prefs.setInt("uid", response.data["id"]);
    prefs.setString("sign", response.data["sign"]);

    // save
    AccountEntity accountEntity = AccountEntity(
        username: username, password: password, type: mode, apiUrl: apiUrl);
    AccountEntity.add(accountEntity);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }
}
