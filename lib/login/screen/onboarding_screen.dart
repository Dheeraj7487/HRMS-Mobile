import 'package:employee_attendance_app/login/controller/onboarding_controller.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_screen.dart';

class OnBoardingScreen extends StatefulWidget{
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>{

  final _controller = OnboardingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
                controller: _controller.pageController,
                onPageChanged: _controller.selectedPageIndex,
                itemCount: _controller.onboardingPages.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                            _controller.onboardingPages[index].imageAsset,height: 300),
                        const SizedBox(height: 20),
                        Text(
                          _controller.onboardingPages[index].title,textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal:50.0),
                          child: Text(
                            _controller.onboardingPages[index].description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                  onTap: (){
                    Get.off(LoginScreen());
                  },
                  child: Container(
                    color: Colors.transparent,
                      height:40,width:70,child: Center(child: Text('Skip',textAlign: TextAlign.center,))),
                ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Row(
                children: List.generate(
                  _controller.onboardingPages.length,
                      (index) => Obx(() {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      width: 15,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _controller.selectedPageIndex.value == index
                            ? AppColor.appBlackColor
                            : AppColor.greyColor,
                        shape: BoxShape.rectangle,
                      ),
                    );
                  }),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Obx(() {
                return GestureDetector(
                  onTap: _controller.forwardAction,
                  child: Container(
                      color: Colors.transparent,
                      height:40,width:100,child: Center(child: Text(_controller.isLastPage ? 'Get Started' : 'Next -->',textAlign: TextAlign.center))),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
