import 'package:flutter/widgets.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class ProfileHandicapWidget extends StatelessWidget {
  final SportperUserVM vm;

  const ProfileHandicapWidget({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.handicap,
            style: SportperStyle.boldStyle.copyWith(fontSize: 17),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
              width: (MediaQuery.of(context).size.width - 24 * 2 - 7 * 4) / 5,
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                vm.user.handicap.toString(),
                style: SportperStyle.baseStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          SizedBox(
            height: getProportionateScreenHeight(40),
          )
        ],
      ),
    );
  }
}
