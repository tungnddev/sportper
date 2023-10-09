import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'bloc/start_bloc.dart';
import 'bloc/start_event.dart';
import 'bloc/start_state.dart';
import 'widgets/login_button.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => StartBloc(
              RepositoryProvider.of(context), RepositoryProvider.of(context)))
    ], child: StartWidget());
  }
}

class StartWidget extends StatefulWidget {
  const StartWidget({Key? key}) : super(key: key);

  @override
  _StartWidgetState createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget> {
  late StartBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StartBloc, StartState>(
        listener: (context, state) {
          if (state is StartLoading) {
            LoadingDialog.show(context);
          } else if (state is StartHideLoading) {
            Navigator.pop(context);
          } else if (state is StartLoginFail) {
            AppExceptionHandle.handle(context, state.e);
          } else if (state is StartOpenHome) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Routes.home, (route) => false);
          }
        },
        bloc: bloc,
        builder: (context, state) => Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImagePaths.bg), fit: BoxFit.fill)),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _topWidget(),
                SizedBox(
                  height: getProportionateScreenHeight(400),
                ),
                _bottomWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _topWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ImagePaths.logo,
            width: 130,
            height: 130,
          ),
          SizedBox(
            height: 24,
          ),
          Text(Strings.welcome,
              style: SportperStyle.semiBoldStyle.copyWith(fontSize: 21)),
          SizedBox(
            height: 12,
          ),
          Text(
            Strings.findAGame,
            style: SportperStyle.baseStyle,
          )
        ],
      );

  _bottomWidget() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoginButton(
            icon: ImagePaths.google,
            name: Strings.continueGoogle,
            onPress: () {
              bloc.add(StartLoginGoogle());
            },
          ),
          if (Platform.isIOS) LoginButton(
            icon: ImagePaths.ios,
            name: Strings.continueApple,
            onPress: () => bloc.add(StartLoginApple()),
          ),
          LoginButton(
            icon: ImagePaths.email,
            name: Strings.continueEmail,
            onPress: () => Navigator.pushNamed(context, Routes.register),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.loginWithEmail);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: RichText(
                text: TextSpan(
                  text: Strings.alreadyAccount,
                  style: SportperStyle.baseStyle,
                  children: [
                    TextSpan(
                        text: Strings.singIn,
                        style: SportperStyle.boldStyle.copyWith(
                            color: ColorUtils.colorTheme,
                            decoration: TextDecoration.underline)),
                  ],
                ),
              ),
            ),
          )
        ],
      );
}
