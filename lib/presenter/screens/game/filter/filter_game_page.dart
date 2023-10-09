import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportper/domain/entities/sort_game.dart';
import 'package:sportper/presenter/models/filter_vm.dart';
import 'package:sportper/presenter/models/type_option_vm.dart';
import 'package:sportper/presenter/models/player_dropdown_vm.dart';
import 'package:sportper/presenter/screens/game/filter/widget/sort_by_widget.dart';
import 'package:sportper/presenter/screens/game/newgame/coursebloc/course_bloc.dart';
import 'package:sportper/presenter/screens/game/newgame/widgets/form_builder_course.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/form/form_builder_options.dart';
import 'package:sportper/utils/widgets/form/sportper_form_builder_dropdown.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'widget/filter_choose_date_form_builder.dart';

class FilterGamePage extends StatelessWidget {
  final FilterGameVM currentFilter;

  const FilterGamePage(
      {Key? key, required this.currentFilter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => CourseBloc(RepositoryProvider.of(context)))
        ],
        child: FilterGameWidget(
          currentFilter: currentFilter,
        ));
  }
}

class FilterGameWidget extends StatefulWidget {
  final FilterGameVM currentFilter;

  const FilterGameWidget(
      {Key? key, required this.currentFilter})
      : super(key: key);

  @override
  _FilterGameWidgetState createState() => _FilterGameWidgetState();
}

class _FilterGameWidgetState extends State<FilterGameWidget> {
  final _formKey = GlobalKey<FormBuilderState>();
  var _currentFilter = FilterGameVM(currentSort: SortGame.daysAway);

  ValueNotifier<int> valueNotifier = ValueNotifier(1);

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.currentFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SportperAppBar(
              title: Strings.filterGames,
              rightWidget: GestureDetector(
                onTap: () async {
                  _currentFilter = FilterGameVM(currentSort: SortGame.daysAway);
                  valueNotifier.value = 0;
                  Future.delayed(Duration(milliseconds: 500), () {
                    valueNotifier.value = 1;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Image.asset(
                    ImagePaths.icClear,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<int>(
                  valueListenable: valueNotifier,
                  builder: (context, value, child) {
                    if (value == 0) return LoadingView();
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: FormBuilder(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    Strings.sortBy,
                                    style: SportperStyle.boldStyle,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(20),
                                  ),
                                  GameSortFormBuilder(
                                    name: 'sort',
                                    initialValue: _currentFilter.currentSort,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(40),
                                  ),
                                  Text(
                                    Strings.gameDate,
                                    style: SportperStyle.boldStyle,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(20),
                                  ),
                                  FilterChooseDateFormBuilder(
                                    name: 'filterDate',
                                    initialValue: _currentFilter.filterDate,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(40),
                                  ),
                                  Text(
                                    Strings.gameType,
                                    style: SportperStyle.boldStyle,
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(20),
                                  ),
                                  FormBuilderOptions<TypeOptionVM>(
                                    name: 'gameType',
                                    data: [
                                      TypeOptionVM(TypeConst.FOOT_BALL, Strings.football),
                                      TypeOptionVM(TypeConst.BADMINTON, Strings.badminton),
                                      TypeOptionVM(TypeConst.TENNIS, Strings.tennis),
                                      TypeOptionVM(TypeConst.GOLF, Strings.golf),
                                      TypeOptionVM(TypeConst.VOLLEYBALL, Strings.volleyball),
                                      TypeOptionVM(TypeConst.BASKETBALL, Strings.basketball),
                                    ],
                                    textDisplayTransformer: (value) =>
                                        value.text,
                                    valueTransformer: (value) => value?.key,
                                    initPosition:
                                        _currentFilter.positionGameType,
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
                                          child: SportperFormBuilderDropdown<
                                              PlayerDropDownVM>(
                                        name: 'numPlayers',
                                        data:
                                            List<int>.generate(30, (i) => i + 1)
                                                .map((e) => PlayerDropDownVM(
                                                    e, '$e ${Strings.players}'))
                                                .toList(),
                                        decoration:
                                            SportperStyle.inputDecoration("")
                                                .copyWith(
                                                    hintText:
                                                        Strings.selectPlayers),
                                        titleDialog: Strings.selectPlayers,
                                        textDisplayTransformer: (value) =>
                                            value.display,
                                        initialValue: _currentFilter.numPlayers,
                                      )),
                                      // SizedBox(
                                      //   width: 7,
                                      // ),
                                      // Expanded(
                                      //     child: SportperFormBuilderDropdown<
                                      //         PlayerDropDownVM>(
                                      //   name: 'numGuests',
                                      //   data:
                                      //       List<int>.generate(30, (i) => i + 1)
                                      //           .map((e) => PlayerDropDownVM(
                                      //               e, '$e ${Strings.guests}'))
                                      //           .toList(),
                                      //   decoration:
                                      //       SportperStyle.inputDecoration("")
                                      //           .copyWith(
                                      //               hintText:
                                      //                   Strings.selectGuests),
                                      //   titleDialog: Strings.selectGuests,
                                      //   textDisplayTransformer: (value) =>
                                      //       value.display,
                                      //   initialValue: _currentFilter.numGuests,
                                      // )),
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
                                    name: 'selectedCourse',
                                    decoration: SportperStyle.inputDecoration("")
                                        .copyWith(
                                            hintText: Strings.selectSportperCourse),
                                    initialValue: _currentFilter.selectedCourse,
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                ],
                              ),
                            ),
                          )),
                          SizedBox(
                            height: 5,
                          ),
                          SportperButton(
                            text: Strings.filter,
                            onPress: () {
                              final currentState = _formKey.currentState;
                              if (currentState == null) return;
                              if (currentState.saveAndValidate() == true) {
                                final filter =
                                    FilterGameVM.fromMap(currentState.value);
                                Navigator.pop(context, filter);
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Color(0xFFF0F0F0), width: 1)),
                              alignment: Alignment.center,
                              child: Text(Strings.cancel,
                                  style: SportperStyle.semiBoldStyle
                                      .copyWith(fontSize: 15)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
