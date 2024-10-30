import 'package:flutter/material.dart';
import 'package:habit_app/feautures/navigation_screen/navigation.dart';
import 'package:hive/hive.dart';
import 'package:habit_app/core/domain/resources/app_text_styles.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Welcome to the\nHabit Diary!",
      "description":
          "Start tracking your habits and meet your goals for developing them.",
      "imagePath": "assets/BG1.png",
    },
    {
      "title": "Carve out time to develop the habit!",
      "description":
          "Set up an individual timer to develop and track each habit.",
      "imagePath": "assets/BG2.png",
    },
    {
      "title": "Track the progress of your habits!",
      "description":
          "Keep track of your development with a calendar and spreadsheets.",
      "imagePath": "assets/BG3.png",
    },
  ];

  void _onDone() async {
    var box = await Hive.openBox('app_settings');
    await box.put('isFirstLaunch', false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const BottomNavBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _onboardingData[_currentPage]["imagePath"]!,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingData.length,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _onboardingData[index]["title"]!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.onboardingTitle,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            _onboardingData[index]["description"]!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.onboardingDescription,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildBottomControls(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 4.0,
                width: _currentPage == index ? 24.0 : 16.0,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.white : Colors.white38,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              if (_currentPage == _onboardingData.length - 1) {
                _onDone();
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
            ),
            child: Container(
              width: 350,
              child: Center(
                child: Text(
                  _currentPage == _onboardingData.length - 1
                      ? "Get Started"
                      : "Next",
                  style: AppTextStyles.onboardingButtonText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
