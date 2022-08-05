import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/home/widget/dashboard_details_widget.dart';
import 'package:employee_attendance_app/employee/leave/leaveStatusApplied.dart';
import 'package:employee_attendance_app/employee/reports/employee_reports_screen.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_fonts.dart';
import 'package:employee_attendance_app/utils/app_images.dart';
import 'package:employee_attendance_app/widget/employee_drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as widget;
import '../../attendance_details/attendance_details_screen.dart';
import '../../inOut/screen/employee_in_out_screen.dart';
import '../../leave/leave_screen.dart';
import '../../publicholiday/screen/public_holiday_screen.dart';

class EmployeeHomeScreen extends StatefulWidget {

  const EmployeeHomeScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {

  DateTime now = DateTime.now();
  var hour = DateTime.now().hour;
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime(now.year, now.month, now.day);
    final getEmployeeData = FirebaseCollection().employeeCollection.doc(FirebaseAuth.instance.currentUser!.email).snapshots();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.appColor,AppColor.whiteColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        // drawerEnableOpenDragGesture : false,
        backgroundColor: Colors.transparent,
        body: NestedScrollView(
          controller: controller,
          clipBehavior :Clip.antiAliasWithSaveLayer,
          dragStartBehavior : DragStartBehavior.down,
          physics: const NeverScrollableScrollPhysics(),
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
                      StreamBuilder(
                          stream: getEmployeeData,
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                            if (snapshot.hasError) {
                              return const Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.Medium));
                            } else if (snapshot.connectionState == ConnectionState.done) {
                              return const Center(child: CircularProgressIndicator(),);
                            }
                            else if (!snapshot.hasData || !snapshot.data!.exists) {
                              /*return ClipOval(
                                child: Container(
                                    height: 50,width: 50,color: AppColor.whiteColor,
                                    child: const Icon(Icons.error,size: 50,color: AppColor.appColor)),
                              );*/
                              return const Text('');
                            }
                            else if(snapshot.requireData.exists){
                              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipOval(
                                      child:
                                      data['imageUrl'] == "" ? Container(
                                        color: AppColor.backgroundColor,
                                        height: 80,width: 80,child: Center(
                                        child: Text('${data['employeeName']?.substring(0,1).toUpperCase()}',
                                          style: const TextStyle(color: AppColor.appBlackColor,fontSize: 30,fontFamily: AppFonts.Medium),),
                                      ),) :
                                      Image.network(
                                          '${data['imageUrl']}',
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.fill)
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       Text('Hi, ${data['employeeName']}',style: TextStyle(fontFamily: AppFonts.Medium,color: AppColor.backgroundColor),),
                                      const SizedBox(height: 3),
                                      Text(hour < 12 ? 'Good Morning' :
                                      hour < 17 ? 'Good Afternoon' : 'Good Evening',style: const TextStyle(fontFamily: AppFonts.Bold,fontSize: 24,color: AppColor.whiteColor)),
                                    ],
                                  ),
                                ],
                              );
                            }
                            else{
                              return const Center(child: CircularProgressIndicator(),);
                            }
                          }
                      ),
                      const SizedBox(width: 15,),
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
                 /* Stack(
                    fit: StackFit.loose,
                    clipBehavior: Clip.none,
                    children: [
                      const SizedBox(height: 260,),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: AppColor.appColor,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(50))
                        ),
                      ),

                      Positioned(
                        left: 0,right: 0,top: 20,
                        child: StreamBuilder(
                            stream: getEmployeeData,
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                              if (snapshot.hasError) {
                                return const Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.Medium));
                              } else if (snapshot.connectionState == ConnectionState.done) {
                                return const Center(child: CircularProgressIndicator(),);
                              }
                              else if (!snapshot.hasData || !snapshot.data!.exists) {
                                *//*return ClipOval(
                                  child: Container(
                                      height: 50,width: 50,color: AppColor.whiteColor,
                                      child: const Icon(Icons.error,size: 50,color: AppColor.appColor)),
                                );*//*
                                return const Text('');
                              }
                              else if(snapshot.requireData.exists){
                                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipOval(
                                        child:
                                        data['imageUrl'] == "" ? Container(
                                          color: AppColor.backgroundColor,
                                          height: 80,width: 80,child: Center(
                                          child: Text('${data['employeeName']?.substring(0,1).toUpperCase()}',
                                            style: const TextStyle(color: AppColor.appBlackColor,fontSize: 30,fontFamily: AppFonts.Medium),),
                                        ),) :
                                        Image.network(
                                            '${data['imageUrl']}',
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.fill)
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(hour < 12 ? 'Good Morning' :
                                        hour < 17 ? 'Good Afternoon' : 'Good Evening',style: const TextStyle(fontFamily: AppFonts.Medium),),
                                        const SizedBox(height: 5),
                                        Text('${data['employeeName']}',style: const TextStyle(fontSize: 24,color: AppColor.blackColor,fontFamily: AppFonts.Medium),),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              else{
                                return const Center(child: CircularProgressIndicator(),);
                              }
                            }
                        ),
                      ),

                      const SizedBox(height: 10),
                      Positioned(
                        top: 120,
                        child: Container(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(date.toString().replaceAll("00:00:00.000", ""),style: const TextStyle(fontSize: 20,color: AppColor.blackColor,fontFamily: AppFonts.Medium))),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 140,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(PublicHolidayScreen());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: DashboardDetailsWidget(AppImage.holidays,
                                'Public Holiday','Check allocated public holiday',Colors.green),
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
                            Get.to(PublicHolidayScreen());
                          },
                          child: DashboardDetailsWidget(AppImage.holidays,
                              'Public\nHoliday','Check allocated public holiday',AppColor.greyColorLight),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const EmployeeInOutScreen());
                          },
                          child: DashboardDetailsWidget(AppImage.entryExit,
                              'Entry\nExit','Fill the attendance today is present or not',AppColor.appColor),
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
                            Get.to(AttendanceDetailsScreen(passType: 'Employee', email: '',));
                          },
                          child: DashboardDetailsWidget(AppImage.timeSlot,
                              'Attendance\nDetails','Check your entry exit time details',AppColor.yellowColor),
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.to(LeaveScreen());
                          },
                          child: DashboardDetailsWidget(AppImage.leave, 'Apply\nLeave','Apply for a leave',Colors.green),
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
                            Get.to(const LeaveStatusApplied());
                          },
                          child: DashboardDetailsWidget(AppImage.leaveStatus,
                              'Leave\nStatus','Check your entry exit time details',Colors.brown),
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.to(const ReportScreen());
                          },
                          child: DashboardDetailsWidget(AppImage.reports, 'Reports','Reports',Colors.cyanAccent),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
        endDrawer: const EmployeeDrawerScreen(),
      ),
    );
  }
}


