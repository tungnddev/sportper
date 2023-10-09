import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sportper/domain/entities/base_user.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class PostInfoLine extends StatelessWidget {
  final BaseUser user;
  final String time;

  const PostInfoLine({Key? key, required this.time, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: () => _handleOpenProfile(context),
            child: AvatarCircle(size: 45, url: user.avatar)),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _handleOpenProfile(context),
                child: Text(
                  user.fullName,
                  style: SportperStyle.semiBoldStyle
                      .copyWith(color: ColorUtils.colorTheme),
                ),
              ),
              Text(
                time,
                style: SportperStyle.baseStyle
                    .copyWith(fontSize: 13, color: ColorUtils.disableText),
              )
            ],
          ),
        )
      ],
    );
  }

  _handleOpenProfile(BuildContext context) {
    Navigator.pushNamed(context, Routes.profile, arguments: user.id);
  }
}
