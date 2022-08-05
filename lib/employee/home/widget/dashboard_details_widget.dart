import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';

Widget DashboardDetailsWidget(
    String imageLocation, String title, String description,Color color) {
  return Card(
      //elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: AppColor.whiteColor,
      child: ClipPath(
        child: Container(
          padding: const EdgeInsets.only(left: 5),
          height: 150,
          decoration:  BoxDecoration(
            border: Border(
              left: BorderSide(color: color, width: 5),
            ),
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 60, top: 10),
                    child: Image.asset(imageLocation,
                        height: 80, width: 80, fit: BoxFit.contain),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 40, top: 5, bottom: 10),
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontFamily: AppFonts.Medium),
                        textAlign: TextAlign.start),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
}
