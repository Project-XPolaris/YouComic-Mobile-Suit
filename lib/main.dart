import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/bottom_bar.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/pages/home/drawers/book_filter_drawer.dart';
import 'package:youcomic/pages/home/drawers/tags_filter_drawer.dart';
import 'package:youcomic/pages/home/tabs/books/book_list.dart';
import 'package:youcomic/pages/home/tabs/books/provider.dart';
import 'package:youcomic/pages/home/tabs/home/home.dart';
import 'package:youcomic/pages/home/tabs/my/my.dart';
import 'package:youcomic/pages/home/tabs/tags/provider.dart';
import 'package:youcomic/pages/home/tabs/tags/tags.dart';
import 'package:youcomic/pages/init/init.dart';
import 'package:youcomic/providers/app.dart';
import 'package:youcomic/providers/layout.dart';
import 'package:youcomic/providers/user_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LayoutProvider>(
        create: (_) => LayoutProvider(0),
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
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      initialRoute: "/start",
      routes: {
        "/home": (context) => MyHomePage(),
        "/start": (context) => InitPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BookListProvider bookProvider = BookListProvider();
  TagsProvider tagsProvider = TagsProvider();

  @override
  Widget build(BuildContext rootContext) {
    return Consumer<LayoutProvider>(builder: (context, layoutProvider, child) {
      closeDrawer() => Navigator.pop(rootContext);

      List<Widget> getTabLayout() {
        if (ApplicationConfig().useNanoMode) {
          return [
            BookListPage(
              externalBookListProvider: bookProvider,
            ),
            TagsPage(
              externalTagProvider: tagsProvider,
            )
          ];
        }
        return [
          HomePage(),
          BookListPage(
            externalBookListProvider: bookProvider,
          ),
          TagsPage(
            externalTagProvider: tagsProvider,
          ),
          MyPage()
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
        if (layoutProvider.tabIdx == 2) {
          return HomeTagsFilterDrawer(
            externalTagProvider: tagsProvider,
            onClose: closeDrawer,
          );
        }
        return Container();
      }

      return Scaffold(
        key: _scaffoldKey,
        endDrawer: getDrawer(),
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
