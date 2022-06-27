import 'package:employee_attendance_app/employee/attendance/view_attendance_screen.dart';
import 'package:employee_attendance_app/employee/holiday/holiday_screen.dart';
import 'package:employee_attendance_app/employee/reports/employee_reports_screen.dart';
import 'package:employee_attendance_app/login/screen/admin_employee_choose_login.dart';
import 'package:employee_attendance_app/login/screen/login_screen.dart';
import 'package:employee_attendance_app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../employee/profile/employee_profile_screen.dart';
import '../utils/app_colors.dart';

class EmployeeDrawerScreen extends StatelessWidget {
  const EmployeeDrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColor.appColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                    child: Image.network('https://miro.medium.com/max/1400/0*0fClPmIScV5pTLoE.jpg',height: 70,width: 70,fit: BoxFit.fill)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const SizedBox(height: 5),
                    Text('${FirebaseAuth.instance.currentUser!.displayName}',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
                    Text('${FirebaseAuth.instance.currentUser?.email}',style: const TextStyle(color: AppColor.blackColor,fontWeight: FontWeight.normal),),
                  ],
                ),

              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Get.to(EmployeeProfileScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.leave_bags_at_home),
            title: const Text('Holiday'),
            onTap: () {
              Get.to(const HolidayScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.mark_chat_read_outlined),
            title: const Text('Attendance'),
            onTap: () {
              Get.to(const AttendanceScreen());
            },
          ),

          const Divider(height: 1,color: AppColor.darkGreyColor,),

          ListTile(
            leading: const Icon(Icons.report_gmailerrorred_sharp),
            title: const Text('Reports'),
            onTap: () {
              Get.to(const ReportScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              AppUtils.instance.clearPref().then((value) => Get.offAll(LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
