import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmptyView extends StatelessWidget {
  final bool isLoading;
  final Icon icon;
  final String text;
  final Function() onRefresh;
  EmptyView({this.isLoading = false,required this.icon,this.text = "",required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final List<Widget> loadingAction = [
      Container(
        width: 200,
        child: LinearProgressIndicator(
          semanticsLabel: "加载中",
        ),
      ),
    ];
    final List<Widget> unAction = [
      Text(
        text,
        style: TextStyle(fontSize: 22),
      ),
      ElevatedButton(
        onPressed: onRefresh,
        child: Text(
          "重新加载",
        ),
      ),
    ];
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
          ]..addAll(isLoading?loadingAction : unAction),
        ),
      ),
    );
  }
}
