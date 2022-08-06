import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../login/provider/login_provider.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_utils.dart';
import '../../widget/admin_bottom_navigationbar.dart';

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
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.only(top:5),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          TextFieldMixin().textFieldProfileWidget(
                            labelText: 'Name',
                            controller: companyNameController..text = data['companyName'],
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Name is Required';
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFieldMixin().textFieldProfileWidget(
                            labelText: 'Email',
                            controller: emailController..text = data['email'],
                            readOnly: true,
                          ),
                          const SizedBox(height: 10),
                          TextFieldMixin().textFieldProfileWidget(
                            labelText: 'Mobile',
                            controller: mobileController..text = data['mobile'],
                            keyboardType: TextInputType.phone,
                          ),

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
                                    Get.offAll(AdminBottomNavBarScreen());
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
