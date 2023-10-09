import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/text_style.dart';

class SearchView extends StatefulWidget {
  final Function(String text)? onChange;

  SearchView({this.onChange});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  Timer? _debounce;
  final _edtController = TextEditingController();
  FocusNode _focusEditText = new FocusNode();

  _SearchViewState();

  bool isShowDeleteAllSearch = false;
  bool isShowCancelSearch = false;

  @override
  void dispose() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusEditText.addListener(() {
      setState(() {
        isShowCancelSearch = _focusEditText.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(8)),
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
                      focusNode: _focusEditText,
                      style: SportperStyle.baseStyle,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Strings.searchForAddress,
                          isDense: true),
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (text) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 500), () {
                              widget.onChange?.call(text);
                            });
                        setState(() {
                          isShowDeleteAllSearch = text.isNotEmpty;
                        });
                      },
                    ),
                  ),
                  // Visibility(
                  //   visible: isShowDeleteAllSearch,
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 5),
                  //     child: CustomIconButton(
                  //       onClick: () {
                  //         _edtController.text = "";
                  //         widget.onChange?.call("");
                  //         setState(() {
                  //           isShowDeleteAllSearch = false;
                  //         });
                  //       },
                  //       image: ImageUtils.icDelete,
                  //       size: 22,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          // Visibility(
          //   visible: isShowCancelSearch,
          //   child: GestureDetector(
          //     onTap: () {
          //       FocusScope.of(context).requestFocus(FocusNode());
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 10),
          //       child: TextNormal(
          //           content: S.of(context).cancel,
          //           color: Theme.of(context).primaryColor,
          //           size: 14),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}