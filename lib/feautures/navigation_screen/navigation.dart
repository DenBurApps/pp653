import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_app/core/domain/resources/colors.dart';
import 'package:habit_app/core/data/habits_provider.dart';
import 'package:habit_app/core/domain/entities/habit/habit.dart';
import 'package:habit_app/feautures/habits/habits_screen.dart';
import 'package:habit_app/feautures/habits/widgets/field_builder.dart';
import 'package:habit_app/feautures/statistics/statistics_screen.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HabitsScreen(),
    Container(),
    const StatisticsScreen()
  ];

  String _habitName = '';
  String _habitDescription = '';
  String _habitTime = '';
  DateTime? _habitDate;
  final TextEditingController _dateController = TextEditingController();

  final _habitsBox = Hive.box<Habit>('habits');

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBackgroundOnPrimary,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: AppColors.greyOnBackground,
        selectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(
            fontFamily: "SF Pro Display",
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w400),
        unselectedLabelStyle: const TextStyle(
            fontFamily: "SF Pro Display",
            color: AppColors.greyOnBackground,
            fontSize: 11,
            fontWeight: FontWeight.w400),
        backgroundColor: AppColors.blackBackgroundOnPrimary,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            _openAddTaskModal(context);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/ListChecks.svg"),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.blackSurface,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/Plus.svg",
                    width: 18,
                    height: 18,
                  ),
                )),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/ChartLine.svg",
            ),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }

  void _openAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.blackBackgroundOnPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 54,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: AppColors.greyOnSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Habit',
                      style: TextStyle(
                        fontFamily: "SF Pro Display",
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _clearFields,
                          child: Container(
                            width: 60,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.blackBackgroundOnPrimary,
                              border: Border.all(
                                  color: AppColors.blackSurface, width: 1),
                            ),
                            child: const Center(
                              child: Text(
                                "Clear",
                                style: TextStyle(
                                  fontFamily: "SF Pro Display",
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: _addHabit,
                          child: Container(
                            width: 58,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: Text(
                                "Done",
                                style: TextStyle(
                                  fontFamily: "SF Pro Display",
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FieldBuilder.buildTextField(
                  'Name of habit',
                  onChanged: (value) => _habitName = value,
                ),
                FieldBuilder.buildTextField(
                  'Description of the habit (optional)',
                  onChanged: (value) => _habitDescription = value,
                ),
                _buildTimeField('Time to perform (in minutes)'),
                _buildDateField(context, 'Select a date'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateField(BuildContext context, String labelText) {
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
                value: _habitDate != null ? [_habitDate!] : [],
                onValueChanged: (dates) {
                  if (dates.isNotEmpty && dates[0] != null) {
                    setState(() {
                      _habitDate = dates[0];
                      _dateController.text =
                          DateFormat('yMMMd').format(_habitDate!);
                    });
                    Navigator.pop(context);
                  }
                },
              ),
            );
          },
        );
      },
      child: AbsorbPointer(
        child: FieldBuilder.buildTextField(
          labelText,
          iconPath: "assets/CalendarDots.svg",
          isReadOnly: true,
          initialValue: _dateController.text.isNotEmpty
              ? _dateController.text
              : 'Select a date',
        ),
      ),
    );
  }

  Widget _buildTimeField(String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blackSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            setState(() {
              _habitTime = value;
            });
          },
          style: const TextStyle(
            fontFamily: "SF Pro Display",
            color: AppColors.greyOnSurface,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
              fontFamily: "SF Pro Display",
              color: AppColors.greyOnBackground,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
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

  void _clearFields() {
    setState(() {
      _habitName = '';
      _habitDescription = '';
      _habitTime = '';
      _habitDate = null;
      _dateController.clear();
    });
  }

  void _addHabit() {
    if (_habitName.isNotEmpty && _habitDate != null) {
      final newHabit = Habit(
          name: _habitName,
          description: _habitDescription,
          time: _habitTime,
          date: _habitDate!,
          lastCompletedDate: DateTime.now(),
          streakCount: 0,
          maxStreak: 0);

      Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);

      Navigator.pop(context);
    }
  }
}
