import 'package:flutter/material.dart';
import 'package:youcomic/pages/history/history.dart';
import 'package:youcomic/pages/mycollection/mycollection.dart';
import 'package:youcomic/pages/mytag/mytag.dart';

import '../../../../menu.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(context),
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
                child: Icon(Icons.person_rounded,size: 64,color: Theme.of(context).colorScheme.onPrimaryContainer,),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16,bottom: 32),
              child: Center(
                child: Text("My",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w300),),
              ),
            ),
            ListTile(
              onTap: (){
                MyCollection.launch(context);
              },
              leading: Icon(Icons.star_rounded),
              title: Text("收藏夹"),
            ),
            ListTile(
              onTap: (){
                MyTagPage.launch(context);
              },
              leading: Icon(Icons.bookmark_rounded),
              title: Text("订阅的标签"),
            ),
            ListTile(
              onTap: (){
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
