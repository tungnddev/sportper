import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sportper/data/remote/exception/app_exception.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/generated/l10n.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/extensions/validate.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => LoginBloc(context,
              RepositoryProvider.of(context), RepositoryProvider.of(context)))
    ], child: LoginWidget());
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginBloc bloc;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: bloc,
          listener: (context, state) {
            if (state is LoginSuccessful) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.home, (route) => false);
            } else if (state is LoginFail) {
              AppExceptionHandle.handle(
                  context, state.error);
            } else if (state is LoginLoading) {
              LoadingDialog.show(context);
            } else if (state is LoginFailMessage) {
              AppExceptionHandle.showMessageDialog(context, state.errorText);
            } else if (state is LoginHideLoading) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SportperAppBar(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            Strings.signInTitle,
                            style: SportperStyle.boldStyle.copyWith(fontSize: 22),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            Strings.enterYourEmail,
                            style: SportperStyle.baseStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            name: 'email',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: Strings.dataRequired),
                              (value) => value?.validateEmail
                                  ? null
                                  : Strings.enterAValidEmail
                            ]),
                            decoration:
                            SportperStyle.inputDecoration(Strings.emailAddress),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          FormBuilderTextField(
                            name: 'password',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: Strings.dataRequired),
                              (value) => (value?.length ?? 0) >= 6
                                  ? null
                                  : Strings.enterPassword6
                            ]),
                            decoration:
                                SportperStyle.inputDecoration(Strings.password),
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(800),
                          ),
                          SportperButton(
                            text: Strings.singIn,
                            onPress: () {
                              final currentState = _formKey.currentState;
                              if (currentState == null) return;
                              if (currentState.saveAndValidate() == true) {
                                bloc.add(LoginStartLogin(
                                    currentState.value['email'],
                                    currentState.value['password']));
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, Routes.forgotPassword),
                            child: Text(
                              Strings.forgotPassword,
                              style: SportperStyle.semiBoldStyle.copyWith(color: ColorUtils.colorTheme),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.register);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  text: Strings.notHaveAccount,
                                  style: SportperStyle.baseStyle,
                                  children: [
                                    TextSpan(
                                        text: Strings.singUp,
                                        style: SportperStyle.boldStyle.copyWith(
                                            color: ColorUtils.colorTheme,
                                            decoration:
                                                TextDecoration.underline)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
