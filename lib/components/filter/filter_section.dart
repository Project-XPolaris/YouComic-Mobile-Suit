import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  final Widget child;
  final bool showDivider;
  final String title;
  FilterSection({this.child, this.showDivider = false,this.title}) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black26),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: child,
        ),
        showDivider? Divider() : Container()
      ],
    );
  }
}
