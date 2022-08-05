import 'package:employee_attendance_app/admin/addemployee/add_employee.dart';
import 'package:employee_attendance_app/admin/addholiday/screen/add_holiday_screen.dart';
import 'package:employee_attendance_app/admin/employeeprofile/employee_details_screen.dart';
import 'package:employee_attendance_app/employee/home/widget/dashboard_details_widget.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:employee_attendance_app/utils/app_images.dart';
import 'package:employee_attendance_app/widget/admin_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../employee/publicholiday/screen/public_holiday_screen.dart';
import '../../leavestatus/leave_status_screen.dart';
import '../../viewemployee/view_registered_employee_screen.dart';

class AdminHomeScreen extends StatelessWidget {

  AdminHomeScreen({Key? key}) : super(key: key);

  DateTime now = DateTime.now();
  var hour = DateTime.now().hour;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime(now.year, now.month, now.day);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.appColor,AppColor.whiteColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer:const AdminDrawerScreen(),
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  iconTheme: const IconThemeData(color: AppColor.whiteColor),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  pinned: false,
                  toolbarHeight: 100,
                  forceElevated: innerBoxIsScrolled,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.only(left: 20.0,top: 10),
                    child: Row(
                      children: [
                        ClipOval(
                            child: Image.network('https://upwork-usw2-prod-assets-static.s3.us-west-2.amazonaws.com/org-logo/908288198480056320',
                                height: 50,width: 50,fit: BoxFit.fill)
                        ),
                        const SizedBox(width: 15,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hii, Elsner Technology',style: TextStyle(fontFamily: AppFonts.Medium,color: AppColor.backgroundColor),),
                            const SizedBox(height: 3),
                            Text(hour < 12 ? 'Good Morning' :
                            hour < 17 ? 'Good Afternoon' : 'Good Evening',style: const TextStyle(fontFamily: AppFonts.Bold,fontSize: 24,color: AppColor.whiteColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              decoration: const BoxDecoration(
                color: AppColor.whiteColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(60),topLeft: Radius.circular(60))
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Row(
                      children: [
                        ClipOval(
                            child: Image.network('https://upwork-usw2-prod-assets-static.s3.us-west-2.amazonaws.com/org-logo/908288198480056320',
                                height: 50,width: 50,fit: BoxFit.fill)
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(hour < 12 ? 'Good Morning' :
                            hour < 17 ? 'Good Afternoon' : 'Good Evening',style: const TextStyle(fontFamily: AppFonts.Medium)),
                            const SizedBox(height: 5),
                            const Text('Elsner Technology',style: TextStyle(fontSize: 24,fontFamily: AppFonts.Medium),),
                          ],
                        ),
                      ],
                    ),*/
                    /*Stack(
                      clipBehavior: Clip.none,
                      fit : StackFit.passthrough,
                      children: [
                        // const SizedBox(height: 260,),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: AppColor.appColor,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),bottomLeft: Radius.circular(50))
                          ),
                        ),
                        Positioned(
                          left: 0,right: 0,top: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                  child: Image.network('https://upwork-usw2-prod-assets-static.s3.us-west-2.amazonaws.com/org-logo/908288198480056320',
                                      height: 70,width: 70,fit: BoxFit.fill)

                                *//* Shimmer.fromColors(
                                      baseColor: Colors.white60,
                                      highlightColor: Colors.white24,
                                      child:
                                      Image.network('https://upwork-usw2-prod-assets-static.s3.us-west-2.amazonaws.com/org-logo/908288198480056320',height: 80,width: 80,fit: BoxFit.fill)
                                    ),*//*
                              ),
                              const SizedBox(width: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(hour < 12 ? 'Good Morning' :
                                  hour < 17 ? 'Good Afternoon' : 'Good Evening',style: const TextStyle(fontFamily: AppFonts.Medium)),
                                  const SizedBox(height: 5),
                                  const Text('Elsner Technology',style: TextStyle(fontSize: 24,fontFamily: AppFonts.Medium),),
                                ],
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Positioned(
                          top: 115,
                          child: Container(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(date.toString().replaceAll("00:00:00.000", ""),style: const TextStyle(fontSize: 20,color: AppColor.whiteColor,fontFamily: AppFonts.Medium))),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 140,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(const AddHolidayScreen());
                              },
                              child: DashboardDetailsWidget(AppImage.event,
                                  'Add Holiday','Add public holiday only'),
                            ),
                          ),
                        ),
                      ],
                    ),*/
                    const SizedBox(height: 40),
                    Container(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(date.toString().replaceAll("00:00:00.000", ""),style: const TextStyle(fontSize: 20,color: AppColor.greyColorLight,fontFamily: AppFonts.Medium))),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          GestureDetector(
                            onTap: () {
                              Get.to(const AddHolidayScreen());
                            },
                            child: DashboardDetailsWidget(AppImage.event,
                                'Add Holiday','Add public holiday only',AppColor.newOrangeColor),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(const AddEmployee());
                            },
                            child: DashboardDetailsWidget(AppImage.addEmployee,
                                'Add\nEmployee','Add employee details',AppColor.appColor),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          GestureDetector(
                            onTap: () {
                              Get.to(EmployeeDetailsScreen());
                            },
                            child: DashboardDetailsWidget(AppImage.employee,
                                'Employee\nDetails','List of registered employee details',
                                AppColor.redColor),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(const ViewEmployeeAttendance());
                            },
                            child: DashboardDetailsWidget(AppImage.attendance,
                                'View\nAttendance','List of registered employee attendance',AppColor.backgroundColor),
                          ),

                         /* GestureDetector(
                            onTap: (){
                              Get.to(const LeaveStatusScreen());
                            },
                            child: DashboardDetailsWidget(AppImage.leaveStatus,
                                'Leave\nStatus','Applied leave for approved or reject',
                                Colors.green),
                          ),*/

                          /* DashboardDetailsWidget('https://images-platform.99static.com//ITYtWRJgMT53_-hlTb3l2faUrPU=/0x1500:1500x3000/fit-in/500x500/99designs-contests-attachments/127/127315/attachment_127315153',
                              'Today Present Employee','Check date wise all registered employee presence of entry/exit'),

                          DashboardDetailsWidget('https://thumbs.dreamstime.com/b/earn-money-vector-logo-icon-design-salary-symbol-hand-illustration-illustrations-152826410.jpg',
                              'Calculate Salary','Check your month wise attendance and calculate'),
                          const SizedBox(height: 20)*/
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          GestureDetector(
                            onTap: () {
                              Get.to(const LeaveStatusScreen());
                            },
                            child: DashboardDetailsWidget(AppImage.leaveStatus,
                                'Leave\nStatus','',Colors.brown),
                          ),
                          GestureDetector(
                            onTap: (){
                              Get.to(PublicHolidayScreen());
                            },
                            child: DashboardDetailsWidget(AppImage.reports, 'View\nHoliday','View holiday',Colors.cyanAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
}

