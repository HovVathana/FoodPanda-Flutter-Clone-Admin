import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_admin/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_admin/constants/colors.dart';

Future<void> showDateDialog({
  required BuildContext context,
  required DateTime startingDate,
  required DateTime expiredDate,
  required Function(DateTime, DateTime) onChange,
}) async {
  return await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (context) {
        List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
          startingDate,
          expiredDate,
        ];

        final config = CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.range,
          selectedDayHighlightColor: scheme.primary,
          weekdayLabelTextStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          controlsTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        );

        return StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 3,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey[300],
                  ),
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 10),
                const Text('Starting Date - Expired Date'),
                CalendarDatePicker2(
                  config: config,
                  value: _rangeDatePickerValueWithDefaultValue,
                  onValueChanged: (dates) => setState(
                      () => _rangeDatePickerValueWithDefaultValue = dates),
                ),
                CustomTextButton(
                  text: 'Confirm',
                  onPressed: () {
                    onChange(
                      _rangeDatePickerValueWithDefaultValue[0]!,
                      _rangeDatePickerValueWithDefaultValue[1]!,
                    );
                    Navigator.pop(context);
                  },
                  // isDisabled: _rangeDatePickerValueWithDefaultValue[0] == null ||
                  //     _rangeDatePickerValueWithDefaultValue[1] == null,
                  isDisabled: _rangeDatePickerValueWithDefaultValue.length != 2,
                ),
              ],
            ),
          );
        });
      });
}
