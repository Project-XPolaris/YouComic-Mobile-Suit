import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/providers/layout.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<NavigationDestination> getBottomBarItems() {
      if (ApplicationConfig().useNanoMode) {
        return [
          NavigationDestination(
            icon: Icon(
              Icons.book_rounded,
            ),
            label: '书籍',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_rounded),
            label: '标签',
          )
        ];
      }
      return [
        NavigationDestination(
          icon: Icon(Icons.home_rounded),
          label:'主页',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.book_rounded,
          ),
          label: '书籍',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.tag_rounded,
          ),
          label: '标签',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_rounded),
          label: '我的',
        )
      ];
    }

    return Consumer<LayoutProvider>(
      builder: (context, layoutProvider, child) {
        return Container(
          child: NavigationBar(
            selectedIndex: layoutProvider.tabIdx,
            onDestinationSelected: layoutProvider.setTabIdx,
            destinations: [...getBottomBarItems()],
          ),
        );
      },
    );
  }
}
