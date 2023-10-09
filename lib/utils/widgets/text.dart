import 'package:flutter/material.dart';

import '../definded/colors.dart';

class TextNormal extends StatelessWidget {
  final String content;
  final double size;
  final Color color;
  final TextAlign align;
  final TextDecoration decoration;
  final int maxLine;
  final FontWeight fontWeight;

  static const REGULAR = FontWeight.w400;
  static const MEDIUM = FontWeight.w500;
  static const SEMI_BOLD = FontWeight.w600;
  static const BOLD = FontWeight.w700;

  // static const SF_TEXT = "sf_text";
  // static const SF_DISPLAY = "sf_display";

  TextNormal(
      {this.content = "",
        this.size = 15,
        this.color = ColorUtils.colorText,
        this.align = TextAlign.start,
        this.decoration = TextDecoration.none,
        this.maxLine = 1000,
        this.fontWeight = REGULAR,});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
          fontSize: size,
          color: color,
          decoration: decoration,
          fontWeight: fontWeight),
      textAlign: align,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class TextSemiBoldNormal extends StatelessWidget {
  final String content;
  final double size;
  final Color color;
  final TextAlign align;
  final TextDecoration decoration;
  final int maxLine;

  TextSemiBoldNormal(
      {this.content = "",
        this.size = 14,
        this.color = ColorUtils.colorText,
        this.align = TextAlign.start,
        this.decoration = TextDecoration.none,
        this.maxLine = 1000});

  @override
  Widget build(BuildContext context) {
    return TextNormal(
      color: color,
      size: size,
      content: content,
      align: align,
      decoration: decoration,
      maxLine: maxLine,
      fontWeight: TextNormal.SEMI_BOLD,
    );
  }
}

class TextBoldNormal extends StatelessWidget {
  final String content;
  final Color color;
  final double size;
  final TextAlign align;
  final int maxLines;

  TextBoldNormal(
      {this.content = "",
        this.color = ColorUtils.colorText,
        this.size = 14,
        this.align = TextAlign.start,
        this.maxLines = 1000});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        fontSize: this.size,
        fontWeight: FontWeight.w700,
        color: this.color,
      ),
      textAlign: this.align,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

