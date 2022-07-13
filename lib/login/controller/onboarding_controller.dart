import 'package:employee_attendance_app/login/model/onboarding_model.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';

import '../../utils/app_images.dart';
import '../screen/login_screen.dart';

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == onboardingPages.length - 1;
  var pageController = PageController();

  forwardAction() {
    if (isLastPage) {
      Get.off(LoginScreen());
    } else {
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.easeInOut);
    }
  }

  List<OnboardingInfo> onboardingPages = [
    OnboardingInfo(AppImage.introduction1, 'Employee Attendance',
        'A employee can view the attendance',AppColor.appColor),
    OnboardingInfo(AppImage.introduction2, 'Employee Attendance',
        'A employee can view the attendance',AppColor.darkGreyColor),
    OnboardingInfo(AppImage.introduction3, 'Employee Attendance',
        'A employee can view the attendance',AppColor.appColor),
  ];
}