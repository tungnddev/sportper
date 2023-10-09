import 'package:flutter/widgets.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class ProfileMyGameWidget extends StatelessWidget {

  final SportperUserVM vm;

  const ProfileMyGameWidget({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.myGame, style: SportperStyle.boldStyle.copyWith(fontSize: 17),),
        SizedBox(height: 16,),
        _buildItem(Strings.smoke, vm.user.smoke),
        SizedBox(height: 8,),
        _buildItem(Strings.gamble, vm.user.gamble),
        SizedBox(height: 8,),
        _buildItem(Strings.drink, vm.user.drink),
        SizedBox(height: 8,),
        _buildItem(Strings.giveMe, vm.user.giveMe),
        SizedBox(height: getProportionateScreenHeight(40),)
      ],
    );
  }

  Widget _buildItem(String text, bool value) {
    return Container(
      padding: EdgeInsets.only(top: 14, bottom: 14, left: 14, right: 14),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: Text(
            text,
            style: SportperStyle.baseStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          SizedBox(width: 10,),
          Text(
            (value ? Strings.yes : Strings.no).toUpperCase(),
            style: SportperStyle.boldStyle.copyWith(
              color: value ? ColorUtils.green : ColorUtils.red
            ),
          )
        ],
      ),
    );
  }
}
