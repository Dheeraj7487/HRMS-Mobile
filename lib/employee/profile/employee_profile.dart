import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/profile/employee_profile_screen.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/screen/login_screen.dart';
import '../../utils/app_utils.dart';


class EmployeeProfile extends StatefulWidget {
  const EmployeeProfile({Key? key}) : super(key: key);

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState();
}

class _EmployeeProfileState extends State<EmployeeProfile> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseCollection().employeeCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                debugPrint('Something went wrong');
                return const Text("Something went wrong");
              }
              else if (!snapshot.hasData || !snapshot.data!.exists) {
                debugPrint('Document does not exist');
                return const Center(child: CircularProgressIndicator());
              } else if(snapshot.requireData.exists){
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height/3,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(60),bottomLeft: Radius.circular(60)),
                              color: AppColor.appColor,
                            ),
                          ),
                          Positioned(
                            top: 40,
                            left: 0,right: 0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  ClipOval(
                                      child:
                                      data['imageUrl'] == "" ? Container(
                                        color: AppColor.appColor,
                                        height: 80,width: 80,child: Center(
                                        child: Text('${data['employeeName']?.substring(0,1).toUpperCase()}',
                                            style: const TextStyle(color: AppColor.appBlackColor,fontSize: 30)),
                                      ),) :
                                      Image.network(
                                          '${data['imageUrl']}',
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.fill)
                                  ),

                                  Text(data['employeeName'],
                                      style: const TextStyle(fontSize: 24,color: AppColor.whiteColor)),
                                  Text(data['department'],
                                      style: const TextStyle(fontSize: 12,color: Colors.white)),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              right: 10,
                              top: 30,
                              child: GestureDetector(
                                onTap: (){
                                  Get.to(const EmployeeProfileScreen());
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: AppColor.whiteColor.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: const Icon(Icons.edit,color: AppColor.whiteColor,)),
                              )
                          )
                        ]
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: const Icon(Icons.person,color: AppColor.appColor,)),
                            const SizedBox(height: 5,),
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(data['employeeName'])),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: const Icon(Icons.email,color: AppColor.appColor,)),
                            const SizedBox(height: 5,),
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(data['email'])),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: const Icon(Icons.phone_iphone_rounded,color: AppColor.appColor,)),
                            const SizedBox(height: 5,),
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(data['mobile'])),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: const Icon(Icons.date_range_outlined,color: AppColor.appColor,)),
                            const SizedBox(height: 5,),
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(data['dob'])),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      margin: const EdgeInsets.only(left: 20,right: 20),
                      width: double.infinity,
                      child: Card(
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: const Icon(Icons.location_city,color: AppColor.appColor,)),
                            const SizedBox(height: 5,),
                            Container(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                margin: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(data['address'])),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    GestureDetector(
                        onTap: (){
                          FirebaseAuth.instance.signOut();
                          AppUtils.instance.clearPref().then((value) => Get.offAll(LoginScreen()));
                          },
                        child: ButtonMixin().stylishButton(
                          text: 'Logout'
                        )
                    )
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return const Center(child: CircularProgressIndicator(),);
              } else{
                return const Center(child: CircularProgressIndicator(),);
              }
          }
        ),
      ),
    );
  }
}
