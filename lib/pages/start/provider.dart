import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/error.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/datasource/database/account_entity.dart';
import 'package:youcomic/main.dart';

class StartProvider extends ChangeNotifier {
  var username = "";
  var password = "";
  var apiUrl = "";
  Color mainColor = Colors.blue;
  String loginMode = YOUCOMIC_SERVER_MODE;

  StartProvider({required this.username, required this.password, required this.apiUrl});

  static final String YOUCOMIC_SERVER_MODE = "Server";
  static final String YOUCOMIC_NANO_MODE = "Nano";

  onUsernameChange(String username) {
    this.username = username;
  }

  onPasswordChange(String password) {
    this.password = password;
  }

  onApiUrlChange(String url) {
    this.apiUrl = url;
  }

  changeLoginModel(String mode) {
    if (mode == YOUCOMIC_SERVER_MODE) {
      mainColor = Colors.blue;
    }

    if (mode == YOUCOMIC_NANO_MODE) {
      mainColor = Colors.pink;
    }
    loginMode = mode;
    notifyListeners();
  }


  loginAccount(BuildContext context) async {
    login(context, loginMode);
  }

  String formatApiUrl(String url) {
    Uri rawUri = Uri.parse(url);
    return Uri(
            scheme: rawUri.hasScheme ? rawUri.scheme : "http",
            port: rawUri.hasPort ? rawUri.port : 8880,
            host: rawUri.host.isEmpty ? apiUrl : rawUri.host)
        .toString();
  }

  login(BuildContext context, String mode) async {
    if (mode == YOUCOMIC_NANO_MODE) {
      ApplicationConfig().useNanoMode = true;
    }
    String formatUrl = formatApiUrl(apiUrl);
    ApiClient().baseUrl = formatUrl;
    try {
      var response = await ApiClient().authUser(username, password);
      ApiClient().token = response.data["sign"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("apiUrl", formatUrl);
      prefs.setString("username", username);
      prefs.setString("password", password);
      prefs.setInt("uid", response.data["id"]);
      prefs.setString("sign", response.data["sign"]);

      // save
      AccountEntity accountEntity = AccountEntity(
          username: username,
          password: password,
          type: mode,
          apiUrl: formatUrl);
      AccountEntity.add(accountEntity);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        ApiResponse apiError = ApiResponse.fromDioError(e);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(apiError.reason ?? ""),
        ));
      }
    }
  }
}
