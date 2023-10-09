import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportper/utils/definded/images.dart';

import '../text_style.dart';

class SportperFormBuilderSwitch extends FormBuilderField<bool> {
  final String title;
  final bool initValue;

  SportperFormBuilderSwitch(
      {required String name, Key? key, this.title = "", this.initValue = false})
      : super(
          key: key,
          name: name,
          initialValue: initValue,
          builder: (FormFieldState<bool?> field) {
            final state = field as _SportperFormBuilderSwitchState;
            return state.buildWidget();
          },
        );

  @override
  _SportperFormBuilderSwitchState createState() => _SportperFormBuilderSwitchState();
}

class _SportperFormBuilderSwitchState
    extends FormBuilderFieldState<SportperFormBuilderSwitch, bool> {
  Widget buildWidget() {
    return GestureDetector(
      onTap: () {
        final newValue = value == true ? false : true;
        didChange(newValue);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: value == true
                    ? Theme.of(context).primaryColor
                    : Color(0xFFF0F0F0),
                width: 1)),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SizedBox(
              width: 14,
            ),
            Expanded(
                child: Text(widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SportperStyle.baseStyle)),
            SizedBox(
              width: 8,
            ),
            Image.asset(
              value == true ? ImagePaths.icSwitchOn : ImagePaths.icSwitchOff,
              width: 24,
              height: 24,
            ),
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }
}
