import 'package:flutter/cupertino.dart';
import 'package:sportper/generated/l10n.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/extensions/extensions.dart';


class LoginVM {
  String email;
  String password;

  LoginVM({this.email = "", this.password = ""});

  bool isNotEmpty() => email.isNotEmpty && password.isNotEmpty;

  String? getErrorMessage(BuildContext context) {
    if (!email.validateEmail) {
      return Strings.invalidEmail;
    }
    if (password.length < 6) {
      return Strings.passwordMustBe6;
    }
    return null;
  }
}