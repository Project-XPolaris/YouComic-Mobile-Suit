import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/config/application.dart';
import 'package:youcomic/datasource/database/account_entity.dart';

import '../../main.dart';

class AccountProvider extends ChangeNotifier {
  List<AccountEntity> accounts = List.empty();

  Future loadData() async {
    List<AccountEntity> entities = await AccountEntity.getAccountList();
    this.accounts = entities;
    notifyListeners();
  }

  login(BuildContext context, AccountEntity accountEntity) async {
    if (accountEntity.type == "nano") {
      ApplicationConfig().useNanoMode = true;
    }

    ApiClient().baseUrl = accountEntity.apiUrl;
    var response = await ApiClient().authUser(accountEntity.username, accountEntity.password);
    ApiClient().token = response.data["sign"];

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }
}
