import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApplicationConfig {
  var useNanoMode = false;
  String? uid;
  Map<String,dynamic> data = {};
  double width = 600.0;
  static final ApplicationConfig _singleton = ApplicationConfig._internal();

  factory ApplicationConfig() {
    return _singleton;
  }
  String encodeConfig() {
    // to json
    return jsonEncode(data);
  }
  updateConfig(String key,dynamic value) async {
    data[key] = value;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("AppConfig", encodeConfig());
  }
  updateConfigWithMap(Map<String,dynamic> map) async {
    data = {...data,...map};
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("AppConfig", encodeConfig());
  }
  deleteConfig(String key) async {
    data.remove(key);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("AppConfig", encodeConfig());
  }

  getOrDefault(String key,dynamic defaultValue) {
    if (data.containsKey(key)){
      return data[key];
    }
    return defaultValue;
  }

  loadConfig() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var config = sharedPreferences.getString("AppConfig");
    if (config == null){
      return;
    }
    data = jsonDecode(config);
  }

  initDevice(BuildContext context) {
    width = MediaQuery.of(context).size.width;
  }


  ApplicationConfig._internal();
}
