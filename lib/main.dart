import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/bottom_bar.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/home/drawers/book_filter_drawer.dart';
import 'package:youcomic/home/drawers/tags_filter_drawer.dart';
import 'package:youcomic/home/tabs/books/provider.dart';
import 'package:youcomic/home/tabs/favourite/provider.dart';
import 'package:youcomic/home/tabs/history/history.dart';
import 'package:youcomic/home/tabs/home/home.dart';
import 'package:youcomic/home/tabs/tag/tag.dart';
import 'package:youcomic/home/tabs/tags/provider.dart';
import 'package:youcomic/home/tabs/tags/tags.dart';
import 'package:youcomic/menu.dart';
import 'package:youcomic/pages/login/Login.dart';
import 'package:youcomic/pages/start/StartPage.dart';
import 'package:youcomic/providers/app.dart';
import 'package:youcomic/providers/form.dart';
import 'package:youcomic/providers/layout.dart';
import 'package:youcomic/providers/login.dart';
import 'package:youcomic/providers/user_provider.dart';

import 'home/tabs/books/book_list.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LayoutProvider>(
        create: (_) => LayoutProvider(0),
      ),
      ChangeNotifierProvider<FormProvider>(
        create: (_) => FormProvider(),
      ),
      ChangeNotifierProvider<UserProvider>(
        create: (_) => UserProvider(),
      ),
      ChangeNotifierProvider<ApplicationProvider>(
        create: (_) => ApplicationProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouComic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/start",
      routes: {
        "/home": (context) => MyHomePage(),
        "/start": (context) => StartPage(),
        "/login": (context) => LoginPage()
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext rootContext) {
    return Consumer<LayoutProvider>(builder: (context, layoutProvider, child) {
      closeDrawer() => Navigator.pop(rootContext);
      BookListProvider bookProvider = BookListProvider();
      TagsProvider tagsProvider = TagsProvider();
      List<Widget> getTabLayout() {
        if (ApplicationConfig().useNanoMode) {
          return [
            BookListPage(
              externalBookListProvider: bookProvider,
            ),
            TagsPage(externalTagProvider: tagsProvider,)
          ];
        }
        return [
          HomePage(),
          BookListPage(
            externalBookListProvider: bookProvider,
          ),
          FavoritesPage(),
          SubscribePage(),
          HistoryPage()
        ];
      }

      Widget getDrawer() {
        if (ApplicationConfig().useNanoMode) {
          if (layoutProvider.tabIdx == 0) {
            return HomeBookListFilterDrawer(
              onClose: closeDrawer,
              externalBookListProvider: bookProvider,
            );
          }
          if (layoutProvider.tabIdx == 1) {
            return HomeTagsFilterDrawer(
              externalTagProvider: tagsProvider,
              onClose: closeDrawer,
            );
          }
        }

        if (layoutProvider.tabIdx == 1) {
          return HomeBookListFilterDrawer(
            onClose: closeDrawer,
            externalBookListProvider: bookProvider,
          );
        }
      }

      return Scaffold(
        key: _scaffoldKey,
        endDrawer: getDrawer(),
        appBar: renderAppBar(layoutProvider, context),
        bottomNavigationBar: BottomBar(),
        body: IndexedStack(
          index: layoutProvider.tabIdx,
          children: <Widget>[...getTabLayout()],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }

  MyHomePage();
}
