import 'package:flutter/material.dart';
import 'package:sportper/presenter/models/notification_vm.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class NotificationChatItem extends StatelessWidget {
  final NotificationVM vm;
  final Function(String id) onTap;

  const NotificationChatItem({Key? key, required this.vm, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call(vm.entity.gameId ?? '');
      },
      child: Padding(
        padding: EdgeInsets.only(left: 24, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AvatarCircle(size: 64, url: vm.entity.image),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  vm.entity.title,
                  style: SportperStyle.boldStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2,),
                Text(
                  vm.entity.subTitle,
                  style: SportperStyle.baseStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  vm.date,
                  style: SportperStyle.baseStyle
                      .copyWith(color: Color(0xFF7B7B7B), fontSize: 13),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
