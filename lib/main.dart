import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/bottom_bar.dart';
import 'package:youcomic/home/drawers/book_filter_drawer.dart';
import 'package:youcomic/home/tabs/favourite/provider.dart';
import 'package:youcomic/home/tabs/history/history.dart';
import 'package:youcomic/home/tabs/home/home.dart';
import 'package:youcomic/home/tabs/tag/tag.dart';
import 'package:youcomic/menu.dart';
import 'package:youcomic/pages/login/Login.dart';
import 'package:youcomic/pages/search/search.dart';
import 'package:youcomic/pages/start/StartPage.dart';
import 'package:youcomic/providers/app.dart';
import 'package:youcomic/providers/form.dart';
import 'package:youcomic/providers/layout.dart';
import 'package:youcomic/providers/login.dart';
import 'package:youcomic/providers/start.dart';
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
      ChangeNotifierProvider<LoginProvider>(
        create: (_) => LoginProvider(),
      ),
      ChangeNotifierProvider<UserProvider>(
        create: (_) => UserProvider(),
      ),
      ChangeNotifierProvider<ApplicationProvider>(
        create: (_) => ApplicationProvider(),
      ),
      ChangeNotifierProvider<StartProvider>(
        create: (_) => StartProvider(),
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  Widget build(BuildContext rootContext) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Consumer<LayoutProvider>(builder: (context, layoutProvider, child) {

      closeDrawer() => Navigator.pop(rootContext);
      return Scaffold(
        key: _scaffoldKey,
        endDrawer: layoutProvider.tabIdx == 1
            ? HomeBookListFilterDrawer(
                onClose: closeDrawer,
              )
            : null,
        appBar: renderAppBar(layoutProvider,context),
        bottomNavigationBar: BottomBar(),
        body: IndexedStack(
          index: layoutProvider.tabIdx,
          children: <Widget>[
            HomePage(),
            BookListPage(),
            FavoritesPage(),
            SubscribePage(),
            HistoryPage()
          ],
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }

  MyHomePage();
}
