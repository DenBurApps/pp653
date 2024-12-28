import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_app/core/service/flagsmith_service.dart';
import 'package:habit_app/feautures/navigation_screen/navigation.dart';
import 'package:habit_app/feautures/onboarding_screen/onboarding_screen.dart';
import 'package:habit_app/feautures/settings/privacy_view.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _remoteConfigService = GetIt.instance<FlagSmithService>();

  late bool usePrivacy;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    usePrivacy = _remoteConfigService.usePrivacy;
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate(context));
  }

  Future<void> _navigate(BuildContext context) async {
    if (usePrivacy) {
      var box = await Hive.openBox('app_settings');
      bool isFirstTime = box.get('isFirstLaunch', defaultValue: true);
      if (isFirstTime) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => OnboardingScreen()),
          );
        }
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const BottomNavBar()),
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PrivacyScreen()),
        );
      }
    }

    if (mounted) {
      FlutterNativeSplash.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}