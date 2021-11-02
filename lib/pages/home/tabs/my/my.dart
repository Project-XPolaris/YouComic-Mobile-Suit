import 'package:flutter/material.dart';
import 'package:youcomic/pages/history/history.dart';
import 'package:youcomic/pages/mycollection/mycollection.dart';
import 'package:youcomic/pages/mytag/mytag.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Container(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 64),
              width: 64,
              height: 64,
              child: CircleAvatar(
                child: Icon(Icons.person,size: 32,),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16,bottom: 32),
              child: Center(
                child: Text("My",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w300),),
              ),
            ),
            Divider(),
            ListTile(
              onTap: (){
                MyCollection.launch(context);
              },
              leading: Icon(Icons.star),
              title: Text("收藏夹"),
            ),
            Divider(),
            ListTile(
              onTap: (){
                MyTagPage.launch(context);
              },
              leading: Icon(Icons.bookmark),
              title: Text("订阅的标签"),
            ),
            Divider(),
            ListTile(
              onTap: (){
                HistoryPage.launch(context);
              },
              leading: Icon(Icons.history),
              title: Text("浏览历史"),
            ),
          ],
        ),
      ),
    );
  }
}
