import 'package:flutter/material.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class FriendWithGameItem extends StatelessWidget {

  final FriendGamesWithVM vm;
  final Function()? onTap;

  const FriendWithGameItem({Key? key, required this.vm, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AvatarCircle(size: 64, url: vm.friendWithGame.user.avatar),
            SizedBox(width: 8,),
            Expanded(child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                Text(
                  vm.fullName,
                  style: SportperStyle.boldStyle,
                ),
                SizedBox(height: 2,),
                Text(
                  vm.phoneNumber,
                  style: SportperStyle.baseStyle.copyWith(
                      color: Color(0xFF7B7B7B), fontSize: 13),
                ),
                SizedBox(height: 6,),
                Text(
                  vm.lastRoundText,
                  style: SportperStyle.baseStyle.copyWith(
                      color: Color(0xFF7B7B7B), fontSize: 12),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
