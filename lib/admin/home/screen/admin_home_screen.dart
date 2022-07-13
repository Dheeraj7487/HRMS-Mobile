import 'package:employee_attendance_app/admin/addholiday/screen/add_holiday_screen.dart';
import 'package:employee_attendance_app/admin/employeeprofile/employee_details_screen.dart';
import 'package:employee_attendance_app/employee/home/widget/dashboard_details_widget.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_images.dart';
import 'package:employee_attendance_app/widget/admin_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../employee/profile/employee_profile_screen.dart';
import '../../leavestatus/leave_status_screen.dart';
import '../../viewemployee/view_registered_employee_screen.dart';

class AdminHomeScreen extends StatelessWidget {

  AdminHomeScreen({Key? key}) : super(key: key);

  DateTime now = DateTime.now();
  var hour = DateTime.now().hour;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime(now.year, now.month, now.day);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: AppColor.appColor,
                elevation: 0,
                toolbarHeight: 27,
                pinned: false,
                //floating: true,
                forceElevated: innerBoxIsScrolled,
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: AppColor.appColor,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),bottomLeft: Radius.circular(50))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                          child: Image.network('https://upwork-usw2-prod-assets-static.s3.us-west-2.amazonaws.com/org-logo/908288198480056320',height: 80,width: 80,fit: BoxFit.fill)),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hour < 12 ? 'Good Morning' :
                          hour < 17 ? 'Good Afternoon' : 'Good Evening'),
                          SizedBox(height: 10),
                          Text('Elsner Technology',style: TextStyle(fontSize: 24),),
                        ],
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(date.toString().replaceAll("00:00:00.000", ""),style: const TextStyle(fontSize: 18,color: AppColor.blackColor),)),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: Column(
                    children:[
                      GestureDetector(
                        onTap: () {
                          Get.to(AddHolidayScreen());
                        },
                        child: DashboardDetailsWidget(AppImage.event,
                            'Add Holiday','Add public holiday only'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(EmployeeDetailsScreen());
                        },
                        child: DashboardDetailsWidget(AppImage.employee,
                            'View Employee Details','List of registered employee details'),
                      ),

                      GestureDetector(
                        onTap: () {
                          Get.to(const ViewEmployeeAttendance());
                        },
                        child: DashboardDetailsWidget(AppImage.attendance,
                            'View Attendance','List of registered employee attendance'),
                      ),

                      GestureDetector(
                        onTap: (){
                          Get.to(const LeaveStatusScreen());
                        },
                        child: DashboardDetailsWidget(AppImage.leaveStatus,
                            'Applied Leave Status','Applied leave for approved or reject'),
                      ),

                     /* DashboardDetailsWidget('https://images-platform.99static.com//ITYtWRJgMT53_-hlTb3l2faUrPU=/0x1500:1500x3000/fit-in/500x500/99designs-contests-attachments/127/127315/attachment_127315153',
                          'Today Present Employee','Check date wise all registered employee presence of entry/exit'),

                      DashboardDetailsWidget('https://thumbs.dreamstime.com/b/earn-money-vector-logo-icon-design-salary-symbol-hand-illustration-illustrations-152826410.jpg',
                          'Calculate Salary','Check your month wise attendance and calculate'),
                      const SizedBox(height: 20)*/
                    ],
                  ),
                )
              ],
            ),
          ),
      ),
      drawer: const AdminDrawerScreen(),
    );

  }
}

