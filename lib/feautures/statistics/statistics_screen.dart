import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_app/core/data/habits_provider.dart';
import 'package:habit_app/core/domain/resources/app_text_styles.dart';
import 'package:intl/intl.dart';
import 'package:habit_app/core/domain/resources/colors.dart';
import 'package:habit_app/feautures/settings/settings_screen.dart';
import 'package:habit_app/core/domain/entities/habit/habit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  late final Box<Habit> _habitsBox;

  @override
  void initState() {
    super.initState();
    _habitsBox = Hive.box<Habit>('habits');
  }

  int getCompletedTasksInCurrentMonth() {
    final now = DateTime.now();
    return _habitsBox.values
        .where((habit) =>
            habit.isCompleted &&
            habit.date.year == now.year &&
            habit.date.month == now.month)
        .length;
  }

  int getTotalCompletedTasks() {
    return _habitsBox.values.where((habit) => habit.isCompleted).length;
  }

  void updateStreak(Habit habit) {
    final today = DateTime.now();
    final yesterday = today.subtract(Duration(days: 1));

    if (habit.lastCompletedDate != null &&
        habit.lastCompletedDate!.isBefore(yesterday)) {
      habit.streakCount = 1;
    } else {
      habit.streakCount = (habit.streakCount ?? 0) + 1;
    }

    habit.lastCompletedDate = today;
    habit.save();
  }

  int getCurrentMaxStreak() {
    return _habitsBox.values
        .map((habit) => habit.streakCount ?? 0)
        .fold(0, (prev, streak) => streak > prev ? streak : prev);
  }

  @override
  Widget build(BuildContext context) {
    final currentStreak = context.watch<HabitProvider>().currentStreak;
    final completedInCurrentMonth =
        context.watch<HabitProvider>().getCompletedTasksInCurrentMonth();
    final completedTotal =
        context.watch<HabitProvider>().getTotalCompletedTasks();

    final currentMonth = DateFormat.MMMM().format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blackBackgroundOnPrimary,
        title: const Text(
          "Statistics",
          style: AppTextStyles.appBarTitle,
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset("assets/Gear.svg"),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.blackBackgroundOnPrimary,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 104,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.blackSurface),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$currentStreak",
                            style: AppTextStyles.bigText,
                          ),
                          const Text("Days in a row",
                              style: AppTextStyles.weekDayLabel),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Image.asset("assets/shape.png"),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Container(
                    height: 124,
                    width: MediaQuery.of(context).size.width * 0.44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.blackSurface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 10),
                          child: Text(
                            '$completedInCurrentMonth',
                            style: AppTextStyles.bigText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text('Completed in\n$currentMonth',
                              style: AppTextStyles.weekDayLabel),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8, left: 8),
                  child: Container(
                    height: 124,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.blackSurface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 10),
                          child: Text(
                            '$completedTotal',
                            style: AppTextStyles.bigText,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text("Completed\ntotal",
                              style: AppTextStyles.weekDayLabel),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildCalendar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        CalendarDatePicker2(
          config: CalendarDatePicker2Config(
            lastMonthIcon: SvgPicture.asset("assets/Arrow_left.svg"),
            nextMonthIcon: SvgPicture.asset("assets/Arrow_right.svg"),
            disableModePicker: true,
            disableMonthPicker: true,
            currentDate: _focusedDate,
            calendarType: CalendarDatePicker2Type.single,
            selectedDayHighlightColor: Colors.white,
            weekdayLabelTextStyle: const TextStyle(color: Colors.white),
            controlsTextStyle: const TextStyle(color: Colors.white),
            dayTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400),
            selectedDayTextStyle: const TextStyle(color: Colors.black),
          ),
          onValueChanged: (dates) {
            setState(
              () {
                _selectedDate = dates.first ?? DateTime.now();
                _focusedDate = _selectedDate;
              },
            );
          },
          value: [_focusedDate],
        ),
      ],
    );
  }
}
