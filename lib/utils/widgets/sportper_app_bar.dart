import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class SportperAppBar extends StatelessWidget {
  final Function()? onPressIcon;
  final String title;
  final double sizeIcon = 24;
  final Widget? rightWidget;

  const SportperAppBar({Key? key, this.onPressIcon, this.title = '', this.rightWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressIcon ?? () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Image.asset(ImagePaths.icBack, width: sizeIcon, height: sizeIcon,),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              title.toUpperCase(),
              style: SportperStyle.semiBoldStyle.copyWith(fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        rightWidget ?? Container(width: sizeIcon + 16 * 2,)
      ],
    );
  }
}
