import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/pages/accounts/AccountPage.dart';
import 'package:youcomic/pages/start/provider.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.hasData) {
          return ChangeNotifierProvider(
            create: (_) => StartProvider(
              username: snapshot.data?.getString("username") ?? "",
              password: snapshot.data?.getString("password") ?? "",
              apiUrl: snapshot.data?.getString("apiUrl") ?? "",
            ),
            child: Consumer<StartProvider>(
              builder: (rootContext, startProvider, builder) {

                return Scaffold(
                  body: Builder(
                    builder: (builderContext) {
                      return Container(
                        child: SingleChildScrollView(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 32,
                                        left: 16,
                                        right: 16,
                                    ),
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child: FlatButton(
                                        onPressed: (){
                                          if (startProvider.loginMode == StartProvider.YOUCOMIC_SERVER_MODE){
                                            startProvider.changeLoginModel(StartProvider.YOUCOMIC_NANO_MODE);
                                          }else{
                                            startProvider.changeLoginModel(StartProvider.YOUCOMIC_SERVER_MODE);
                                          }
                                        },
                                        child: Text(
                                          startProvider.loginMode ==
                                                  StartProvider
                                                      .YOUCOMIC_SERVER_MODE
                                              ? "以 Nano 登录"
                                              : "以Service登录",
                                          style: TextStyle(color: startProvider.loginMode ==
                                              StartProvider
                                                  .YOUCOMIC_SERVER_MODE
                                              ? Colors.pink
                                              : Colors.blue),
                                        ),
                                      ),
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 48,
                                        left: 16,
                                        right: 16,
                                        bottom: 36),
                                    child: Center(
                                      child: Image.asset(
                                        "icon/launcher.png",
                                        width: 96,
                                        height: 96,
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 48, left: 32, right: 32),
                                  child: TextFormField(
                                    initialValue: startProvider.apiUrl,
                                    cursorColor: startProvider.mainColor,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: startProvider.mainColor)
                                      ),
                                      hintStyle: TextStyle(
                                        color: startProvider.mainColor
                                      ),
                                      labelStyle: TextStyle(
                                        color:startProvider.mainColor
                                      ),

                                      hintText: 'YouComic服务地址',
                                      labelText: "YouComic服务地址",
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: startProvider.onApiUrlChange,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '请输入地址';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 12, left: 32, right: 32),
                                  child: TextFormField(
                                    initialValue: startProvider.username,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: startProvider.mainColor)
                                      ),
                                      hintStyle: TextStyle(
                                          color: startProvider.mainColor
                                      ),
                                      labelStyle: TextStyle(
                                          color:startProvider.mainColor
                                      ),
                                      hintText: '用户名',
                                      labelText: "用户名",
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: startProvider.onUsernameChange,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '请输入用户名';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 12, left: 32, right: 32),
                                  child: TextFormField(
                                    obscureText: true,
                                    initialValue: startProvider.password,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: startProvider.mainColor)
                                      ),
                                      hintStyle: TextStyle(
                                          color: startProvider.mainColor
                                      ),
                                      labelStyle: TextStyle(
                                          color:startProvider.mainColor
                                      ),
                                      hintText: '密码',
                                      labelText: "密码",
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: startProvider.onPasswordChange,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '请输入密码';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 32, right: 32, top: 8.0),
                                  child: FlatButton(
                                    color: startProvider.mainColor,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      startProvider
                                          .loginAccount(builderContext);
                                    },
                                    child: Text("登录"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 32, right: 32, top: 8.0),
                                  child: FlatButton(
                                    child: Text("已保存的账号"),
                                    color: startProvider.mainColor,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      AccountPage.launch(rootContext);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
