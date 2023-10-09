import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/colors.dart';

import 'text_style.dart';

class SportperButton extends StatelessWidget {

  final Function()? onPress;
  final String text;
  final Color? colorButton;

  const SportperButton({Key? key, required this.text, this.onPress, this.colorButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: CupertinoButton(
        onPressed: onPress,
        disabledColor: ColorUtils.grayBackButton,
        child: Text(
          text,
          style: SportperStyle.semiBoldStyle.copyWith(color: Colors.white, fontSize: 15),
        ),
        color: colorButton ?? Theme.of(context).primaryColor,
        padding: EdgeInsets.only(top: 0, bottom: 0),
        minSize: 50,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
