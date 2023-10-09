import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/colors.dart';

class SportperStyle {
  static TextStyle baseStyle = TextStyle(
      fontSize: 15, color: ColorUtils.colorText, fontWeight: FontWeight.w400, fontFamily: 'Avenir');

  static TextStyle boldStyle = baseStyle.copyWith(fontWeight: FontWeight.bold);

  static TextStyle semiBoldStyle =
      baseStyle.copyWith(fontWeight: FontWeight.w600);

  static TextStyle mediumStyle =
      baseStyle.copyWith(fontWeight: FontWeight.w500);

  static InputDecoration inputDecoration(String label) => InputDecoration(
        isDense: true,
        counterText: "",
        labelText: label,
        alignLabelWithHint: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: baseStyle.copyWith(color: ColorUtils.disableText),
        floatingLabelStyle:
            baseStyle.copyWith(color: ColorUtils.disableText, fontSize: 13),
        contentPadding: EdgeInsets.fromLTRB(11, 13, 11, 12),
        errorStyle: TextStyle(fontSize: 13, height: 1),
      );
}
