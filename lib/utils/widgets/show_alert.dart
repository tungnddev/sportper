import 'package:flutter/material.dart';
import 'package:sportper/utils/widgets/confirm_alert.dart';

void showConfirmDialog(BuildContext context, String message,
    {Function()? onConfirm}) {
  showDialog(
    context: context,
    builder: (_) => ConfirmAlertDialog(
      message: message,
      confirm: onConfirm,
    ),
  );
}
