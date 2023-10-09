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

import 'bloc/forgot_password_bloc.dart';
import 'bloc/forgot_password_event.dart';
import 'bloc/forgot_password_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => ForgotPasswordBloc(context,
              RepositoryProvider.of(context), RepositoryProvider.of(context)))
    ], child: ForgotPasswordWidget());
  }
}

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({Key? key}) : super(key: key);

  @override
  _ForgotPasswordWidgetState createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  late ForgotPasswordBloc bloc;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ForgotPasswordBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: bloc,
          listener: (context, state) {
            if (state is ForgotPasswordFail) {
              AppExceptionHandle.handle(context, state.error);
            } else if (state is ForgotPasswordLoading) {
              LoadingDialog.show(context);
            } else if (state is ForgotPasswordFailMessage) {
              AppExceptionHandle.showMessageDialog(context, state.errorText);
            } else if (state is ForgotPasswordSuccessful) {
              AppExceptionHandle.showMessageDialog(
                  context, Strings.followToResetPassword,
                  onDone: () => Navigator.pop(context));
            } else if (state is ForgotPasswordHideLoading) {
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
                            Strings.forgotPasswordTitle,
                            style: SportperStyle.boldStyle.copyWith(fontSize: 22),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            Strings.enterEmailForResetPassword,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SportperButton(
                  text: Strings.submit,
                  onPress: () {
                    final currentState = _formKey.currentState;
                    if (currentState == null) return;
                    if (currentState.saveAndValidate() == true) {
                      bloc.add(ForgotPasswordStartForgotPassword(
                        currentState.value['email'],
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
