import 'package:flutter/material.dart';

class RippleInkWell extends StatelessWidget {
  final Function()? onTap;
  final Widget child;

  RippleInkWell({this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
