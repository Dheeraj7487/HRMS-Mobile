import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/employeeprofile/employee_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';

class EmployeeDetailsScreen extends StatelessWidget {
   EmployeeDetailsScreen({Key? key}) : super(key: key);

  var registerEmployeeEmail = FirebaseFirestore.instance.collection("employee").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('View Details',style: TextStyle(fontFamily: AppFonts.Medium)),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: registerEmployeeEmail,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong",style: TextStyle(fontFamily: AppFonts.Medium)));
            }
            else if (!snapshot.hasData) {
              return  const Center(
                  child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.Medium),));
            } else if (snapshot.requireData.docChanges.isEmpty){
              return  const Center(
                  child: Text("No Data Found",style: TextStyle(fontFamily: AppFonts.Medium),));
            } else if (snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context,index) {
                    return GestureDetector(
                      onTap: (){Get.to(ViewAdminEmployeeProfileScreen(email: snapshot.data!.docs[index].id));},
                      child: ListTile(
                        tileColor: index.isOdd ? Colors.blueGrey.shade50 : Colors.white,
                        title: Text(snapshot.data!.docs[index].id,style: const TextStyle(fontFamily: AppFonts.Medium)),
                        leading: Text('${index+1}',style: const TextStyle(fontFamily: AppFonts.Medium)),
                        trailing: const Icon(Icons.arrow_forward_ios,size: 12),
                        // trailing: Icons,
                      ),
                    );
                  }
              );
            }
            else{
              return const Center(child: Text('No Data Found',style: TextStyle(fontFamily: AppFonts.Medium)));
            }
          }
      ),
    );
  }
}
