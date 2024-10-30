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
    final TextEditingController _controller = TextEditingController(
      text: initialValue ?? '',
    );
    bool _isCalendarVisible = false; // Флаг для управления видимостью календаря

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isCalendarVisible = !_isCalendarVisible;
                });
              },
              child: AbsorbPointer(
                child: buildTextField(
                  labelText,
                  initialValue: _controller.text,
                  iconPath: "assets/CalendarDots.svg",
                  isReadOnly: true,
                ),
              ),
            ),
            if (_isCalendarVisible)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.blackSurface,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      lastMonthIcon: SvgPicture.asset("assets/Arrow_left.svg"),
                      nextMonthIcon: SvgPicture.asset("assets/Arrow_right.svg"),
                      disableModePicker: true,
                      disableMonthPicker: true,
                      calendarType: CalendarDatePicker2Type.single,
                      selectedDayHighlightColor: Colors.white,
                      weekdayLabelTextStyle:
                          const TextStyle(color: Colors.white),
                      controlsTextStyle: const TextStyle(color: Colors.white),
                      dayTextStyle: const TextStyle(color: Colors.white),
                      selectedDayTextStyle:
                          const TextStyle(color: Colors.black),
                      yearTextStyle: const TextStyle(color: Colors.white),
                      monthTextStyle: const TextStyle(color: Colors.white),
                    ),
                    value: _controller.text.isNotEmpty
                        ? [DateFormat('yMMMd').parse(_controller.text)]
                        : [],
                    onValueChanged: (dates) {
                      if (dates.isNotEmpty && dates[0] != null) {
                        final selectedDate = dates[0]!;
                        setState(() {
                          _controller.text =
                              DateFormat('yMMMd').format(selectedDate);
                          _isCalendarVisible =
                              false; // Закрыть календарь после выбора
                        });
                        onDateSelected(selectedDate);
                      }
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
