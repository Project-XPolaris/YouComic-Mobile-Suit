import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/main.dart';
import 'package:youui/layout/login/LoginLayout.dart';

import '../../config/application.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoginLayout(
        onLoginSuccess: (loginAccount) {
          ApiClient().baseUrl = loginAccount.apiUrl!;
          ApiClient().token = loginAccount.token!;
          ApplicationConfig().uid = loginAccount.id;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
        title: "YouComic",
        subtitle: "ProjectXPolaris",
      ),
    );
  }
}
