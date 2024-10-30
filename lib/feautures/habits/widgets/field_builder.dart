import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habit_app/core/domain/resources/app_text_styles.dart';
import 'package:habit_app/core/domain/resources/colors.dart';
import 'package:intl/intl.dart';

class FieldBuilder {
  static buildTextField(String labelText,
      {String? iconPath,
      bool isReadOnly = false,
      String? initialValue,
      Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blackSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          readOnly: isReadOnly,
          controller: initialValue != null
              ? TextEditingController(text: initialValue)
              : null,
          onChanged: onChanged,
          style: AppTextStyles.fieldLabelText,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: AppTextStyles.fieldLabelText,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            suffixIcon: iconPath != null
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: SvgPicture.asset(iconPath),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  static buildMinutesField(String labelText,
      {required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blackSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          keyboardType: TextInputType.number,
          controller: controller,
          style: AppTextStyles.fieldLabelText,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: AppTextStyles.fieldLabelText,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset("assets/Clock.svg"),
            ),
          ),
        ),
      ),
    );
  }

  static buildDateField(BuildContext context, String labelText,
      {String? initialValue, required Function(DateTime) onDateSelected}) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppColors.blackBackgroundOnPrimary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  disableModePicker: false,
                  disableMonthPicker: false,
                  calendarType: CalendarDatePicker2Type.single,
                  selectedDayHighlightColor: Colors.white,
                  weekdayLabelTextStyle: const TextStyle(color: Colors.white),
                  controlsTextStyle: const TextStyle(color: Colors.white),
                  dayTextStyle: const TextStyle(color: Colors.white),
                  selectedDayTextStyle: const TextStyle(color: Colors.black),
                  yearTextStyle: const TextStyle(color: Colors.white),
                  monthTextStyle: const TextStyle(color: Colors.white),
                ),
                value: initialValue != null
                    ? [DateFormat('yMMMd').parse(initialValue)]
                    : [],
                onValueChanged: (dates) {
                  if (dates.isNotEmpty && dates[0] != null) {
                    onDateSelected(dates[0]!);
                    Navigator.pop(context);
                  }
                },
              ),
            );
          },
        );
      },
      child: AbsorbPointer(
        child: buildTextField(
          labelText,
          initialValue: initialValue,
          iconPath: "assets/CalendarDots.svg",
          isReadOnly: true,
        ),
      ),
    );
  }
}
