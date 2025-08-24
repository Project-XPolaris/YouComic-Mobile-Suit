import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/main.dart';
import 'package:youui/layout/login/LoginLayout.dart';

import '../../config/application.dart';
import 'youauth_md.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: LoginLayout(
                onLoginSuccess: (loginAccount) {
                  ApiClient().baseUrl = loginAccount.apiUrl!;
                  ApiClient().token = loginAccount.token!;
                  ApplicationConfig().uid = loginAccount.id;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                title: "YouComic",
                subtitle: "ProjectXPolaris",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.dashboard),
                label: const Text("使用 MediaDashboard 登录并选择服务"),
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const MdLoginPage()),
                  );
                  if (result == true) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
