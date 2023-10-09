import 'package:flutter/widgets.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class ProfileAboutMe extends StatelessWidget {

  final SportperUserVM vm;

  const ProfileAboutMe({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.aboutMe, style: SportperStyle.boldStyle.copyWith(fontSize: 17),),
        SizedBox(height: 16,),
        Container(
          height: getProportionateScreenHeight(250),
          padding: EdgeInsets.only(top: 14, bottom: 14, left: 14, right: 8),
          decoration: BoxDecoration(
            color: Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              vm.user.aboutMe,
              style: SportperStyle.baseStyle,
            ),
          ),
        )
      ],
    );
  }
}
