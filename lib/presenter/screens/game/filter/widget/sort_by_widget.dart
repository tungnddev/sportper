import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportper/domain/entities/sort_game.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:intl/intl.dart';

class GameSortFormBuilder extends FormBuilderField<SortGame> {
  GameSortFormBuilder({
    required String name,
    Key? key,
    required SortGame initialValue,
  }) : super(
          key: key,
          name: name,
          initialValue: initialValue,
          builder: (FormFieldState<SortGame?> field) {
            final state = field as _FilterChooseDateFormBuilderState;
            return state.buildWidget();
          },
        );

  @override
  _FilterChooseDateFormBuilderState createState() =>
      _FilterChooseDateFormBuilderState();
}

class _FilterChooseDateFormBuilderState
    extends FormBuilderFieldState<GameSortFormBuilder, SortGame> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildWidget() {
    return SizedBox(
        height: 48,
        child: Row(
          children: [
            _buildItem(SortGame.daysAway),
            SizedBox(
              width: 7,
            ),
            _buildItem(SortGame.distance),
          ],
        ));
  }

  _buildItem(SortGame type) {
    bool isSelected = value == type;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          didChange(type);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Color(0xFFF0F0F0),
                  width: 1)),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_getTextType(type),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: SportperStyle.baseStyle),
            ],
          ),
        ),
      ),
    );
  }

  String _getTextType(SortGame type) {
    switch (type) {
      case SortGame.distance:
        return Strings.sortByDistance;
      case SortGame.daysAway:
        return Strings.sortByDaysAway;
    }
  }
}
