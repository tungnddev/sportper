import 'package:flutter/widgets.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class ProfilePreferredTimeWidget extends StatelessWidget {
  final SportperUserVM vm;

  const ProfilePreferredTimeWidget({Key? key, required this.vm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Strings.preferredTime,
          style: SportperStyle.boldStyle.copyWith(fontSize: 17),
        ),
        SizedBox(
          height: 16,
        ),
        vm.user.preferredTime.isNotEmpty
            ? SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, position) => _buildItem(
                      context, position, vm.user.preferredTime[position]),
                  itemCount: vm.user.preferredTime.length,
                ),
              )
            : Text(
                Strings.empty,
                style: SportperStyle.baseStyle,
              ),
        SizedBox(
          height: getProportionateScreenHeight(40),
        )
      ],
    );
  }

  _buildItem(BuildContext context, int position, String item) {
    return Container(
        margin: EdgeInsets.only(left: position == 0 ? 0 : 7),
        width: (MediaQuery.of(context).size.width - 24 * 2 - 7 * 4) / 5,
        height: 48,
        decoration: BoxDecoration(
          color: Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          item,
          style: SportperStyle.baseStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ));
  }
}
