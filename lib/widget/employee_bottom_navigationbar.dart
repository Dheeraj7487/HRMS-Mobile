import 'package:employee_attendance_app/employee/home/screen/employee_home_screen.dart';
import 'package:employee_attendance_app/employee/profile/employee_profile_screen.dart';
import 'package:flutter/material.dart';
import '../employee/profile/employee_profile.dart';
import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

class BottomNavBarScreen extends StatefulWidget {
  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {

  int _selectedIndex=0;
  String imageUrl="https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg";
  List<Widget> buildScreen(){
    return [
      const EmployeeHomeScreen(),
      const EmployeeProfile()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColor.appColor,
      body: buildScreen().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: AppColor.whiteColor,
        selectedLabelStyle: const TextStyle(color: AppColor.appColor),
        unselectedLabelStyle: const TextStyle(color: AppColor.appBlackColor,),
        selectedItemColor: AppColor.appColor,
        unselectedItemColor: AppColor.greyColor,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home,size: 30,
              )),
          BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.person,size: 30,
              )),
        ],
      ),
    );
  }
}
