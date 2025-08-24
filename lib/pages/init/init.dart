import 'package:flutter/material.dart';
import 'package:youcomic/init.dart';
import 'package:youcomic/main.dart';
import 'package:youcomic/pages/start/StartPage.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: initApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        final bool isAuthed = snapshot.data == true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => isAuthed ? MyHomePage() : StartPage(),
            ),
          );
        });
        return const SizedBox.shrink();
      },
    );
  }
}
