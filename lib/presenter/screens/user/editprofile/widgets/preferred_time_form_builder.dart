import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class PreferredTimeFormBuilder extends FormBuilderField<String> {
  final List<String> data;

  PreferredTimeFormBuilder(
      {required String name,
        Key? key,
        ValueTransformer<String?>? valueTransformer,
        FormFieldValidator<String>? validator,
        String? initValue,
        required this.data})
      : super(
    key: key,
    name: name,
    initialValue: initValue,
    validator: validator,
    valueTransformer: valueTransformer,
    builder: (FormFieldState<String?> field) {
      final state = field as _PreferredTimeFormBuilderState;
      return state.buildWidget();
    },
  );

  @override
  _PreferredTimeFormBuilderState createState() => _PreferredTimeFormBuilderState();
}

class _PreferredTimeFormBuilderState
    extends FormBuilderFieldState<PreferredTimeFormBuilder, String> {

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get isValid => widget.validator?.call(value) == null;

  Widget buildWidget() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) =>
            _buildItem(position, widget.data[position]),
        itemCount: widget.data.length,
      ),
    );
  }

  _buildItem(int position, String item) {
    bool isSelected = item == value;
    return GestureDetector(
      onTap: () {
        didChange(item);
      },
      child: Container(
        margin: EdgeInsets.only(left: position == 0 ? 0 : 7),
        width: (MediaQuery.of(context).size.width - 24 * 2 - 7 * 4) / 5,
        height: 48,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Color(0xFFF0F0F0),
                width: 1)),
        alignment: Alignment.center,
        child: Text(
          item,
          style: SportperStyle.baseStyle,
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}
