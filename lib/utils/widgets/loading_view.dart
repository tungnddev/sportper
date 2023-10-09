import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final double size, strokeWidth;

  LoadingView({this.size = 30, this.strokeWidth = 3});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
            strokeWidth: strokeWidth,
          ),
          width: size,
          height: size,
        ));
  }
}