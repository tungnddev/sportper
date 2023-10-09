import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendText;

  const ChatInputWidget(
      {Key? key, required this.onSendText})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatInputState();
  }
}

class _ChatInputState extends State<ChatInputWidget> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onTapSendText() {
    if (_textController.text.trim().isEmpty) return;
    widget.onSendText.call(_textController.text.trim());
    _textController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Color(0xFFF0F0F0)),
            borderRadius: BorderRadius.circular(8)
          ),
          padding: EdgeInsets.only(left: 18, right: 8, top: 6, bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 100.0,
                    ),
                    child: TextField(
                      maxLines: null,
                      controller: _textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: Strings.typeYourMessage,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: _onTapSendText,
                child: Image.asset(
                  ImagePaths.icSend,
                  fit: BoxFit.contain,
                  width: 40,
                  height: 40,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
