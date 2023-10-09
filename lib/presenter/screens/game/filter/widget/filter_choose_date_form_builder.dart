import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:intl/intl.dart';

enum FilterChooseDateType { weekend, nextWeek, chooseDate }

class FilterDateVM {
  FilterChooseDateType type;
  DateTime? date;

  FilterDateVM(this.type, this.date);

  Pair<DateTime, DateTime> get range {
    var startDate = DateTime.now();
    var endDate = DateTime.now();
    switch (type) {
      case FilterChooseDateType.weekend:
        final deviation = DateTime.saturday - startDate.weekday;
        startDate = startDate.add(Duration(days: deviation));
        endDate = startDate.add(Duration(days: 1));
        break;
      case FilterChooseDateType.nextWeek:
        final deviation = DateTime.monday + 7 - startDate.weekday;
        startDate = startDate.add(Duration(days: deviation));
        endDate = startDate.add(Duration(days: 6));
        break;
      case FilterChooseDateType.chooseDate:
        startDate = date ?? startDate;
        endDate = date ?? endDate;
        break;
    }
    return Pair(_getOnlyStartDate(startDate), _getOnlyEndDate(endDate));
  }

  DateTime _getOnlyStartDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  DateTime _getOnlyEndDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
  }
}

class FilterChooseDateFormBuilder extends FormBuilderField<FilterDateVM> {
  FilterChooseDateFormBuilder({
    required String name,
    Key? key,
    FilterDateVM? initialValue,
  }) : super(
          key: key,
          name: name,
          initialValue: initialValue,
          builder: (FormFieldState<FilterDateVM?> field) {
            final state = field as _FilterChooseDateFormBuilderState;
            return state.buildWidget();
          },
        );

  @override
  _FilterChooseDateFormBuilderState createState() =>
      _FilterChooseDateFormBuilderState();
}

class _FilterChooseDateFormBuilderState
    extends FormBuilderFieldState<FilterChooseDateFormBuilder, FilterDateVM> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildWidget() {
    return SizedBox(
        height: 48,
        child: Row(
          children: [
            _buildItem(FilterChooseDateType.weekend),
            SizedBox(
              width: 7,
            ),
            _buildItem(FilterChooseDateType.nextWeek),
            SizedBox(
              width: 7,
            ),
            _buildItem(FilterChooseDateType.chooseDate),
          ],
        ));
  }

  _buildItem(FilterChooseDateType type) {
    bool isSelected = value?.type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if (type == FilterChooseDateType.chooseDate) {
            final newDate = await _showDatePicker();
            if (newDate != null) {
              didChange(FilterDateVM(FilterChooseDateType.chooseDate, newDate));
            }
            return;
          }
          didChange(FilterDateVM(type, null));
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
              if (type == FilterChooseDateType.chooseDate &&
                  value?.date != null)
                Text('(${DateFormat('MM/dd/yyyy').format(value!.date!)})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SportperStyle.baseStyle.copyWith(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  String _getTextType(FilterChooseDateType type) {
    switch (type) {
      case FilterChooseDateType.weekend:
        return Strings.weekend;
      case FilterChooseDateType.nextWeek:
        return Strings.nextWeek;
      case FilterChooseDateType.chooseDate:
        return Strings.chooseDate;
    }
  }

  Future<DateTime?> _showDatePicker() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
  }
}
