import 'package:employee_attendance_app/employee/inOut/provider/employee_in_out_provider.dart';
import 'package:employee_attendance_app/employee/leave/provider/leave_provider.dart';
import 'package:employee_attendance_app/login/provider/loading_provider.dart';
import 'package:employee_attendance_app/login/provider/login_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'admin/addholiday/provider/add_holiday_provider.dart';
import 'loading_screen.dart';
import 'login/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
          ChangeNotifierProvider<EmployeeInOutProvider>(create: (_) => EmployeeInOutProvider()),
          ChangeNotifierProvider<AddHolidayProvider>(create: (_) => AddHolidayProvider()),
          ChangeNotifierProvider<LoadingProvider>(create: (_) => LoadingProvider()),
          ChangeNotifierProvider<LeaveProvider>(create: (_) => LeaveProvider()),
        ],
      child: GetMaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Loading(child: child);
        },
      )
    );


  }
}