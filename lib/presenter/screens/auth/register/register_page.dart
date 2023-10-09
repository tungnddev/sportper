import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sportper/data/remote/exception/app_exception.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/generated/l10n.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/auth/start/widgets/login_button.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/extensions/validate.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/masked_textinput_controller.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'bloc/register_bloc.dart';
import 'bloc/register_event.dart';
import 'bloc/register_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => RegisterBloc(context,
              RepositoryProvider.of(context), RepositoryProvider.of(context)))
    ], child: RegisterWidget());
  }
}

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  late RegisterBloc bloc;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<RegisterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: bloc,
          listener: (context, state) {
            if (state is RegisterSuccessful) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.home, (route) => false);
            } else if (state is RegisterFail) {
              AppExceptionHandle.handle(
                  context, state.error);
            } else if (state is RegisterLoading) {
              LoadingDialog.show(context);
            } else if (state is RegisterFailMessage) {
              AppExceptionHandle.showMessageDialog(context, state.errorText);
            } else if (state is RegisterHideLoading) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) => Column(
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
                            Strings.letsStart,
                            style: SportperStyle.semiBoldStyle.copyWith(fontSize: 22),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            Strings.useYourDetail,
                            style: SportperStyle.baseStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            name: 'username',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: Strings.dataRequired)
                            ]),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration:
                                SportperStyle.inputDecoration(Strings.userName),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          FormBuilderTextField(
                            name: 'fullName',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: Strings.dataRequired)
                            ]),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration:
                                SportperStyle.inputDecoration(Strings.fullName),
                          ),
                          SizedBox(
                            height: 8,
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
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration:
                                SportperStyle.inputDecoration(Strings.emailAddress),
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
                            height: 8,
                          ),
                          FormBuilderTextField(
                            name: 'phoneNumber',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: Strings.dataRequired)
                            ]),
                            decoration:
                                SportperStyle.inputDecoration(Strings.phoneNumber),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [MaskTextInputFormatter(mask: '+84 (###) ###-####')],
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          FormBuilderTextField(
                            name: 'zipCode',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: Strings.dataRequired)
                            ]),
                            decoration:
                                SportperStyle.inputDecoration(Strings.zipCode),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          FormBuilderTextField(
                            name: 'aboutMe',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: Strings.dataRequired)
                            ]),
                            decoration:
                                SportperStyle.inputDecoration(Strings.aboutMe),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: Strings.byContinue,
                              style: SportperStyle.baseStyle,
                              children: [
                                TextSpan(
                                    text: Strings.termCondition,
                                    style: SportperStyle.boldStyle.copyWith(
                                        color: ColorUtils.colorTheme,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {}),
                                TextSpan(
                                    text: Strings.and,
                                    style: SportperStyle.baseStyle),
                                TextSpan(
                                    text: Strings.privacyPolicy,
                                    style: SportperStyle.boldStyle.copyWith(
                                        color: ColorUtils.colorTheme,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {}),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SportperButton(
                            text: Strings.singUp,
                            onPress: () {
                              final currentState = _formKey.currentState;
                              if (currentState == null) return;
                              if (currentState.saveAndValidate() == true) {
                                bloc.add(
                                    RegisterStartRegister(currentState.value));
                              }
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(Strings.or, style: SportperStyle.baseStyle, textAlign: TextAlign.center,),
                          SizedBox(
                            height: 12,
                          ),
                          LoginButton(
                            icon: ImagePaths.google,
                            name: Strings.continueGoogle,
                            padding: EdgeInsets.zero,
                            onPress: () {
                              // bloc.add(StartLoginGoogle());
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, Routes.loginWithEmail);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: Strings.alreadyAccount,
                                  style: SportperStyle.baseStyle,
                                  children: [
                                    TextSpan(
                                        text: Strings.singIn,
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
