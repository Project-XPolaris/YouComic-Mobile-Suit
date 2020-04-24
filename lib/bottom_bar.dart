import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/providers/layout.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProvider>(
      builder: (context, layoutProvider, child) {
        return Container(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: layoutProvider.tabIdx,
            onTap: layoutProvider.setTabIdx,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('主页'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book,),
                title: Text('书籍'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                title: Text('收藏'),
              ),
            ],
          ),
        );
      },
    );
  }
}
