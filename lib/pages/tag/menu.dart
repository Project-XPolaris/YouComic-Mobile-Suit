import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youcomic/pages/tag/provider.dart';
List<Widget> renderAction(TagProvider provider) {
  GlobalKey scKey = new GlobalKey();
  _onSelectActionMenu(String action) async {
    if (action == "add") {
      await provider.onSubscribe();
      final snackBar = SnackBar(content: Text('添加成功'));
      var buildContext = scKey.currentContext;
      if (buildContext != null) {
        Scaffold.of(buildContext).showSnackBar(snackBar);
      }
    }

    if (action == "remove") {
      await provider.onCancelSubscribe();
      final snackBar = SnackBar(content: Text('已取消订阅'));
      var buildContext = scKey.currentContext;
      if (buildContext != null) {
        Scaffold.of(buildContext).showSnackBar(snackBar);
      }
    }
  }

  List<PopupMenuItem<String>> menuOptions = [];
  switch (provider.subscribeStatus) {
    case SubscribeStatus.Subscribed:
      menuOptions.add(
          PopupMenuItem<String>(
            value: "remove",
            child: Text('取消订阅'),
          )
      );
      break;
    case SubscribeStatus.UnSubscribed:
      menuOptions.add(
          PopupMenuItem<String>(
            value: "add",
            child: Text('订阅标签'),
          )
      );
      break;
  }
  var actions = <Widget>[
    // overflow menu
    PopupMenuButton<String>(
      key: scKey,
      onSelected: _onSelectActionMenu,
      itemBuilder: (BuildContext context) {
        return menuOptions;
      },
    ),
  ];
  return actions;
}
