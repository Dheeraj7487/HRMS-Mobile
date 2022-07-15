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
    OnboardingInfo(AppImage.entryExit, 'Entry Exit',
        'A employee can add daily In Out and view the attendance details',AppColor.appColor),
    OnboardingInfo(AppImage.event, 'Holiday',
        'A employee can view public holiday',AppColor.darkGreyColor),
    OnboardingInfo(AppImage.leaveStatus, 'Employee Attendance',
        'A employee can apply for a leave and also check the leave status',AppColor.appColor),
  ];
}