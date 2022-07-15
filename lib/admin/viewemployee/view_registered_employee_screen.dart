import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/viewemployee/viewemployeeinoutdetails/view_employee_in_out_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

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
    Tab(text: 'Employee',),
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
          title: const Text('View Registered Details',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
          centerTitle: true,
          bottom : const TabBar(
            indicatorColor: AppColor.appColor,
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
                              tileColor: index.isOdd ? Colors.blueGrey.shade50 : Colors.white,
                              leading: Text('${index+1}',style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                              title: Text(snapshot.data!.docs[index].id,style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                              trailing: const Icon(Icons.arrow_forward_ios,size: 12,),
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
                  } 
                  else if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context,index) {
                          return ListTile(
                            tileColor: index.isOdd ? Colors.blueGrey.shade50 : Colors.white,
                            leading: Text('${index+1}',style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                            title: Text(snapshot.data!.docs[index].id,style: const TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)),
                          );
                        }
                    );
                  }
                  else{
                    return const Center(child: Text('No Data Found',style: TextStyle(fontFamily: AppFonts.CormorantGaramondSemiBold)));
                  }
                }
            ),
          ],
        )
      ),
    );
  }
}
