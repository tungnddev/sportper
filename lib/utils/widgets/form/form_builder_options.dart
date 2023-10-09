import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class FormBuilderOptions<T> extends FormBuilderField<T> {
  final Function(int index, List<String> listImages)? onTap;
  final int initPosition;
  final ValueTransformer<T>? textDisplayTransformer;
  final List<T> data;

  FormBuilderOptions(
      {required String name,
      Key? key,
      ValueTransformer<T?>? valueTransformer,
      FormFieldValidator<T>? validator,
      this.onTap,
      this.initPosition = 0,
      required this.data,
      required this.textDisplayTransformer})
      : super(
          key: key,
          name: name,
          initialValue: initPosition == -1 ? null : data[initPosition],
          validator: validator,
          valueTransformer: valueTransformer,
          builder: (FormFieldState<T?> field) {
            final state = field as _FormBuilderOptionsState;
            return state.buildWidget();
          },
        );

  @override
  _FormBuilderOptionsState<T> createState() => _FormBuilderOptionsState<T>();
}

class _FormBuilderOptionsState<T>
    extends FormBuilderFieldState<FormBuilderOptions<T>, T> {
  int _currentPosition = -1;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.initPosition;
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

  _buildItem(int position, T item) {
    bool isSelected = position == _currentPosition;
    return GestureDetector(
      onTap: () {
        if (_currentPosition == position) return;
        _currentPosition = position;
        didChange(item);
      },
      child: Container(
        margin: EdgeInsets.only(left: position == 0 ? 0 : 7),
        width: (MediaQuery.of(context).size.width - 24 * 2 - 7) / 2,
        height: 48,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Color(0xFFF0F0F0),
                width: 1)),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            SizedBox(
              width: 14,
            ),
            Image.asset(
              ImagePaths.icType,
              width: 20,
              height: 20,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Text(
                    widget.textDisplayTransformer?.call(item) ?? item.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SportperStyle.baseStyle))
          ],
        ),
      ),
    );
  }
}
