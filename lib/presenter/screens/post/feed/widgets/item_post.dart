import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sportper/presenter/models/post_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/post/feed/widgets/post_action_bar.dart';
import 'package:sportper/presenter/screens/post/feed/widgets/readmore_text.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'post_info_line.dart';

class PostItemWidget extends StatelessWidget {
  final PostVM vm;
  final Function()? onTap;
  final Function()? onTapLike;
  final Function()? onTapComment;

  const PostItemWidget(
      {Key? key,
      required this.vm,
      this.onTap,
      this.onTapLike,
      this.onTapComment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraint) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PostInfoLine(user: vm.entity.user, time: vm.time),
              SizedBox(
                height: 10,
              ),
              ReadMoreText(
                content: vm.entity.content,
                onReadMore: onTap,
              ),
              SizedBox(
                height: 5,
              ),
              if (vm.entity.image.isNotEmpty && vm.entity.image[0].isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.photoView, arguments: vm.entity.image[0]);
                  },
                  child: CacheImage(
                    url: vm.entity.image[0],
                    width: constraint.maxWidth,
                    height: constraint.maxWidth,
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              PostActionBar(
                isLiked: vm.isLiked,
                likeCount: vm.likeCount,
                commentCount: vm.entity.commentCount,
                onTapComment: onTapComment,
                onTapLike: onTapLike,
              )
            ],
          ),
        ),
      ),
    );
  }
}
