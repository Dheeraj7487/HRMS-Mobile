import 'dart:async';
import 'package:employee_attendance_app/admin/home/screen/admin_home_screen.dart';
import 'package:employee_attendance_app/login/provider/login_provider.dart';
import 'package:employee_attendance_app/login/screen/onboarding_screen.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../employee/home/screen/employee_home_screen.dart';
import '../utils/app_preference_key.dart';
import '../utils/app_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  bool isUserLogin=false;
  String? email;

  getPreferenceData()async{
    isUserLogin= await AppUtils.instance.getPreferenceValueViaKey(PreferenceKey.prefLogin)??false;
    email=await AppUtils.instance.getPreferenceValueViaKey(PreferenceKey.prefEmail)?? "";
    setState(() {});
    Timer(
        const Duration(seconds: 3), (){
      if(isUserLogin){
       // Provider.of<LoginProvider>(context,listen: false).getSharedPreferenceData(email);
        if(FirebaseAuth.instance.currentUser?.displayName == 'Admin'){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AdminHomeScreen()));
        }else{
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => EmployeeHomeScreen()));
        }
      }else{
         Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OnBoardingScreen()));
      }
      });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPreferenceData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColor.appColor,
      body: Center(
        child:Image.asset(AppImage.appLogo,height: 200,width: 200,fit: BoxFit.fill),
      ),
    );
  }
}