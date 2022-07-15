import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';

class ButtonMixin {
  Widget stylishButton(
  {
  VoidCallback? onPress,
    String? text,
    double? fontSize,
    FontWeight?fontWeight,
    double? width,
    double? height,
    Color? bgColor,
    Color? textColor,
    BoxDecoration? boxDecoration,
  }){

    var boxDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [AppColor.appColor,AppColor.greyColorLight]
        )
    );

    return Container(
      padding: EdgeInsets.only(left: 30,right: 30,top: 15,bottom: 15),
      decoration:boxDecoration,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10),
        child:Text(text!,style: const TextStyle(letterSpacing:0.5,color: Colors.black,fontFamily: AppFonts.CormorantGaramondBold)),
      ),
    );
  }
}