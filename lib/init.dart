import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/static.dart';

initApp(BuildContext context) async {
  ApplicationConfig().loadConfig();
  ApplicationConfig().initDevice(context);
}
