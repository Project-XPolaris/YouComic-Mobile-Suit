import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/pages/login/Login.dart';
import 'package:youcomic/providers/user_provider.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var login = Center(
      child: RaisedButton(
        child: Text("登录"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
    Provider.of<UserProvider>(context).onLoad();
    return Consumer<UserProvider>(builder: (context, userProvider, builder) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 120),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.blue,
              ),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text(userProvider.nickname,style: TextStyle(fontSize: 24),),
              ),
            ],
          ),
        ),
      );
    });
  }
}
