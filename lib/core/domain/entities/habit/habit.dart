import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'habit.g.dart'; // Убедитесь, что этот файл будет сгенерирован

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String time;

  @HiveField(3)
  String? description;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  int streakCount;

  @HiveField(7)
  DateTime? lastCompletedDate;

  @HiveField(8)
  int maxStreak;

  Habit({
    required this.name,
    required this.time,
    this.description,
    required this.date,
    this.isCompleted = false,
    this.streakCount = 0,
    this.lastCompletedDate,
    this.maxStreak = 0,
  }) : id = const Uuid().v4();
}
