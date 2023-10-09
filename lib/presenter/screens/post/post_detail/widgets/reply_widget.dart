import 'package:flutter/material.dart';
import 'package:sportper/presenter/models/comment_vm.dart';
import 'package:sportper/presenter/models/reply_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/post/feed/widgets/post_infor_line_with_like.dart';
import 'package:sportper/presenter/screens/post/feed/widgets/readmore_text.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class ReplyWidget extends StatelessWidget {
  final ReplyVM vm;
  final Function()? onTapLike;
  final Function()? onTapReply;
  const ReplyWidget({Key? key, required this.vm, this.onTapLike, this.onTapReply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5,),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostInfoLineWithLike(user: vm.entity.user, time: vm.time, isLiked: vm.isLiked, likeCount: vm.likeCount, onTapLike: onTapLike,),
              SizedBox(
                height: 10,
              ),
              ReadMoreText(
                content: vm.entity.content,
              ),
              SizedBox(
                height: 5,
              ),
              ...vm.entity.image.isNotEmpty
                  ? [
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, Routes.photoView, arguments: vm.entity.image),
                  child: CacheImage(
                    url: vm.entity.image,
                    width: 100,
                    height: 100,
                    radiusAll: 8,
                  ),
                )
              ]
                  : [],
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        SizedBox(height: 3,),
        Row(
          children: [
            GestureDetector(
              onTap: onTapReply,
              child: Text(
                Strings.reply,
                style: SportperStyle.boldStyle.copyWith(fontSize: 13, color: ColorUtils.disableText),
              ),
            )
          ],
        ),
        SizedBox(height: 7,),
      ],
    );
  }
}
