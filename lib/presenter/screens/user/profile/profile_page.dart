import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/user/profile/bloc/profile_bloc.dart';
import 'package:sportper/presenter/screens/user/profile/bloc/profile_state.dart';
import 'package:sportper/presenter/screens/user/profile/widgets/about_me_widget.dart';
import 'package:sportper/presenter/screens/user/profile/widgets/handicap_widget.dart';
import 'package:sportper/presenter/screens/user/profile/widgets/my_game_widget.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/show_alert.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'bloc/profile_event.dart';
import 'widgets/course_widget.dart';
import 'widgets/preferred_time_widget.dart';

class ProfilePage extends StatelessWidget {
  final String? userId;

  const ProfilePage({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => ProfileBloc(
              RepositoryProvider.of(context), RepositoryProvider.of(context),
              userId: userId))
    ], child: ProfileWidget());
  }
}

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(ProfileEventStartLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileStateFailed) {
              AppExceptionHandle.handle(context, state.error);
            } else if (state is ProfileStateShowLoading) {
              LoadingDialog.show(context);
            } else if (state is ProfileStateHideLoading) {
              Navigator.pop(context);
            } else if (state is ProfileStateLogOutSuccessful) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.start, (route) => false);
            }
          },
          buildWhen: (pre, next) =>
              next is ProfileStateFetch || next is ProfileStateLoading,
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SportperAppBar(
                title: Strings.myProfile,
                rightWidget: state is ProfileStateFetch && state.canEdit
                    ? GestureDetector(
                        onTap: () async {
                          final result = await Navigator.pushNamed(context, Routes.editProfile, arguments: state.vm);
                          if (result != null && result is SportperUserVM) {
                            BlocProvider.of<ProfileBloc>(context).add(ProfileEventFillNewVM(result));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Image.asset(
                            ImagePaths.icEditProfile,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      )
                    : null,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _buildMainWidget(state),
              )),
              ...state is ProfileStateFetch && state.canEdit
                  ? [
                      Padding(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(10),
                            bottom: getProportionateScreenHeight(50),
                            left: 24,
                            right: 24),
                        child: SportperButton(
                          text: Strings.logOut,
                          colorButton: ColorUtils.red,
                          onPress: () {
                            showConfirmDialog(
                                context, Strings.areYourSureWantToLogout,
                                onConfirm: () {
                              BlocProvider.of<ProfileBloc>(context)
                                  .add(ProfileEventLogOut());
                            });
                          },
                        ),
                      )
                    ]
                  : [],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainWidget(ProfileState state) {
    if (state is ProfileStateLoading) {
      return LoadingView();
    }
    if (state is ProfileStateFetch) {
      SportperUserVM vm = state.vm;
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            AvatarCircle(
                size: getProportionateScreenWidth(300), url: vm.user.avatar),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            Text(
              vm.user.fullName,
              style: SportperStyle.boldStyle.copyWith(fontSize: 20),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            Text(vm.ageText,
                style: SportperStyle.baseStyle
                    .copyWith(fontSize: 13, color: Color(0xFF7B7B7B))),
            Text('${vm.phoneNumber}',
                style: SportperStyle.baseStyle
                    .copyWith(fontSize: 13, color: Color(0xFF7B7B7B))),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            ProfileMyGameWidget(vm: vm),
            // ProfilePreferredTimeWidget(vm: vm),
            ProfileHandicapWidget(vm: vm),
            ProfileCourseWidget(vm: vm),
            ProfileAboutMe(vm: vm),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
          ],
        ),
      );
    }
    return SizedBox();
  }
}
