import 'package:flutter/material.dart';
import 'package:sportper/domain/entities/base_user.dart';
import 'package:sportper/presenter/screens/post/feed/widgets/post_info_line.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class PostInfoLineWithLike extends StatelessWidget {
  final BaseUser user;
  final String time;
  final bool isLiked;
  final int likeCount;
  final Function()? onTapLike;
  const PostInfoLineWithLike({Key? key, required this.user, required this.time, required this.isLiked, required this.likeCount, this.onTapLike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: PostInfoLine(time: time, user: user)),
        SizedBox(width: 10,),
        GestureDetector(
          onTap: onTapLike,
          child: Image.asset(
            isLiked ? ImagePaths.icHeartFill : ImagePaths.icHeart,
            width: 28,
            height: 28,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          '$likeCount',
          style: SportperStyle.mediumStyle
              .copyWith(color: ColorUtils.colorTheme),
        )
      ],
    );
  }
}
