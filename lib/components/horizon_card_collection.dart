import 'package:flutter/material.dart';

class HorizonCardCollection extends StatelessWidget {
  final Widget child;
  final String title;
  final double height;
  HorizonCardCollection({this.child, this.title,this.height = 260});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              this.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            height: this.height,
            child: this.child,
          )
        ],
      ),
    );
  }
}
