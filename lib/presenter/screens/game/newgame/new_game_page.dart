import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/models/type_option_vm.dart';
import 'package:sportper/presenter/models/home_tab_enum.dart';
import 'package:sportper/presenter/models/player_dropdown_vm.dart';
import 'package:sportper/presenter/screens/auth/start/widgets/login_button.dart';
import 'package:sportper/presenter/screens/game/newgame/bloc/new_game_bloc.dart';
import 'package:sportper/presenter/screens/game/newgame/coursebloc/course_bloc.dart';
import 'package:sportper/presenter/screens/game/newgame/widgets/form_builder_course.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/presenter/screens/user/editprofile/widgets/true_false_form_builder.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/form/sportper_form_builder_dropdown.dart';
import 'package:sportper/utils/widgets/form/form_builder_options.dart';
import 'package:sportper/utils/widgets/form/sportper_form_builder_switch.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:intl/intl.dart';

import 'bloc/new_game_event.dart';
import 'bloc/new_game_state.dart';

class NewGamePage extends StatelessWidget {
  const NewGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => NewGameBloc(
              context,
              RepositoryProvider.of(context),
              RepositoryProvider.of(context),
              RepositoryProvider.of(context),
              RepositoryProvider.of(context),
              RepositoryProvider.of(context))),
      BlocProvider(
          create: (context) => CourseBloc(RepositoryProvider.of(context)))
    ], child: NewGameWidget());
  }
}

class NewGameWidget extends StatefulWidget {
  const NewGameWidget({Key? key}) : super(key: key);

  @override
  _NewGameWidgetState createState() => _NewGameWidgetState();
}

class _NewGameWidgetState extends State<NewGameWidget> {
  late NewGameBloc bloc;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<NewGameBloc, NewGameState>(
          listener: (preState, state) {
            if (state is NewGameSuccessful) {
              RxBusService().add(
                RxBusName.HOME_SCREEN_CHANGE_TAB,
                value: HomeTab.myGames,
              );
              Navigator.pop(context);
            } else if (state is NewGameFail) {
              AppExceptionHandle.handle(context, state.error);
            } else if (state is NewGameLoading) {
              LoadingDialog.show(context);
            } else if (state is NewGameFailMessage) {
              AppExceptionHandle.showMessageDialog(context, state.errorText);
            } else if (state is NewGameHideLoading) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SportperAppBar(
                  title: Strings.newGame,
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: FormBuilder(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            Strings.gameName,
                            style: SportperStyle.boldStyle,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          FormBuilderTextField(
                            name: 'gameName',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: Strings.dataRequired)
                            ]),
                            decoration: SportperStyle.inputDecoration(""),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),
                          Text(
                            Strings.gameOptions,
                            style: SportperStyle.boldStyle,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          FormBuilderOptions<TypeOptionVM>(
                            name: 'type',
                            data: [
                              TypeOptionVM(TypeConst.FOOT_BALL, Strings.football),
                              TypeOptionVM(TypeConst.BADMINTON, Strings.badminton),
                              TypeOptionVM(TypeConst.TENNIS, Strings.tennis),
                              TypeOptionVM(TypeConst.GOLF, Strings.golf),
                              TypeOptionVM(TypeConst.VOLLEYBALL, Strings.volleyball),
                              TypeOptionVM(TypeConst.BASKETBALL, Strings.basketball),
                            ],
                            initPosition: 0,
                            textDisplayTransformer: (value) => value.text,
                            valueTransformer: (value) => value?.key ?? '',
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),
                          Text(
                            Strings.numberOfPlayers,
                            style: SportperStyle.boldStyle,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child:
                                      SportperFormBuilderDropdown<PlayerDropDownVM>(
                                name: 'numPlayers',
                                data: List<int>.generate(30, (i) => i + 1)
                                    .map((e) => PlayerDropDownVM(
                                        e, '$e ${Strings.players}'))
                                    .toList(),
                                decoration: SportperStyle.inputDecoration("")
                                    .copyWith(hintText: Strings.selectPlayers),
                                titleDialog: Strings.selectPlayers,
                                textDisplayTransformer: (value) =>
                                    value.display,
                                valueTransformer: (value) => value?.number ?? 0,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(context,
                                      errorText: Strings.dataRequired)
                                ]),
                              )),
                              // SizedBox(
                              //   width: 7,
                              // ),
                              // Expanded(
                              //     child: SportperFormBuilderDropdown<PlayerDropDownVM>(
                              //   name: 'numGuests',
                              //   data: List<int>.generate(30, (i) => i + 1)
                              //       .map((e) =>
                              //           PlayerDropDownVM(e, '$e ${Strings.guests}'))
                              //       .toList(),
                              //   decoration: SportperStyle.inputDecoration("")
                              //       .copyWith(hintText: Strings.selectGuests),
                              //   titleDialog: Strings.selectGuests,
                              //   textDisplayTransformer: (value) => value.display,
                              //   valueTransformer: (value) => value?.number ?? 0,
                              //       autovalidateMode: AutovalidateMode.onUserInteraction,
                              //       validator: FormBuilderValidators.compose([
                              //         FormBuilderValidators.required(context,
                              //             errorText: Strings.dataRequired)
                              //       ]),
                              // )),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    Strings.date,
                                    style: SportperStyle.boldStyle,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(20),
                                  ),
                                  FormBuilderDateTimePicker(
                                    name: 'date',
                                    initialValue: DateTime.now(),
                                    decoration:
                                        SportperStyle.inputDecoration("").copyWith(
                                      prefixIconConstraints: BoxConstraints(
                                        minHeight: 20,
                                        minWidth: 20,
                                      ),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 4),
                                        child: Image.asset(
                                          ImagePaths.icCalendar,
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                    inputType: InputType.date,
                                    locale: Locale("en"),
                                  )
                                ],
                              )),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    Strings.time,
                                    style: SportperStyle.boldStyle,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(20),
                                  ),
                                  FormBuilderDateTimePicker(
                                    name: 'time',
                                    initialValue: DateTime.now(),
                                    decoration: SportperStyle.inputDecoration("")
                                        .copyWith(
                                            prefixIconConstraints:
                                                BoxConstraints(
                                              minHeight: 20,
                                              minWidth: 20,
                                            ),
                                            prefixIcon: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 4),
                                              child: Image.asset(
                                                ImagePaths.icTime,
                                                width: 20,
                                                height: 20,
                                              ),
                                            )),
                                    inputType: InputType.time,
                                    locale: Locale("en"),
                                  ),
                                ],
                              )),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),
                          Text(
                            Strings.selectSportperCourse,
                            style: SportperStyle.boldStyle,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          FormBuilderCourse(
                            name: 'course',
                            decoration: SportperStyle.inputDecoration("")
                                .copyWith(hintText: Strings.selectSportperCourse),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: Strings.dataRequired)
                            ]),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),
                          Text(
                            Strings.selectMinHandicap,
                            style: SportperStyle.boldStyle,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          FormBuilderSlider(
                            initialValue: 3,
                            min: 3,
                            max: 10,
                            divisions: 7,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: Color(0xFFE7F6E9),
                            name: 'minHandicap',
                            decoration: SportperStyle.inputDecoration("")
                                .copyWith(hintText: Strings.selectSportperCourse),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            Strings.selectMaxHandicap,
                            style: SportperStyle.boldStyle,
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          FormBuilderSlider(
                            initialValue: 7,
                            min: 7,
                            max: 21,
                            divisions: 14,
                            activeColor: Theme.of(context).primaryColor,
                            inactiveColor: Color(0xFFE7F6E9),
                            name: 'maxHandicap',
                            decoration: SportperStyle.inputDecoration("")
                                .copyWith(hintText: Strings.selectSportperCourse),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context,
                                  errorText: Strings.dataRequired)
                            ]),
                            valueTransformer: (value) => value?.round(),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: SportperFormBuilderSwitch(
                                name: 'booked',
                                title: Strings.venueBooked,
                              )),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: SportperFormBuilderSwitch(
                                name: 'tournament',
                                title: Strings.tournament,
                              ))
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(25),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: SportperFormBuilderSwitch(
                                name: 'smoke',
                                title: Strings.smoke,
                              )),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: SportperFormBuilderSwitch(
                                name: 'gamble',
                                title: Strings.gamble,
                              ))
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(25),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: SportperFormBuilderSwitch(
                                name: 'drink',
                                title: Strings.drink,
                              )),
                              SizedBox(
                                width: 8,
                              ),
                              Spacer()
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(25),
                          ),
                          FormBuilderCheckbox(
                              name: 'invite',
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero),
                              activeColor: Theme.of(context).primaryColor,
                              title: Text(
                                Strings.sendInviteToFriends,
                                style: SportperStyle.mediumStyle,
                              )),
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 20, right: 24, left: 24),
                  child: SportperButton(
                    text: Strings.createGame,
                    onPress: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final currentState = _formKey.currentState;
                      if (currentState == null) return;
                      if (currentState.saveAndValidate() == true) {
                        bloc.add(NewGameStartNewGame(currentState.value));
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
