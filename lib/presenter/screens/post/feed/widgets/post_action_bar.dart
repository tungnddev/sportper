import 'package:flutter/material.dart';
import 'package:sportper/presenter/models/post_vm.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class PostActionBar extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final Function()? onTapLike;
  final Function()? onTapComment;

  const PostActionBar(
      {Key? key,
      required this.isLiked,
      required this.likeCount,
      required this.commentCount,
      this.onTapLike,
      this.onTapComment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 1,
          color: ColorUtils.border,
        ),
        SizedBox(height: 5,),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onTapLike,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      isLiked ? ImagePaths.icHeartFill : ImagePaths.icHeart,
                      width: 27,
                      height: 27,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      '$likeCount',
                      style: SportperStyle.mediumStyle
                          .copyWith(color: ColorUtils.colorTheme),
                    )
                  ],
              ),
                ),
              ),
            ),
            Container(
              width: 1,
              color: ColorUtils.border,
              height: 40,
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTapComment,
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImagePaths.icComment,
                      width: 27,
                      height: 27,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      '$commentCount',
                      style: SportperStyle.mediumStyle
                          .copyWith(color: ColorUtils.colorTheme),
                    )
                  ],
              ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
