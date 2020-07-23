import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/pages/start/provider.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasData){
          return ChangeNotifierProvider(
            create: (_) => StartProvider(
                username: snapshot.data.getString("username"),
                password: snapshot.data.getString("password"),
                apiUrl: snapshot.data.getString("apiUrl"),
            ),
            child: Consumer<StartProvider>(
              builder: (context, startProvider, builder) {
                return Scaffold(
                  body: Container(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 120, left: 16, right: 16),
                                child: Center(
                                  child: Text(
                                    "YouComic",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )),
                            Padding(
                              padding:
                              EdgeInsets.only(top: 48, left: 16, right: 16),
                              child: TextFormField(
                                initialValue: startProvider.apiUrl,
                                decoration: const InputDecoration(
                                  hintText: 'YouComic服务地址',
                                  labelText: "YouComic服务地址",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: startProvider.onApiUrlChange,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '请输入地址';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(top: 12, left: 16, right: 16),
                              child: TextFormField(
                                initialValue: startProvider.username,
                                decoration: const InputDecoration(
                                  hintText: '用户名',
                                  labelText: "用户名",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: startProvider.onUsernameChange,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '请输入用户名';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(top: 12, left: 16, right: 16),
                              child: TextFormField(
                                obscureText: true,
                                initialValue: startProvider.password,
                                decoration: const InputDecoration(
                                  hintText: '密码',
                                  labelText: "密码",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: startProvider.onPasswordChange,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '请输入密码';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 8.0),
                              child: FlatButton(
                                child: Text("以YouComic Nano登入"),
                                color: Colors.pink,
                                textColor: Colors.white,
                                onPressed: () {
                                  startProvider.loginAsNano(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 8.0),
                              child: FlatButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                onPressed: () {
                                  startProvider.loginAccount(context);
                                },
                                child: Text("登录"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
