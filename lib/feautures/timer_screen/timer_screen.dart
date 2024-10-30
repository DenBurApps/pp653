import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_app/core/domain/resources/app_text_styles.dart';
import 'package:habit_app/core/domain/resources/colors.dart';
import 'package:habit_app/core/data/habits_provider.dart';
import 'package:habit_app/core/domain/entities/habit/habit.dart';
import 'package:provider/provider.dart';

class TimerScreen extends StatefulWidget {
  final Habit habit;

  const TimerScreen({Key? key, required this.habit}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Duration habitDuration;
  late Duration remainingHabitDuration;
  Duration breakDuration = const Duration(minutes: 5);
  Timer? timer;
  bool isPaused = true;
  bool isBreak = false;

  @override
  void initState() {
    super.initState();
    habitDuration = _parseTime(widget.habit.time);
    remainingHabitDuration = habitDuration;
  }

  void startTimer(Duration duration, void Function() onTimerComplete) {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration.inSeconds > 0) {
        setState(() {
          duration = duration - const Duration(seconds: 1);
          if (isBreak) {
            breakDuration = duration;
          } else {
            remainingHabitDuration = duration;
          }
        });
      } else {
        timer.cancel();
        onTimerComplete();
      }
    });
    setState(() {
      isPaused = false;
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isPaused = true;
    });
  }

  void startBreak() {
    stopTimer();
    setState(() {
      breakDuration = const Duration(minutes: 5);
      isBreak = true;
    });
    startTimer(breakDuration, endBreak);
  }

  void endBreak() {
    setState(() {
      isBreak = false;
    });
    startTimer(remainingHabitDuration, () {});
  }

  Duration _parseTime(String time) {
    try {
      int minutes = int.parse(time);
      return Duration(minutes: minutes);
    } catch (e) {
      return const Duration(minutes: 10);
    }
  }

  String get formattedTime {
    final duration = isBreak ? breakDuration : remainingHabitDuration;
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  double get progressValue {
    if (isBreak) {
      return breakDuration.inSeconds / const Duration(minutes: 5).inSeconds;
    } else {
      return remainingHabitDuration.inSeconds / habitDuration.inSeconds;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void markAsDone() {
    Provider.of<HabitProvider>(context, listen: false)
        .toggleHabitStatus(widget.habit);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBackgroundOnPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 70,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: Text(
                      widget.habit.name,
                      style: AppTextStyles.timerStyle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.habit.description ?? "",
                    style: AppTextStyles.fieldLabelText,
                  ),
                  const SizedBox(height: 40),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 210,
                        height: 210,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.blackSurface,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.shortestSide * 0.6,
                        height: MediaQuery.of(context).size.shortestSide * 0.6,
                        child: CircularProgressIndicator(
                          value: progressValue,
                          strokeWidth: 4,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: AppTextStyles.timerStyleBig,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: startBreak,
                    child: Container(
                      width: 107,
                      height: 35,
                      decoration: BoxDecoration(
                        color: AppColors.blackBackgroundOnPrimary,
                        borderRadius: BorderRadius.circular(100),
                        border:
                            Border.all(width: 1, color: AppColors.blackSurface),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/Clock.svg"),
                            const Text(
                              '5 min break',
                              style: AppTextStyles.timerStyleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: stopTimer,
                          child: SvgPicture.asset("assets/Pause.svg"),
                        ),
                        GestureDetector(
                          onTap: markAsDone,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.blackSurface,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset("assets/Check.svg"),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isPaused) {
                              startTimer(
                                  isBreak
                                      ? breakDuration
                                      : remainingHabitDuration,
                                  () {});
                            }
                          },
                          child: SvgPicture.asset("assets/Play.svg"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.blackSurface,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset("assets/x.svg"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
