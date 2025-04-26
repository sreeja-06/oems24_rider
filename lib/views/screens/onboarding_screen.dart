import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    final currentPage = 0.obs;

    final pages = [
      _OnboardingPage(
        title: 'Welcome to OEMS24 Captain',
        description: 'Start earning by accepting ride requests from passengers in your area.',
        image: Icons.delivery_dining,
      ),
      _OnboardingPage(
        title: 'Accept Rides',
        description: 'When online, you\'ll receive ride requests. Accept them to start earning.',
        image: Icons.local_taxi,
      ),
      _OnboardingPage(
        title: 'Track Earnings',
        description: 'View your daily, weekly, and monthly earnings in the dashboard.',
        image: Icons.account_balance_wallet,
      ),
      _OnboardingPage(
        title: 'Ready to Start?',
        description: 'Login or register to begin your journey with OEMS24.',
        image: Icons.rocket_launch,
        isLast: true,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) => currentPage.value = index,
                itemBuilder: (context, index) => pages[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => TextButton(
                    onPressed: currentPage.value < pages.length - 1
                        ? () => pageController.animateToPage(
                            pages.length - 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          )
                        : null,
                    child: const Text('Skip'),
                  )),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      pages.length,
                      (index) => Obx(() => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage.value == index
                              ? const Color(0xFF007BFF)
                              : Colors.grey.shade300,
                        ),
                      )),
                    ),
                  ),
                  Obx(() => TextButton(
                    onPressed: () {
                      if (currentPage.value < pages.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Get.offNamed('/login');
                      }
                    },
                    child: Text(
                      currentPage.value < pages.length - 1 ? 'Next' : 'Get Started',
                      style: const TextStyle(color: Color(0xFF007BFF)),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData image;
  final bool isLast;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            image,
            size: 120,
            color: const Color(0xFF007BFF),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF007BFF),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          if (isLast) ...[
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Get.offNamed('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}