import 'package:flutter/material.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class NotificationFriendItems extends StatelessWidget {
  final NotificationFriendVM vm;
  final Function()? onAccept;
  final Function()? onDecline;

  const NotificationFriendItems(
      {Key? key, required this.vm, this.onAccept, this.onDecline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AvatarCircle(size: 64, url: vm.avatar),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                vm.name,
                style: SportperStyle.boldStyle,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                vm.address,
                style: SportperStyle.baseStyle
                    .copyWith(color: Color(0xFF7B7B7B), fontSize: 13),
              ),
            ],
          )),
          GestureDetector(
              onTap: onAccept,
              child: Image.asset(
                ImagePaths.icAccept,
                width: 40,
                height: 40,
              )),
          SizedBox(
            width: 8,
          ),
          GestureDetector(
              onTap: onDecline,
              child: Image.asset(
                ImagePaths.icDecline,
                width: 40,
                height: 40,
              ))
        ],
      ),
    );
  }
}
