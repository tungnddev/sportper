import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/text.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Color(0x88000000),
        pageBuilder: (_, __, ___) => LoadingView());
  }

  static void showInvisible(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => Container());
  }
}
