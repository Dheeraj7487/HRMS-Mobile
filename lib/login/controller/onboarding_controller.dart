import 'package:employee_attendance_app/login/model/onboarding_model.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';

import '../screen/admin_employee_choose_login.dart';

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == onboardingPages.length - 1;
  var pageController = PageController();

  forwardAction() {
    if (isLastPage) {
      Get.off(const AdminEmployeeChooseLoginScreen());
    } else {
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.easeInOut);
    }
  }

  List<OnboardingInfo> onboardingPages = [
    OnboardingInfo('https://png.pngtree.com/png-vector/20201203/ourlarge/pngtree-penguin-with-christmas-hat-background-png-image_2508812.jpg', 'Employee Attendance',
        'A employee can view the attendance',AppColor.appColor),
    OnboardingInfo('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKpJAsryOXV1dZKZDRIsoxwI4jx0K90uDn-A&usqp=CAU', 'Employee Attendance',
        'A employee can view the attendance',AppColor.darkGreyColor),
    OnboardingInfo('https://png.pngitem.com/pimgs/s/118-1185893_photo-by-daniellemoraesfalcao-christmas-penguin-hd-png-download.png', 'Employee Attendance',
        'A employee can view the attendance',AppColor.appColor),
  ];
}