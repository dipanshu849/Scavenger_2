import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/features/authentication/screens/welcome/welcome_screen.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  /// variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  ///
  /// Update current index when page scrolling
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// jump to specific dot selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  /// Update Current index and jump to next page
  void nextPage() {
    if (currentPageIndex.value == 6) {
      Get.to(const WelcomeScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  /// Update Current index and jump to last page
  void skipPage() {
    currentPageIndex.value = 6;
    pageController.jumpToPage(6);
  }
}
