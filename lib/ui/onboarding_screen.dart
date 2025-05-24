import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:plant_care/constants.dart';
import 'screens/signin_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final List<_PageModel> _pages = const [
    _PageModel(
      gradient: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
      imageAsset: 'assets/images/plant-one.png',
      title: 'Learn More About Plants',
      description:
      Constants.descriptionOne,
    ),
    _PageModel(
      gradient: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
      imageAsset: 'assets/images/plant-three.png',
      title: 'Plant a Tree, Green the Earth',
      description:
      Constants.descriptionThree,
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // 1️⃣ Paged content
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) => _OnboardingPage(page: _pages[i]),
          ),

          // 2️⃣ Skip button (top-right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignIn()),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Skip'),
            ),
          ),

          // 3️⃣ Smooth dots indicator
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 12,
                  activeDotColor: Constants.primaryColor,
                  dotColor: Colors.grey[300]!,
                ),
              ),
            ),
          ),

          // 4️⃣ Next / Get Started button with black outline & text
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: OutlinedButton(
              onPressed: _onNext,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(isLast ? 'Get Started' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageModel {
  final List<Color> gradient;
  final String imageAsset, title, description;
  const _PageModel({
    required this.gradient,
    required this.imageAsset,
    required this.title,
    required this.description,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _PageModel page;
  const _OnboardingPage({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: page.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),

            // Image card
            Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Image.asset(page.imageAsset, fit: BoxFit.contain),
              ),
            ),

            const Spacer(flex: 1),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                page.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                page.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
