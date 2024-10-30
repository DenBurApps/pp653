import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habit_app/core/domain/resources/app_text_styles.dart';
import 'package:habit_app/core/data/habits_provider.dart';
import 'package:habit_app/feautures/habits/widgets/habit_tile.dart';
import '../../core/domain/resources/colors.dart';
import '../settings/settings_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBackgroundOnPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.blackBackgroundOnPrimary,
        title: const Text(
          "My habits",
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
          )
        ],
      ),
      body: Column(
        children: [
          _buildWeekCalendar(),
          Expanded(
            child: Consumer<HabitProvider>(
              builder: (context, habitProvider, child) {
                final habits = habitProvider.habits;
                if (habits.isEmpty) {
                  return _buildNoHabitsMessage();
                } else {
                  return ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      return HabitTile(habit: habit);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildNoHabitsMessage() {
  return Padding(
    padding: const EdgeInsets.only(top: 160),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/ListChecks.svg",
            width: 32,
            height: 32,
          ),
          const SizedBox(height: 16),
          const Text(
            "No habits",
            style: AppTextStyles.noHabitsTitle,
          ),
          const SizedBox(height: 8),
          const Text(
            "Create a new habit by clicking the «+» button below",
            style: AppTextStyles.noHabitsSubtitle,
          ),
        ],
      ),
    ),
  );
}

Widget _buildWeekCalendar() {
  DateTime today = DateTime.now();
  DateTime firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
  List<DateTime> weekDays =
      List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: weekDays.map((date) {
        bool isToday = date.day == today.day &&
            date.month == today.month &&
            date.year == today.year;
        return Column(
          children: [
            Text(
              DateFormat.E().format(date),
              style: AppTextStyles.weekDayLabel,
            ),
            const SizedBox(height: 4),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isToday ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${date.day}',
                style: AppTextStyles.dayNumber(isToday),
              ),
            ),
          ],
        );
      }).toList(),
    ),
  );
}
