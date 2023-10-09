import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportper/domain/entities/buddies.dart';
import 'package:sportper/presenter/models/friend_vm.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class BuddiesItem extends StatelessWidget {

  final FriendVM vm;
  final Function(String id)? onTap;
  final Function(String id)? onDelete;

  const BuddiesItem({Key? key, required this.vm, this.onTap, this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GestureDetector(
        onTap: () {
          if (vm.friend.status != FriendStatus.not_exist) {
            onTap?.call(vm.friend.id);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AvatarCircle(size: 64, url: vm.friend.avatar),
            SizedBox(width: 8,),
            Expanded(child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [
                Text(
                  vm.friend.fullName,
                  style: SportperStyle.boldStyle,
                ),
                SizedBox(height: 2,),
                Text(
                  vm.friend.phoneNumber,
                  style: SportperStyle.baseStyle.copyWith(
                      color: Color(0xFF7B7B7B), fontSize: 13),
                ),
                SizedBox(height: 6,),
                Text(
                  vm.statusText,
                  style: SportperStyle.baseStyle.copyWith(
                      color: vm.colorStatus, fontSize: 12),
                )
              ],
            )),
            SizedBox(width: 6,),
            CupertinoButton(
              onPressed: () => onDelete?.call(vm.friend.id),
              child: Text(
                Strings.delete,
                style: SportperStyle.semiBoldStyle
                    .copyWith(color: Colors.white, fontSize: 13),
              ),
              color: ColorUtils.red,
              padding: EdgeInsets.only(top: 0, bottom: 0, left: 13, right: 13),
              minSize: 32,
              borderRadius: BorderRadius.circular(8),
            )
          ],
        ),
      ),
    );
  }
}
