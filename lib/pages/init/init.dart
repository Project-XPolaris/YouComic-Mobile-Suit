import 'package:flutter/material.dart';
import 'package:youcomic/init.dart';
import 'package:youcomic/pages/start/StartPage.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    StartPage(
                    )),
          );
        });
        return Container();
      }
      return Container();
    },future: initApp(context),);
  }
}
