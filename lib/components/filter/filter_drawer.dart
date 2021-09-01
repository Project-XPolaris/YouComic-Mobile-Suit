import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FilterDrawer extends StatelessWidget {
  final Function onClose;
  final List<Widget> children;
  FilterDrawer({this.onClose, this.children});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Filter",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                    IconButton(
                      onPressed: () {
                        onClose();
                      },
                      icon: Icon(Icons.close),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: children,
                ),
              )
            ],
          )),
    );
  }
}
