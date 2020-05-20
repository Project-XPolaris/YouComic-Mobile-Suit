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
            type: BottomNavigationBarType.shifting,
            currentIndex: layoutProvider.tabIdx,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black26,
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
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                title: Text('标签'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                title: Text('历史'),
              ),
            ],
          ),
        );
      },
    );
  }
}
