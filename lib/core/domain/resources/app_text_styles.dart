import 'package:flutter/material.dart';
import 'package:habit_app/core/domain/resources/colors.dart';

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: "SF Pro Display",
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle noHabitsTitle = TextStyle(
    fontFamily: "SF Pro Display",
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle noHabitsSubtitle = TextStyle(
    fontFamily: "SF Pro Display",
    color: Color.fromARGB(255, 231, 231, 239),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle weekDayLabel = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle dayNumber(bool isToday) => TextStyle(
        color: isToday ? Colors.black : Colors.white,
        fontWeight: FontWeight.bold,
      );

  static const TextStyle habitTitle = TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle habitDescription = TextStyle(
    fontFamily: "SF Pro Display",
    color: AppColors.greyOnSurface,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle habitStatus(bool isCompleted) => TextStyle(
        fontFamily: "SF Pro Display",
        color: isCompleted ? AppColors.greenDone : Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static const TextStyle habitTime = TextStyle(
    fontFamily: "SF Pro Display",
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle modalTitle = TextStyle(
    fontFamily: "SF Pro Display",
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle modalButtonText = TextStyle(
    fontFamily: "SF Pro Display",
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle fieldLabelText = TextStyle(
    fontFamily: "SF Pro Display",
    color: AppColors.greyOnBackground,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle onboardingTitle = TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 32.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle onboardingDescription = TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.greyOnBackground,
  );

  static const TextStyle onboardingButtonText = TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.blackSurface,
  );
  static const TextStyle settingsTile = TextStyle(
      fontFamily: "SF Pro Display",
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400);
  static const TextStyle bigText = TextStyle(
      fontFamily: "SF Pro Display",
      color: Colors.white,
      fontSize: 42,
      fontWeight: FontWeight.w400);
  static const TextStyle timerStyle = TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.greyOnBackground,
  );
  static const TextStyle timerStyleBig = TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: AppColors.greyOnSurface,
  );
  static const TextStyle timerStyleSmall = TextStyle(
    fontFamily: "SF Pro Display",
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.greyOnSurface,
  );
}
