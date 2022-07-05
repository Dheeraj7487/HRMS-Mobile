import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/attendance/view_attendance_screen.dart';
import 'package:employee_attendance_app/employee/holiday/holiday_screen.dart';
import 'package:employee_attendance_app/employee/reports/employee_reports_screen.dart';
import 'package:employee_attendance_app/login/screen/admin_employee_choose_login.dart';
import 'package:employee_attendance_app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../firebase/firebase_collection.dart';
import '../login/screen/login_screen.dart';
import '../utils/app_colors.dart';

class AdminDrawerScreen extends StatelessWidget {
  const AdminDrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColor.appColor,
            ),
            child: StreamBuilder(
                stream: FirebaseCollection().adminCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {

                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  if(snapshot.connectionState == ConnectionState.none){
                    return const Text('Something went wrong');
                  } else if(snapshot.connectionState == ConnectionState.waiting){
                    return const Text('Something went wrong');
                  }
                  else if(snapshot.hasData){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                            child:
                            // Image.network('https://miro.medium.com/max/1400/0*0fClPmIScV5pTLoE.jpg',height: 70,width: 70,fit: BoxFit.fill)
                            Container(
                                color: AppColor.backgroundColor,
                                height: 70,width: 70,
                                child: Center(
                                  child: Text('${data['companyName']?.substring(0,1).toUpperCase()}',
                                    style: const TextStyle(color: AppColor.appBlackColor,fontSize: 30),),
                                ))
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            const SizedBox(height: 5),
                            Text('${data['companyName']}',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.normal)),
                            Text('${FirebaseAuth.instance.currentUser?.email}',style: const TextStyle(color: AppColor.blackColor,fontWeight: FontWeight.normal),),
                          ],
                        ),
                      ],
                    );
                  }
                  else{
                    return const Text('Data is loaded');
                  }
              }
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
            onTap: () {},
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
