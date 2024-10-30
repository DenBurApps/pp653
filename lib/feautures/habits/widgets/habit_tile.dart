import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_app/core/domain/resources/app_text_styles.dart';
import 'package:habit_app/core/domain/resources/colors.dart';
import 'package:habit_app/core/data/habits_provider.dart';
import 'package:habit_app/core/domain/entities/habit/habit.dart';
import 'package:habit_app/feautures/habits/widgets/field_builder.dart';
import 'package:habit_app/feautures/timer_screen/timer_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  const HabitTile({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    var habitProvider = Provider.of<HabitProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          if (habit.isCompleted == false) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TimerScreen(
                          habit: habit,
                        )));
          }
        },
        child: Slidable(
          key: Key(habit.id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.3,
            children: [
              SlidableAction(
                onPressed: (context) => _openEditHabitModal(context),
                backgroundColor: AppColors.yelowEdit,
                foregroundColor: Colors.white,
                icon: Icons.mode_edit_outline_outlined,
                label: '',
                padding: const EdgeInsets.all(8),
              ),
              SlidableAction(
                onPressed: (context) => habitProvider.deleteHabit(habit),
                backgroundColor: AppColors.redDelete,
                foregroundColor: Colors.white,
                icon: Icons.delete_outline,
                label: '',
                padding: const EdgeInsets.all(8),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.blackBackgroundOnPrimary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        habitProvider.toggleHabitStatus(habit);
                      },
                      icon: habit.isCompleted
                          ? SvgPicture.asset("assets/checkbox_fill.svg")
                          : SvgPicture.asset("assets/checkbox_empty.svg"),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name.length > 20
                              ? "${habit.name.substring(0, 20)}..."
                              : habit.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: "SF Pro Display",
                            color: habit.isCompleted
                                ? AppColors.greyOnSurface
                                : Colors.white,
                            decoration: habit.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontSize: 16,
                            decorationColor: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          (habit.description ?? "").length > 20
                              ? "${habit.description!.substring(0, 20)}..."
                              : habit.description ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.habitDescription,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      habit.isCompleted ? "Done" : "Start",
                      style: AppTextStyles.habitStatus(habit.isCompleted),
                    ),
                    Text(
                      "${habit.time} min",
                      style: AppTextStyles.habitTime,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openEditHabitModal(BuildContext context) {
    var habitProvider = Provider.of<HabitProvider>(context, listen: false);

    // Создаем контроллер для времени
    final TextEditingController _timeController =
        TextEditingController(text: habit.time);

    String _habitName = habit.name;
    String _habitDescription = habit.description ?? '';
    DateTime? _habitDate = habit.date;

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
                      'Edit Habit',
                      style: AppTextStyles.modalTitle,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _habitName = habit.name;
                            _habitDescription = habit.description ?? '';
                            _timeController.text = habit.time;
                            _habitDate = habit.date;
                          },
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
                                "Reset",
                                style: AppTextStyles.modalButtonText,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            habitProvider.updateHabit(
                              habit.id,
                              _habitName,
                              _habitDescription,
                              _timeController.text, // Сохраняем введенное время
                              _habitDate!,
                            );

                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 58,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: Text(
                                "Save",
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
                  initialValue: _habitName,
                  onChanged: (value) => _habitName = value,
                ),
                FieldBuilder.buildTextField(
                  'Description of the habit (optional)',
                  initialValue: _habitDescription,
                  onChanged: (value) => _habitDescription = value,
                ),
                FieldBuilder.buildMinutesField(
                  'Time to perform (in minutes)',
                  controller: _timeController, // Используем контроллер
                ),
                FieldBuilder.buildDateField(
                  context,
                  'Select a date',
                  initialValue: _habitDate != null
                      ? DateFormat('yMMMd').format(_habitDate!)
                      : 'Select a date',
                  onDateSelected: (date) => _habitDate = date,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
