import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/pages/history/history.dart';
import 'package:youcomic/pages/mycollection/mycollection.dart';
import 'package:youcomic/pages/mytag/mytag.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/pages/init/init.dart';

import '../../../../menu.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(context, actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: "logout",
              child: Text("登出"),
            )
          ],
          onSelected: (value) async {
            if (value == "logout") {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.remove('sign');
              await prefs.remove('apiUrl');
              await prefs.remove('uid');
              ApiClient().token = "";
              ApiClient().baseUrl = "";
              ApplicationConfig().uid = null;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const InitPage()),
                (route) => false,
              );
            }
          },
        )
      ]),
      key: key,
      body: Container(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 64),
              width: 120,
              height: 120,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.person_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 32),
              child: Center(
                child: Text(
                  "My",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                MyCollection.launch(context);
              },
              leading: Icon(Icons.star_rounded),
              title: Text("收藏夹"),
            ),
            ListTile(
              onTap: () {
                MyTagPage.launch(context);
              },
              leading: Icon(Icons.bookmark_rounded),
              title: Text("订阅的标签"),
            ),
            ListTile(
              onTap: () {
                HistoryPage.launch(context);
              },
              leading: Icon(Icons.history_rounded),
              title: Text("浏览历史"),
            ),
          ],
        ),
      ),
    );
  }
}
