import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/config/application.dart';

Future<bool> initApp(BuildContext context) async {
  await ApplicationConfig().loadConfig();
  ApplicationConfig().initDevice(context);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? apiUrl = prefs.getString('apiUrl');
  final String? sign = prefs.getString('sign');
  if (apiUrl != null && apiUrl.isNotEmpty && sign != null && sign.isNotEmpty) {
    ApiClient().baseUrl = apiUrl;
    ApiClient().token = sign;
    return true;
  }
  return false;
}
