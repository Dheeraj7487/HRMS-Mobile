import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/viewemployee/viewemployeeinoutdetails/view_employee_in_out_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';

class ViewEmployeeAttendance extends StatefulWidget {
  const ViewEmployeeAttendance({Key? key}) : super(key: key);

  @override
  State<ViewEmployeeAttendance> createState() => _ViewEmployeeAttendance();
}

class _ViewEmployeeAttendance extends State<ViewEmployeeAttendance> with SingleTickerProviderStateMixin{
  late TabController tabController;

  var registerEmployeeEmail =
  FirebaseFirestore.instance
      .collection("employee")
      .snapshots();

  var registerAdminEmail =
  FirebaseFirestore.instance
      .collection("admin")
      .snapshots();

  static const List<Tab> registeredTab = <Tab>[
    Tab(text: 'Employee'),
    Tab(text: 'Admin'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: registeredTab.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.appColor,
          title: const Text('View Registered Details'),
          centerTitle: true,
          bottom : const TabBar(
            tabs: registeredTab
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder(
                stream: registerEmployeeEmail,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none ){
                    return const Center(child: CircularProgressIndicator());
                  } else{
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context,index) {
                          return GestureDetector(
                            onTap: (){Get.to(ViewEmployeeinOutScreen(email: snapshot.data!.docs[index].id,));},
                            child: ListTile(
                              tileColor: index.isOdd ? AppColor.backgroundColor : Colors.white,
                              leading: Text('${index+1}'),
                              title: Text('${snapshot.data!.docs[index].id}'),
                            ),
                          );
                        }
                    );
                  }
                }
            ),
            StreamBuilder(
                stream: registerAdminEmail,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none ){
                    return const Center(child: CircularProgressIndicator());
                  } else{
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context,index) {
                          return ListTile(
                            tileColor: index.isOdd ? AppColor.backgroundColor : Colors.white,
                            leading: Text('${index+1}'),
                            title: Text('${snapshot.data!.docs[index].id}'),
                          );
                        }
                    );
                  }
                }
            ),
          ],
        )
      ),
    );
  }
}
