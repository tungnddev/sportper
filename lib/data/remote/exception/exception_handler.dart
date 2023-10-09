import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportper/generated/l10n.dart';
import 'package:sportper/utils/widgets/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_exception.dart';

class AppExceptionHandle {
  static void handle(BuildContext context, Object object) {
    if (object is Error) {
      print(object.stackTrace);
    }
    String? error;
    if (object is FirebaseAuthException) {
      switch (object.code) {
        case 'weak-password':
          error = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          error = 'The account already exists for that email.';
          break;
        case 'user-not-found':
          error = 'No user found for that email.';
          break;
        case 'wrong-password':
          error = 'Wrong password provided for that user.';
          break;
      }
    }
    showMessageDialog(context, error ?? object.toString());
  }

  static void showMessageDialog(BuildContext context, String message, {Function()? onDone}) {
    showDialog(
      context: context,
      builder: (_) => MessageAlertDialog(
        message: message,
        done: onDone,
      ),
    );
  }
}
