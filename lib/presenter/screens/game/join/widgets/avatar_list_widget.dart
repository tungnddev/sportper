import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class AvatarListWidget extends StatelessWidget {

  final List<String> avatarList;

  final maxAvatarShow = 4;
  final double avatarSize = 24;

  const AvatarListWidget({Key? key, required this.avatarList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: avatarSize,
      child: avatarList.isNotEmpty ? Stack(
        children: _buildListAvatars(),
      ) : SizedBox(),
    );
  }

  List<Widget> _buildListAvatars() {
    List<Widget> list = [];
    final imageShow = avatarList.length > maxAvatarShow ? maxAvatarShow : avatarList.length;
    for (var i = 0; i < imageShow; i ++ ) {
      list.add(Positioned(
        left: i * (avatarSize / 2),
        child: AvatarCircle(size: avatarSize, url: avatarList[i], colorBorder: Colors.white,),
      ));
    }
    if (avatarList.length > maxAvatarShow) {
      list.add(_itemMoreUser());
    }
    return list;
  }

  _itemMoreUser() => Positioned(
    left: maxAvatarShow * (avatarSize / 2),
    child: Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePaths.defaultAvatar)
        )
      ),
      child: Text(
        '+${avatarList.length - maxAvatarShow}',
            style: SportperStyle.baseStyle.copyWith(fontSize: 13),
      ),
    ),
  );
}
