import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class ReadMoreText extends StatefulWidget {
  final String content;
  final Function()? onReadMore;

  const ReadMoreText({Key? key, required this.content, this.onReadMore})
      : super(key: key);

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool readAll = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LayoutBuilder(builder: (context, size) {
          if (readAll) {
            return Text(
              widget.content,
              style: SportperStyle.baseStyle,
            );
          } else {
            var span = TextSpan(
              text: widget.content,
              style: SportperStyle.baseStyle,
            );

            var tp = TextPainter(
              maxLines: 3,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              text: span,
            );

            tp.layout(maxWidth: size.maxWidth);

            var exceeded = tp.didExceedMaxLines;

            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.content,
                    style: SportperStyle.baseStyle,
                    maxLines: readAll ? null : 3,
                  ),
                  if (exceeded)
                    GestureDetector(
                      onTap: () {
                        if (widget.onReadMore != null) {
                          widget.onReadMore?.call();
                        } else {
                          setState(() {
                            readAll = true;
                          });
                        }
                      },
                      child: Text(
                        Strings.readMore,
                        style: SportperStyle.baseStyle
                            .copyWith(color: ColorUtils.colorTheme),
                      ),
                    )
                ]);
          }
        }),
      ],
    );
  }
}
