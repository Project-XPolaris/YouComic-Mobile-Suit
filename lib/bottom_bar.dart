import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/providers/layout.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> getBottomBarItems() {
      if (ApplicationConfig().useNanoMode) {
        return [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
            ),
            label: '书籍',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '标签',
          )
        ];
      }
      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label:'主页',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
          ),
          label: '书籍',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.tag,
          ),
          label: '标签',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '我的',
        )
      ];
    }

    return Consumer<LayoutProvider>(
      builder: (context, layoutProvider, child) {
        return Container(
          child: BottomNavigationBar(
            type: ApplicationConfig().useNanoMode?BottomNavigationBarType.fixed:BottomNavigationBarType.shifting,
            currentIndex: layoutProvider.tabIdx,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black26,
            onTap: layoutProvider.setTabIdx,
            items: [...getBottomBarItems()],
          ),
        );
      },
    );
  }
}
