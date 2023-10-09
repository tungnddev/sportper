import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class TrueFalseFormBuilder extends FormBuilderField<bool> {
  final String title;
  final bool initValue;

  TrueFalseFormBuilder(
      {required String name, Key? key, this.title = "", this.initValue = false})
      : super(
    key: key,
    name: name,
    initialValue: initValue,
    builder: (FormFieldState<bool?> field) {
      final state = field as _TrueFalseFormBuilderState;
      return state.buildWidget();
    },
  );

  @override
  _TrueFalseFormBuilderState createState() => _TrueFalseFormBuilderState();
}

class _TrueFalseFormBuilderState
    extends FormBuilderFieldState<TrueFalseFormBuilder, bool> {
  Widget buildWidget() {
    return Container(
      padding: EdgeInsets.only(top: 14, bottom: 14, left: 14, right: 14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFF0F0F0), width: 1)
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(
                widget.title,
                style: SportperStyle.baseStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          SizedBox(
            width: 10,
          ),
          _buildYesWidget(),
          SizedBox(width: 8,),
          _buildNoWidget()
        ],
      ),
    );
  }

  _buildYesWidget() {
    return GestureDetector(
      onTap: () {
        if (value != true) {
          didChange(true);
        }
      },
      child: Container(
        width: 60,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xFFE7F6E9),
            border: value == true ? Border.all(
                color: ColorUtils.green, width: 1) : null
        ),
        child: Text(
          Strings.yes.toUpperCase(),
          style: SportperStyle.boldStyle.copyWith(color: ColorUtils.green),
        ),
      ),
    );
  }

  _buildNoWidget() {
    return GestureDetector(
      onTap: () {
        if (value != false) {
          didChange(false);
        }
      },
      child: Container(
        width: 60,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xFFFFE9EF),
            border: value == false ? Border.all(
                color: ColorUtils.red, width: 1) : null
        ),
        child: Text(
          Strings.no.toUpperCase(),
          style: SportperStyle.boldStyle.copyWith(color: ColorUtils.red),
        ),
      ),
    );
  }
}
