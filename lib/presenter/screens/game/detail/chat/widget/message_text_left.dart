import 'package:flutter/material.dart';
import 'package:sportper/presenter/screens/game/detail/chat/model/helpdesk_message_model.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class MessageTextLeft extends StatelessWidget {
  final ChatMessageVM message;

  MessageTextLeft({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(
          height: 6,
        ),
        // Padding(
        //   padding: EdgeInsets.only(left: 34),
        //   child: Text(
        //     content: message.member.fullName,
        //     size: 11,
        //     color: ColorUtils.disableColor,
        //   ),
        // ),
        // SizedBox(
        //   height: 2,
        // ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            AvatarCircle(
              url: message.member?.avatar ?? '',
              size: 32,
            ),
            SizedBox(width: 4),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              constraints: BoxConstraints(
                  minWidth: 0,
                  maxWidth: MediaQuery.of(context).size.width - 150),
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: SportperStyle.baseStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
      ],
    );
  }
}
