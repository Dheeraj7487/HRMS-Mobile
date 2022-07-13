import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/home/widget/dashboard_details_widget.dart';
import 'package:employee_attendance_app/employee/leave/leaveStatusApplied.dart';
import 'package:employee_attendance_app/employee/timeslot/attendance_details_screen.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/utils/app_images.dart';
import 'package:employee_attendance_app/widget/employee_drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {

    DateTime date = DateTime(now.year, now.month, now.day);
    final getEmployeeData = FirebaseCollection().employeeCollection.doc(FirebaseAuth.instance.currentUser!.email).snapshots();

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
                child: StreamBuilder(
                  stream: getEmployeeData,
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return ClipOval(
                        child: Container(
                            height: 50,width: 50,color: AppColor.whiteColor,
                            child: const Icon(Icons.error,size: 50,color: AppColor.appColor,)),
                      );
                    }
                    else if(snapshot.requireData.exists){
                      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child:
                            data['imageUrl'] != "Instance of 'Future<String>''" ? Container(
                              color: AppColor.backgroundColor,
                              height: 80,width: 80,child: Center(
                              child: Text('${data['employeeName']?.substring(0,1).toUpperCase()}',
                                style: const TextStyle(color: AppColor.appBlackColor,fontSize: 30),),
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
                              hour < 17 ? 'Good Afternoon' : 'Good Evening'),
                              const SizedBox(height: 5),
                              Text('${data['employeeName']}',style: const TextStyle(fontSize: 24,color: AppColor.blackColor),),
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
              Container(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(date.toString().replaceAll("00:00:00.000", ""),style: const TextStyle(fontSize: 18,color: AppColor.blackColor),)),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Column(
                  children:[
                    GestureDetector(
                      onTap: () {
                        print(getEmployeeData);
                        Get.to(PublicHolidayScreen());
                      },
                      child: DashboardDetailsWidget(AppImage.introduction2,
                          'Public Holiday','Check allocated public holiday'),
                    ),

                    GestureDetector(
                      onTap: () {
                        Get.to(const EmployeeInOutScreen());
                      },
                      child: DashboardDetailsWidget(AppImage.entryExit,
                          'Entry Exit','Fill the attendance today is present or not'),
                    ),

                    GestureDetector(
                      onTap: () {
                        Get.to(TimeSlotScreen());
                      },
                      child: DashboardDetailsWidget(AppImage.timeSlot,
                          'Attendance Details','Check your entry exit time details'),
                    ),

                    GestureDetector(
                      onTap: (){
                        Get.to(LeaveScreen());
                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>LeaveScreen()));
                      },
                      child: DashboardDetailsWidget(AppImage.leave,
                          'Leave','Apply for a leave'),
                    ),

                    GestureDetector(
                      onTap: (){
                        Get.to(const LeaveStatusApplied());
                      },
                      child: DashboardDetailsWidget(AppImage.leaveStatus,
                          'Leave Status','Check leave status for applied or rejected'),
                    ),
                    const SizedBox(height: 20)
                   /* DashboardDetailsWidget('https://png.pngtree.com/png-vector/20190118/ourmid/pngtree-report-writing-line-filled-icon-png-image_324872.jpg',
                        'Reports','Check your month wise attendance reports'),
                    const SizedBox(height: 20)*/
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      drawer: const EmployeeDrawerScreen(),
    );
  }
}


