import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import '../gesture_detector.dart';

class SportperFormBuilderDropdown<T> extends FormBuilderField<T> {
  /// Called when an enclosing form is submitted. The value passed will be
  /// `null` if [format] fails to parse the text.
  final TextEditingController? controller;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool enableInteractiveSelection;
  final ValueTransformer<T>? textDisplayTransformer;
  final List<T> data;
  final String titleDialog;
  final double? heightDialog;

  /// Creates field for `Date`, `Time` and `DateTime` input
  SportperFormBuilderDropdown(
      {Key? key,
      //From Super
      required String name,
      required this.data,
      FormFieldValidator<T>? validator,
      T? initialValue,
      InputDecoration decoration = const InputDecoration(),
      ValueChanged<T?>? onChanged,
      ValueTransformer<T?>? valueTransformer,
      bool enabled = true,
      FormFieldSetter<T>? onSaved,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      VoidCallback? onReset,
      FocusNode? focusNode,
      this.textDisplayTransformer,
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
          builder: (FormFieldState<T?> field) {
            final state = field as _FormBuilderDateTimePickerState;
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
  _FormBuilderDateTimePickerState<T> createState() =>
      _FormBuilderDateTimePickerState<T>();
}

class _FormBuilderDateTimePickerState<T>
    extends FormBuilderFieldState<SportperFormBuilderDropdown<T>, T> {
  late TextEditingController _textFieldController;

  @override
  void initState() {
    super.initState();
    _textFieldController = widget.controller ?? TextEditingController();
    final initVal = value;
    _textFieldController.text = initVal == null
        ? widget.decoration.hintText
        : widget.textDisplayTransformer?.call(initVal) ?? initVal.toString();
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

  Future<T?> onShowDialog(BuildContext context, T? currentValue) async {
    currentValue = value;
    final newValue = await _showDialogDropdown();
    final finalValue = newValue ?? currentValue;
    didChange(finalValue);
    return finalValue;
  }

  @override
  void didChange(T? val) {
    super.didChange(val);
    _textFieldController.text = val == null
        ? widget.decoration.hintText
        : widget.textDisplayTransformer?.call(val) ?? val.toString();
  }

  Future<T?> _showDialogDropdown() async {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            height:
                widget.heightDialog ?? MediaQuery.of(context).size.height / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: Text(
                      widget.titleDialog,
                      style: SportperStyle.boldStyle.copyWith(fontSize: 18),
                    )),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        _buildItemList(widget.data[index], (T model) {
                      Navigator.pop(context, model);
                    }),
                    itemCount: widget.data.length,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )));
  }

  Widget _buildItemList(T model, Function(T model) onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RippleInkWell(
          onTap: () => onTap.call(model),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  widget.textDisplayTransformer?.call(model) ??
                      model.toString(),
                  style: SportperStyle.baseStyle,
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Color.fromRGBO(236, 236, 236, 1),
          height: 1,
        )
      ],
    );
  }

  @override
  InputDecoration get decoration => widget.decoration.copyWith(
      errorText: widget.decoration.errorText ?? errorText,
      suffixIconConstraints: BoxConstraints(
        minHeight: 20,
        minWidth: 20,
      ),
      contentPadding: EdgeInsets.fromLTRB(11, 13, 2, 12),
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Image.asset(
          ImagePaths.icDropdown,
          width: 20,
          height: 20,
        ),
      ));
}
