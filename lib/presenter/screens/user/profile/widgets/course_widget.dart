import 'package:flutter/widgets.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ProfileCourseWidget extends StatelessWidget {
  final SportperUserVM vm;

  const ProfileCourseWidget({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.homeCourse,
            style: SportperStyle.boldStyle.copyWith(fontSize: 17),
          ),
          SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {
              if (vm.user.course?.address != null) {
                MapsLauncher.launchQuery(vm.user.course!.address);
              }
            },
            child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      ImagePaths.icLocation,
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      vm.user.course?.clubName ?? Strings.notSet,
                      style: SportperStyle.baseStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: getProportionateScreenHeight(40),
          )
        ],
      ),
    );
  }
}
