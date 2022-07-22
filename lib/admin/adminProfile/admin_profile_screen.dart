import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/home/screen/admin_home_screen.dart';
import 'package:employee_attendance_app/employee/home/screen/employee_home_screen.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../admin/employeeprofile/auth/add_employee_fire_auth.dart';
import '../../login/provider/login_provider.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_utils.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreen();
}

class _AdminProfileScreen extends State<AdminProfileScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: StreamBuilder(
            stream: FirebaseCollection().adminCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                print('Something went wrong');
                return const Text("Something went wrong");
              }
              else if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: CircularProgressIndicator());
              } else if(snapshot.requireData.exists){
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.only(top:5),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          CupertinoFormSection(
                              header: const Text("Personal Details"),
                              children: [
                                CupertinoFormRow(
                                  prefix: const Icon(Icons.person, color: AppColor.appColor),
                                  child: CupertinoTextFormFieldRow(
                                    placeholder: "Enter name",
                                    controller: companyNameController..text = data['companyName'],
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'Name is Required';
                                      }
                                    },
                                  ),
                                ),

                                CupertinoFormRow(
                                  prefix: const Icon(Icons.email, color: AppColor.appColor),
                                  child: CupertinoTextFormFieldRow(
                                    placeholder: "Enter Email",
                                    controller: emailController..text = data['email'],
                                    readOnly: true,
                                  ),
                                ),

                                CupertinoFormRow(
                                  prefix: const Icon(Icons.phone_android, color: AppColor.appColor),
                                  child: CupertinoTextFormFieldRow(
                                    placeholder: "Enter Mobile",
                                    controller: mobileController..text = data['mobile'],
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ]),

                          const SizedBox(height: 50),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () async {
                                if(formKey.currentState!.validate() ) {
                                    AppUtils.instance.showToast(toastMessage: "Edit Profile");
                                    Provider.of<LoginProvider>(context,listen: false).signUpAdmin(email: emailController.text.trim(),
                                        companyName: companyNameController.text.trim(),
                                        mobile: mobileController.text.trim(),type: 'Admin');
                                    Get.offAll(AdminHomeScreen());
                                }
                              },
                              child: ButtonMixin()
                                  .stylishButton(onPress: () {}, text: 'Edit Profile'),
                            ),
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ],
                );
              }
              else if (snapshot.connectionState == ConnectionState.done) {
                return const Center(child: CircularProgressIndicator(),);
              }
              else{
                return const Center(child: CircularProgressIndicator(),);
              }
            },
          ),
        ),
      ),
    );
  }
}
