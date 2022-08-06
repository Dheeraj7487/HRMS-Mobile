import 'dart:async';
import 'package:employee_attendance_app/login/screen/onboarding_screen.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_images.dart';
import 'package:employee_attendance_app/widget/employee_bottom_navigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/app_preference_key.dart';
import '../utils/app_utils.dart';
import '../widget/admin_bottom_navigationbar.dart';
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
              MaterialPageRoute(builder: (context) => AdminBottomNavBarScreen()));
        }else{
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomNavBarScreen()));
        }
      }else{
         Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const OnBoardingScreen()));
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