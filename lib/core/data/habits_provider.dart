import 'package:flutter/material.dart';
import 'package:habit_app/core/domain/entities/habit/habit.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HabitProvider with ChangeNotifier {
  final Box<Habit> _habitsBox = Hive.box<Habit>('habits');

  List<Habit> get habits => _habitsBox.values.toList();
  int _currentStreak = 0;
  int get currentStreak => _currentStreak;

  HabitProvider() {
    _calculateCurrentStreak();
  }

  void addHabit(Habit habit) {
    _habitsBox.add(habit);
    notifyListeners();
  }

  void deleteHabit(Habit habit) {
    habit.delete();
    notifyListeners();
  }

  void toggleHabitStatus(Habit habit) {
    final today = DateTime.now();
    if (!habit.isCompleted) {
      if (habit.lastCompletedDate != null) {
        final daysDifference =
            today.difference(habit.lastCompletedDate!).inDays;
        if (daysDifference == 1) {
          habit.streakCount += 1;
        } else if (daysDifference > 1) {
          habit.streakCount = 1;
        }
      } else {
        habit.streakCount = 1;
      }
      habit.lastCompletedDate = today;
      habit.maxStreak = habit.streakCount > habit.maxStreak
          ? habit.streakCount
          : habit.maxStreak;
    } else {
      habit.streakCount = 0;
    }

    habit.isCompleted = !habit.isCompleted;
    habit.save();
    notifyListeners();
  }

  void _calculateCurrentStreak() {
    final today = DateTime.now();
    int streak = 0;
    for (int i = 0; i < _habitsBox.length; i++) {
      final habit = _habitsBox.values.toList()[i];
      final daysDifference =
          today.difference(habit.lastCompletedDate ?? today).inDays;
      if (daysDifference == i) {
        streak++;
      } else {
        break;
      }
    }
    _currentStreak = streak;
    notifyListeners();
  }

  int getTotalCompletedTasks() {
    return _habitsBox.values.where((habit) => habit.isCompleted).length;
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

  void updateHabit(
      String id, String name, String description, String time, DateTime date) {
    Habit? habit = _habitsBox.values.firstWhere(
      (habit) => habit.id == id,
      orElse: () => throw Exception('Habit not found'),
    );
    habit.name = name;
    habit.description = description;
    habit.time = time;
    habit.date = date;
    habit.save();
    notifyListeners();
  }
}
