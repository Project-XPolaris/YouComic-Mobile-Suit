import 'package:flutter/material.dart';

class DetailSection extends StatelessWidget {
  final Widget child;
  final String title;

  DetailSection({this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            title,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w300),
          ),
        ),
        child,
      ],
    );
  }
}
