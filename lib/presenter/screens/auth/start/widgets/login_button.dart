import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, this.onPress, required this.name, required this.icon, this.padding});
  final Function()? onPress;
  final String name;
  final String icon;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                icon,
                height: 24,
                width: 24,
              ),
              SizedBox(width: 10),
              Text(
                name,
                style: SportperStyle.semiBoldStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
