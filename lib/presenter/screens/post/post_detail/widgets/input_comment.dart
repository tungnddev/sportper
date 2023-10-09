import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/presenter/screens/post/post_detail/input_comment_bloc/input_comment_bloc.dart';
import 'package:sportper/presenter/screens/post/post_detail/input_comment_bloc/input_comment_event.dart';
import 'package:sportper/presenter/screens/post/post_detail/input_comment_bloc/input_comment_state.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/image_picker.dart';
import 'package:sportper/utils/widgets/loading_view.dart';

class InputComment extends StatefulWidget {
  final FocusNode textFocus;
  final Function(String text, String? image)? onSend;
  final InputCommentBloc bloc;

  const InputComment({Key? key, required this.textFocus, this.onSend, required this.bloc}) : super(key: key);

  @override
  State<InputComment> createState() => _InputCommentState();
}

class _InputCommentState extends State<InputComment> {
  ValueNotifier<String?> imageNotifier = ValueNotifier<String?>(null);
  TextEditingController _textController = TextEditingController();

  void _onTapSendText() {
    if (_textController.text.trim().isEmpty && imageNotifier.value == null) return;
    if (imageNotifier.value != null) {
      widget.bloc.add(UploadImageEvent(imageNotifier.value!));
      return;
    }
    widget.onSend?.call(_textController.text.trim(), null);
    _textController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ValueListenableBuilder<String?>(
            valueListenable: imageNotifier,
            builder: (context, value, child) {
              if (value == null) return SizedBox();
              return _buildItemImage(value);
            }),
        Container(
          color: ColorUtils.border,
          height: 1,
        ),
        Row(
          children: [
            SizedBox(width: 5,),
            ValueListenableBuilder<String?>(
              valueListenable: imageNotifier,
              builder: (context, value, child) => GestureDetector(
                onTap: () {
                  if (value == null) {
                    FocusScope.of(context).unfocus();
                    WidgetsBinding.instance
                        ?.addPostFrameCallback((timeStamp) async {
                      String? newImagePath = await openImagePicker(context);
                      if (newImagePath != null) {
                        imageNotifier.value = newImagePath;
                      }
                    });
                    // show image
                  }
                },
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      ImagePaths.icCamera,
                      width: 30,
                      height: 30,
                      color: value == null
                          ? ColorUtils.colorTheme
                          : ColorUtils.disableText,
                    )),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 100.0,
                  ),
                  child: TextField(
                    maxLines: null,
                    focusNode: widget.textFocus,
                    controller: _textController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: Strings.typeYourComment,
                    ),
                  ),
                ),
              ),
            ),
            BlocConsumer(
              bloc: widget.bloc,
              listener: (context, state) {
                if (state is InputCommentUploadImageSuccessfully) {
                  widget.onSend?.call(_textController.text.trim(), state.url);
                  imageNotifier.value = null;
                  _textController.text = "";
                }
              } ,
              builder: (context, state) {
                if (state is InputCommentUploadLoading) {
                  return SizedBox(
                    width: 40,
                    height: 40,
                    child: LoadingView(
                      size: 20, strokeWidth: 2,
                    )
                  );
                }
                return InkWell(
                  onTap: _onTapSendText,
                  child: Image.asset(
                    ImagePaths.icSend,
                    fit: BoxFit.contain,
                    width: 30,
                    height: 30,
                  ),
                );
              }
            ),
            SizedBox(width: 10,),
          ],
        )
      ],
    );
  }

  _buildItemImage(String image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: ColorUtils.border,
          height: 1,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.file(
                  File(image),
                  width: 100,
                  height: 100,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    imageNotifier.value = null;
                  },
                  child: Image.asset(
                    ImagePaths.icDeleteImage,
                    width: 24,
                    height: 24,
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
