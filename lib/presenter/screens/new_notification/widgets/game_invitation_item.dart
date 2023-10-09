import 'package:flutter/material.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/presenter/models/notification_vm.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class GameInvitationItem extends StatelessWidget {
  final NotificationVM vm;
  final Function(String gameId, String? invitationId) onTap;

  const GameInvitationItem(
      {Key? key, required this.vm, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call(vm.entity.gameId ?? '', vm.entity.gameInvitationId ?? '');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      _getRealSubTitle(),
                      style: SportperStyle.baseStyle
                          .copyWith(color: Color(0xFF7B7B7B), fontSize: 14),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _getRealSubTitle() {
    return vm.entity.gameStartTime!.isAfter(DateTime.now())
        ? vm.entity.subTitle
        : Strings.thisGameAlreadyStarted;
  }
}
