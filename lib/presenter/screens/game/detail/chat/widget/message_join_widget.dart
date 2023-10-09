import 'package:flutter/widgets.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class MessageJoinWidget extends StatelessWidget {

  final String content;

  const MessageJoinWidget({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFF0F0F0), width: 1),
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      alignment: Alignment.center,
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: SportperStyle.baseStyle.copyWith(fontSize: 13),
      ),
    );
  }
}
