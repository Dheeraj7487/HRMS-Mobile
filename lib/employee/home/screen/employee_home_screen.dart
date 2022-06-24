import 'package:employee_attendance_app/employee/home/widget/dashboard_details_widget.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:employee_attendance_app/widget/admin_drawer_widget.dart';
import 'package:employee_attendance_app/widget/employee_drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../inOut/screen/employee_in_out_screen.dart';

class EmployeeHomeScreen extends StatelessWidget {

  EmployeeHomeScreen({Key? key}) : super(key: key);

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime(now.year, now.month, now.day);
    TimeOfDay timeDayGreetings = TimeOfDay.now();

    /*greetings(String greeting){
      if(timeDayGreetings <= '11: 59'){
        return 'Morning';
      } else if (timeDayGreetings > '11:59' && <= '16:59'){
        return 'Afternoon';
      } else if (timeDayGreetings > '16:59' && <= '23:59'){
        return 'Afternoon';
      } else {
        return 'Morning';
      }*/

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: AppColor.appColor,
              elevation: 0,
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
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: AppColor.appColor,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(50),bottomLeft: Radius.circular(50))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                        child: Image.network('https://miro.medium.com/max/1400/0*0fClPmIScV5pTLoE.jpg',height: 100,width: 100,fit: BoxFit.fill)),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning'),
                        SizedBox(height: 10),
                        Text('${FirebaseAuth.instance.currentUser!.displayName}',style: TextStyle(fontSize: 24,color: AppColor.whiteColor),),
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
                    DashboardDetailsWidget('https://cdn5.vectorstock.com/i/thumb-large/21/29/beach-holiday-travel-logo-vector-19952129.jpg',
                        'Public Holiday','Check allocated public holiday'),

                    GestureDetector(
                      onTap: () {
                        Get.to(EmployeeInOutScreen());
                      },
                      child: DashboardDetailsWidget('https://previews.123rf.com/images/mariusz_prusaczyk/mariusz_prusaczyk1303/mariusz_prusaczyk130300217/18341105-3d-entry-exit-button-click-here-block-text-over-white-background.jpg',
                          'Entry Exit','Fill the attendance today is present or not'),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: DashboardDetailsWidget('https://media.istockphoto.com/vectors/logo-sports-stopwatch-vector-id489669050?k=20&m=489669050&s=612x612&w=0&h=1l57ehZJkK9ODqmNcYX8cJpMAQZft6OlkULZPtBa8kI=',
                          'Time Slot','Check your entry exit time details'),
                    ),

                    DashboardDetailsWidget('https://www.exacteducation.com/wp-content/uploads/2019/06/Attendance.jpg',
                        'View Attendance','Check allocated public holiday'),

                    DashboardDetailsWidget('https://png.pngtree.com/png-vector/20190118/ourmid/pngtree-report-writing-line-filled-icon-png-image_324872.jpg',
                        'Reports','Check your month wise attendance reports'),
                    const SizedBox(height: 20)
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


