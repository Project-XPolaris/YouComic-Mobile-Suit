import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/providers/login.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginLayout, builder) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: Colors.black,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            child: Scaffold(
                body: Padding(
              padding: EdgeInsets.only(top: 96, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "登录",
                    style: TextStyle(fontSize: 32),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 64),
                    child: Container(),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: '你的用户名',
                      labelText: "用户名",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) =>
                        loginLayout.onUsernameChange(value, context),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: '你的密码',
                        labelText: "密码",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (String value) =>
                          loginLayout.onPasswordChange(value, context),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          child: Text("登录"),
                          onPressed: () => loginLayout.loginUser(context),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
      },
    );
  }
}
