import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class ReplyNoteText extends StatelessWidget {
  final String userName;
  final Function()? clearReply;

  const ReplyNoteText({Key? key, required this.userName, this.clearReply})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF323232),
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${Strings.replyingTo} $userName',
              style: SportperStyle.baseStyle
                  .copyWith(fontSize: 12, color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(6),
            child: GestureDetector(
              onTap: clearReply,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
