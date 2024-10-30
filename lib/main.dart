import 'package:flutter/material.dart';
import 'package:habit_app/core/data/habits_provider.dart';
import 'package:habit_app/core/domain/entities/habit/habit.dart';
import 'package:habit_app/feautures/onboarding_screen/onboarding_screen.dart';
import 'package:habit_app/feautures/navigation_screen/navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>('habits');
  var box = await Hive.openBox('app_settings');

  bool isFirstLaunch = box.get('isFirstLaunch', defaultValue: true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HabitProvider(),
        ),
      ],
      child: MyApp(
        isFirstLaunch: isFirstLaunch,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  const MyApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isFirstLaunch ? OnboardingScreen() : const BottomNavBar(),
      debugShowCheckedModeBanner: false,
    );
  }
}
