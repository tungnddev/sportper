import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class JoinSearchView extends StatefulWidget {
  final Function(String text)? onChange;
  final Function()? onTapFilter;

  JoinSearchView({this.onChange, this.onTapFilter});

  @override
  _JoinSearchViewState createState() => _JoinSearchViewState();
}

class _JoinSearchViewState extends State<JoinSearchView> {
  Timer? _debounce;

  _JoinSearchViewState();

  @override
  void dispose() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.only(left: 6, top: 6, bottom: 6, right: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(3),
            child: Image.asset(
              ImagePaths.icSearch,
              width: 24,
              height: 24,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: TextField(
              style: SportperStyle.baseStyle,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Strings.searchForGame,
                  isDense: true),
              textAlignVertical: TextAlignVertical.center,
              onChanged: (text) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  widget.onChange?.call(text);
                });
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: widget.onTapFilter,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
              ),
              alignment: Alignment.center,
              child: Image.asset(
                ImagePaths.icFilter,
                width: 24,
                height: 24,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
