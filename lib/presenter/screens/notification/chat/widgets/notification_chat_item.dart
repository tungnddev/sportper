import 'package:flutter/material.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/notification_chat_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class NotificationChatItems extends StatelessWidget {
  final NotificationChatVM vm;
  final Function(String id) onTap;

  const NotificationChatItems({Key? key, required this.vm, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call(vm.data.gameId);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 24, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AvatarCircle(size: 64, url: vm.data.image),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  vm.data.title,
                  style: SportperStyle.boldStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2,),
                Text(
                  vm.data.lastMessage,
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
