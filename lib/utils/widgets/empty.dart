import 'package:flutter/widgets.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class EmptyView extends StatelessWidget {

  final String? text;

  const EmptyView({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text ?? Strings.emptyData,
        style: SportperStyle.boldStyle.copyWith(fontSize: 22),
      ),
    );
  }
}
