import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youcomic/datasource/database/account_entity.dart';
import 'package:youcomic/pages/accounts/AccountProvider.dart';

class AccountPage extends StatelessWidget {
  static launch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountProvider(),
      child: Consumer<AccountProvider>(
        builder: (context, accountProvider, builder) {
          accountProvider.loadData();
          return Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black87),
              title: Text(
                "保存的账号",
                style: TextStyle(color: Colors.black87),
              ),
            ),
            body: ListView.separated(
                itemBuilder: (itemContext, idx) {
                  final AccountEntity accountEntity =
                  accountProvider.accounts[idx];
                  return ListTile(
                      title: Text(accountEntity.username),
                      subtitle: Text(
                          "${accountEntity.apiUrl} (${accountEntity.type})"),
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      onTap: () {
                        accountProvider.login(context, accountEntity);
                      });
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemCount: accountProvider.accounts.length)
          );
        },
      ),
    );
  }
}
