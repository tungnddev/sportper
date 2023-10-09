import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sportper/presenter/screens/game/detail/chat/model/helpdesk_message_model.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class MessageTextRight extends StatelessWidget {
  final ChatMessageVM message;

  MessageTextRight({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          height: 6,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              constraints: BoxConstraints(
                  minWidth: 0,
                  maxWidth: MediaQuery.of(context).size.width - 150),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: SportperStyle.baseStyle.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4),
            AvatarCircle(
              size: 32,
              url: message.member?.avatar ?? '',
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
