import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:collection/collection.dart';

import '../pair.dart';

class SportperTabBar<T> extends StatefulWidget {
  final List<Pair<String, T>> listTabs;
  final void Function(T) onChange;

  const SportperTabBar({Key? key, required this.listTabs, required this.onChange})
      : super(key: key);

  @override
  State<SportperTabBar> createState() => _SportperTabBarState<T>(onChange);
}

class _SportperTabBarState<T> extends State<SportperTabBar> {
  final void Function(T) onChange;


  _SportperTabBarState(this.onChange);

  int _currentTabSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        children: widget.listTabs
            .mapIndexed((index, element) => _buildTab(index))
            .toList(),
      ),
    );
  }

  Widget _buildTab(int index) => Expanded(
    flex: 1,
    child: GestureDetector(
      onTap: () {
            setState(() {
              _currentTabSelected = index;
            });
             onChange(widget.listTabs[index].second as T);
          },
      child: Container(
          decoration: BoxDecoration(
            color:
                index == _currentTabSelected ? Colors.white : Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.listTabs[index].first,
            textAlign: TextAlign.center,
            style: SportperStyle.baseStyle.copyWith(
                fontWeight: index == _currentTabSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: index == _currentTabSelected
                    ? Color(0xFF262626)
                    : Color(0xFF7B7B7B)),
          ),
        ),
    ),
  );
}
