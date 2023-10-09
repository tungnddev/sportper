import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/domain/entities/course.dart';
import 'package:sportper/presenter/models/course_vm.dart';
import 'package:sportper/presenter/screens/game/newgame/coursebloc/course_bloc.dart';
import 'package:sportper/presenter/screens/game/newgame/coursebloc/course_event.dart';
import 'package:sportper/presenter/screens/game/newgame/coursebloc/course_state.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/gesture_detector.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/search.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class FormBuilderCourse extends FormBuilderField<CourseVM> {
  final TextEditingController? controller;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool enableInteractiveSelection;
  final String titleDialog;
  final double? heightDialog;

  FormBuilderCourse(
      {Key? key,
      //From Super
      required String name,
      FormFieldValidator<CourseVM>? validator,
      CourseVM? initialValue,
      InputDecoration decoration = const InputDecoration(),
      ValueChanged<CourseVM?>? onChanged,
      ValueTransformer<CourseVM?>? valueTransformer,
      bool enabled = true,
      FormFieldSetter<CourseVM>? onSaved,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      VoidCallback? onReset,
      FocusNode? focusNode,
      this.enableInteractiveSelection = true,
      this.textAlign = TextAlign.start,
      this.controller,
      this.style,
      this.titleDialog = '',
      this.heightDialog})
      : super(
          key: key,
          initialValue: initialValue,
          name: name,
          validator: validator,
          valueTransformer: valueTransformer,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          onSaved: onSaved,
          enabled: enabled,
          onReset: onReset,
          decoration: decoration,
          focusNode: focusNode,
          builder: (FormFieldState<CourseVM?> field) {
            final state = field as _FormBuilderCourseState;
            return TextField(
              textAlign: textAlign,
              autofocus: false,
              decoration: state.decoration,
              readOnly: true,
              enabled: state.enabled,
              autocorrect: true,
              controller: state._textFieldController,
              focusNode: state.effectiveFocusNode,
              maxLines: 1,
              obscureText: false,
              showCursor: false,
              expands: false,
              style: style,
              enableInteractiveSelection: enableInteractiveSelection,
              textCapitalization: TextCapitalization.none,
              maxLengthEnforcement: MaxLengthEnforcement.none,
            );
          },
        );

  @override
  _FormBuilderCourseState createState() => _FormBuilderCourseState();
}

class _FormBuilderCourseState
    extends FormBuilderFieldState<FormBuilderCourse, CourseVM> {
  late TextEditingController _textFieldController;
  late CourseBloc courseBloc;

  @override
  void initState() {
    super.initState();
    courseBloc = BlocProvider.of(context);
    _textFieldController = widget.controller ?? TextEditingController();
    final initVal = value;
    _textFieldController.text =
        initVal == null ? widget.decoration.hintText ?? '' : initVal.name;
    effectiveFocusNode.addListener(_handleFocus);
  }

  @override
  void dispose() {
    effectiveFocusNode.removeListener(_handleFocus);
    if (null == widget.controller) {
      _textFieldController.dispose();
    }
    super.dispose();
  }

  Future<void> _handleFocus() async {
    if (effectiveFocusNode.hasFocus && enabled) {
      effectiveFocusNode.unfocus();
      await onShowDialog(context, value);
    }
  }

  Future<CourseVM?> onShowDialog(
      BuildContext context, CourseVM? currentValue) async {
    currentValue = value;
    final newValue = await _showDialogCourse();
    final finalValue = newValue ?? currentValue;
    didChange(finalValue);
    return finalValue;
  }

  @override
  void didChange(CourseVM? val) {
    super.didChange(val);
    _textFieldController.text =
        val == null ? widget.decoration.hintText ?? '' : val.name;
  }

  Future<CourseVM?> _showDialogCourse() async {
    FocusScope.of(context).requestFocus(FocusNode());
    courseBloc.add(CourseFetch(keyword: ""));
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SearchView(
                    onChange: (keyword) {
                      courseBloc.add(CourseFetch(
                        keyword: keyword.trim(),
                      ));
                    },
                  ),
                ),
                Expanded(
                  child: BlocConsumer<CourseBloc, CourseState>(
                      bloc: courseBloc,
                      listener: (context, state) {
                        if (state is CourseFetchFailed) {
                          AppExceptionHandle.handle(context, state.error);
                        }
                      },
                      builder: (contextBuilder, state) {
                        if (state is CourseLoading) {
                          return LoadingView();
                        }
                        if (state is CourseFetchSuccessful) {
                          return ListViewLoadMore(
                            onLoadMore: () => courseBloc.add(CourseLoadMore()),
                            list: state.listCourses,
                            item: (contextList, index) => _buildItemListCourse(
                                state.listCourses[index], index,
                                onPress: (course) {
                              Navigator.pop(context, course);
                            }),
                          );
                        }
                        if (state is CourseFetchEmpty) {
                          return EmptyView();
                        }
                        return Container();
                      }),
                ),
              ],
            )));
  }

  Widget _buildItemListCourse(CourseVM? course, int index,
      {Function(CourseVM vm)? onPress}) {
    if (course == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).primaryColor,
              ),
              height: 23.0,
              width: 23.0,
            ),
          )
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RippleInkWell(
            onTap: () {
              onPress?.call(course);
            },
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      ImagePaths.icLocation,
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        course.name,
                        style: SportperStyle.baseStyle,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )),
          ),
          Container(
            color: Color.fromRGBO(236, 236, 236, 1),
            height: 1,
          )
        ],
      );
    }
  }

  @override
  InputDecoration get decoration => widget.decoration.copyWith(
      errorText: widget.decoration.errorText ?? errorText,
      suffixIconConstraints: BoxConstraints(
        minHeight: 20,
        minWidth: 20,
      ),
      suffixIcon: Container(
        padding: EdgeInsets.only(right: 10),
        child: Image.asset(
          ImagePaths.icDropdown,
          width: 20,
          height: 20,
        ),
      ),
      prefixIconConstraints: BoxConstraints(
        minHeight: 20,
        minWidth: 20,
      ),
      contentPadding: EdgeInsets.fromLTRB(11, 13, 2, 12),
      prefixIcon: Padding(
        padding: EdgeInsets.only(right: 4, left: 10),
        child: Image.asset(
          ImagePaths.icLocation,
          width: 20,
          height: 20,
        ),
      ));
}
