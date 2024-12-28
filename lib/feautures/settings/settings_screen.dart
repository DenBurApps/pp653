import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:habit_app/core/domain/resources/app_text_styles.dart';
import 'package:habit_app/core/domain/resources/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBackgroundOnPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.blackBackgroundOnPrimary,
        title: const Text(
          "Settings",
          style: AppTextStyles.appBarTitle,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset("assets/Arrow_left.svg"),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 192,
              width: 358,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Vote for our app",
                          style: TextStyle(
                              fontFamily: "SF Pro Display",
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.w500),
                        ),
                        const Text(
                          "Every vote counts and will\nmake our app better",
                          style: AppTextStyles.onboardingButtonText,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: 134,
                            height: 44,
                            child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.black)),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/Star.svg",
                                    theme: const SvgTheme(
                                        currentColor: Colors.white),
                                  ),
                                  const Text(
                                    "Rate app",
                                    style: TextStyle(
                                        fontFamily: "SF Pro Display",
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                      ),
                      child: Image.asset(
                        "assets/circle.png",
                        width: 149,
                        height: 138,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.blackSurface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColors.blackBackgroundOnPrimary,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "assets/Notepad.svg",
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        "Terms of use",
                        style: AppTextStyles.settingsTile,
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset("assets/Arrow_right.svg"))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.blackSurface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColors.blackBackgroundOnPrimary,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "assets/LockKeyOpen.svg",
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        "Privacy Policy",
                        style: AppTextStyles.settingsTile,
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset("assets/Arrow_right.svg"))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.blackSurface,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColors.blackBackgroundOnPrimary,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "assets/Headset.svg",
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        "Privacy Policy",
                        style: AppTextStyles.settingsTile,
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset("assets/Arrow_right.svg"))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
