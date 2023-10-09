import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/data/remote/mapper/course_mapper.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/game/newgame/coursebloc/course_bloc.dart';
import 'package:sportper/presenter/screens/game/newgame/widgets/form_builder_course.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/masked_textinput_controller.dart';
import 'package:sportper/utils/widgets/show_alert.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:intl/intl.dart';

import 'bloc/edit_profile_bloc.dart';
import 'bloc/edit_profile_event.dart';
import 'bloc/edit_profile_state.dart';
import 'widgets/edit_profile_avatar_widget.dart';
import 'widgets/preferred_time_form_builder.dart';
import 'widgets/true_false_form_builder.dart';

class EditProfilePage extends StatelessWidget {
  final SportperUserVM vm;

  const EditProfilePage({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => EditProfileBloc(
                  RepositoryProvider.of(context),
                  RepositoryProvider.of(context),
                  RepositoryProvider.of(context),
                  vm)),
          BlocProvider(
              create: (context) => CourseBloc(RepositoryProvider.of(context)))
        ],
        child: EditProfileWidget(
          vm: vm,
        ));
  }
}

class EditProfileWidget extends StatefulWidget {
  final SportperUserVM vm;

  const EditProfileWidget({Key? key, required this.vm}) : super(key: key);

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  late EditProfileBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EditProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<EditProfileBloc, EditProfileState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is EditProfileStateFailed) {
              AppExceptionHandle.handle(context, state.error);
            } else if (state is EditProfileStateShowLoading) {
              LoadingDialog.show(context);
            } else if (state is EditProfileStateHideLoading) {
              Navigator.pop(context);
            } else if (state is EditProfileStateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(Strings.saveProfileSuccessfully),
                duration: Duration(seconds: 2),
              ));
              Navigator.pop(context, state.vm);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SportperAppBar(
                title: Strings.editProfile,
                rightWidget: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    final currentState = _formKey.currentState;
                    if (currentState == null) return;
                    if (currentState.saveAndValidate() == true) {
                      bloc.add(EditProfileEventSave(currentState.value));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Image.asset(
                      ImagePaths.icTickProfile,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _buildMainWidget(),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainWidget() {
    return FormBuilder(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            EditProfileAvatarWidget(
              oldAvatar: widget.vm.user.avatar,
              onChangeAvatar: (String newLocalPath) {
                bloc.lastAvatarLocalPath = newLocalPath;
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(40),
            ),
            FormBuilderTextField(
              name: 'fullName',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: Strings.dataRequired)
              ]),
              decoration: SportperStyle.inputDecoration(Strings.fullName),
              initialValue: widget.vm.user.fullName,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            FormBuilderDateTimePicker(
              name: 'birthday',
              initialValue: widget.vm.user.birthday,
              decoration:
              SportperStyle.inputDecoration(Strings.birthday),
              validator: FormBuilderValidators.required(context, errorText: Strings.dataRequired),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputType: InputType.date,
              locale: Locale("en"),
              lastDate: DateTime.now(),
              valueTransformer: (date) => date != null ? DateFormat("yyyy-MM-dd").format(date) : null,
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            FormBuilderTextField(
              name: 'phoneNumber',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: Strings.dataRequired)
              ]),
              decoration: SportperStyle.inputDecoration(Strings.phoneNumber),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                MaskTextInputFormatter(mask: '+84 (###) ###-####')
              ],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: widget.vm.phoneNumber,
            ),
            // FormBuilderTextField(
            //   name: 'age',
            //   validator: FormBuilderValidators.compose([
            //     FormBuilderValidators.required(context,
            //         errorText: Strings.dataRequired),
            //     (value) => int.tryParse(value ?? '') == null
            //         ? Strings.dataInvalid
            //         : null
            //   ]),
            //   decoration: SportperStyle.inputDecoration(Strings.age),
            //   initialValue: widget.vm.user.age.toString(),
            //   keyboardType: TextInputType.number,
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   valueTransformer: (value) => int.tryParse(value ?? '30') ?? 30,
            // ),
            SizedBox(
              height: getProportionateScreenHeight(40),
            ),
            Text(
              Strings.myGame,
              style: SportperStyle.boldStyle.copyWith(fontSize: 17),
            ),
            SizedBox(
              height: 12,
            ),
            TrueFalseFormBuilder(
              name: 'smoke',
              initValue: widget.vm.user.smoke,
              title: Strings.smoke,
            ),
            SizedBox(
              height: 8,
            ),
            TrueFalseFormBuilder(
                name: 'gamble',
                initValue: widget.vm.user.gamble,
                title: Strings.gamble),
            SizedBox(
              height: 8,
            ),
            TrueFalseFormBuilder(
                name: 'drink',
                initValue: widget.vm.user.drink,
                title: Strings.drink),
            SizedBox(
              height: 8,
            ),
            TrueFalseFormBuilder(
              name: 'giveMe',
              initValue: widget.vm.user.giveMe,
              title: Strings.giveMe,
            ),
            SizedBox(
              height: getProportionateScreenHeight(40),
            ),
            // Text(
            //   Strings.preferredTime,
            //   style: SportperStyle.boldStyle.copyWith(fontSize: 17),
            // ),
            // SizedBox(
            //   height: 12,
            // ),
            // PreferredTimeFormBuilder(
            //   name: 'preferredTime',
            //   data: ['-3:00', '3:00', '3:30', '4:00', '4:00+'],
            //   initValue: widget.vm.user.preferredTime.isEmpty ? null : widget.vm.user.preferredTime[0],
            //   valueTransformer: (value) => [value],
            // ),
            // SizedBox(
            //   height: getProportionateScreenHeight(40),
            // ),
            Text(
              Strings.handicap,
              style: SportperStyle.boldStyle.copyWith(fontSize: 17),
            ),
            SizedBox(
              height: 12,
            ),
            FormBuilderSlider(
              initialValue: widget.vm.user.handicap.toDouble(),
              min: 0,
              max: 21,
              divisions: 21,
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Color(0xFFE7F6E9),
              name: 'handicap',
              decoration: SportperStyle.inputDecoration("")
                  .copyWith(hintText: Strings.selectSportperCourse),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: Strings.dataRequired)
              ]),
              valueTransformer: (value) => value?.round(),
            ),
            SizedBox(
              height: getProportionateScreenHeight(40),
            ),
            Text(
              Strings.homeCourse,
              style: SportperStyle.boldStyle.copyWith(fontSize: 17),
            ),
            SizedBox(
              height: 12,
            ),
            FormBuilderCourse(
              name: 'course',
              decoration: SportperStyle.inputDecoration("")
                  .copyWith(
                  hintText: Strings.selectSportperCourse),
              initialValue: widget.vm.course,
              valueTransformer: (value) => value?.course == null ? null : CourseMapper().remapCourse(value!.course, isIncludeId: true).toJson(),
            ),
            SizedBox(
              height: getProportionateScreenHeight(40),
            ),
            Text(
              Strings.aboutMe,
              style: SportperStyle.boldStyle.copyWith(fontSize: 17),
            ),
            SizedBox(
              height: 12,
            ),
            FormBuilderTextField(
              name: 'aboutMe',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context,
                    errorText: Strings.dataRequired)
              ]),
              decoration: SportperStyle.inputDecoration(''),
              initialValue: widget.vm.user.aboutMe,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLines: 3,
            ),
            SizedBox(
              height: getProportionateScreenHeight(60),
            ),
          ],
        ),
      ),
    );
  }
}
