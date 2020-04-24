import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youcomic/api/client.dart';
import 'package:youcomic/api/model/user_auth_entity.dart';
import 'package:youcomic/main.dart';

import 'form.dart';

class LoginProvider with ChangeNotifier {
  onUsernameChange(String username, BuildContext context) {
    Provider.of<FormProvider>(context, listen: false)
        .setValue("pages.login/username", username);
  }

  onPasswordChange(String password, BuildContext context) {
    Provider.of<FormProvider>(context, listen: false)
        .setValue("pages.login/password", password);
  }

  loginUser(context) {
    var provider = Provider.of<FormProvider>(context, listen: false);
    print(provider.getValue("pages.login/username"));
    onLoginSuccess(responseData) async {
      var userAuth = UserAuthEntity().fromJson(responseData);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("sign", userAuth.sign);
      prefs.setInt("uid", userAuth.id);
    }

    ApiClient()
        .authUser(provider.getValue("pages.login/username"),
            provider.getValue("pages.login/password"))
        .then((response) => onLoginSuccess(response.data).then((_) => Navigator.pop(context)));
  }
}
