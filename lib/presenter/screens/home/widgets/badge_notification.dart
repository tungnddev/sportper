import 'package:flutter/widgets.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class BadgeNotification extends StatefulWidget {
  final int count;
  final double? size;
  final double? fontSize;

  const BadgeNotification({Key? key, this.count = 0, this.fontSize, this.size})
      : super(key: key);

  @override
  _BadgeNotificationState createState() => _BadgeNotificationState();
}

class _BadgeNotificationState extends State<BadgeNotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Color(0xFFEB5757),
        borderRadius: BorderRadius.circular(widget.size ?? 6),
      ),
      constraints: BoxConstraints(
          minWidth: widget.size ?? 12, minHeight: widget.size ?? 12),
      child: Center(
        child: Text(
          widget.count.toString(),
          textAlign: TextAlign.center,
          style: SportperStyle.baseStyle.copyWith(
            color: Color(0xFFF2F2F2),
            fontSize: widget.fontSize ?? 8
          ),
        ),
      ),
    );
  }
}