import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/login/provider/login_provider.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  MaskedTextController dobController = MaskedTextController(mask: '00/00/0000');
  TextEditingController mobileController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  MaskedTextController dateOfJoinController = MaskedTextController(mask: '00/00/0000');
  TextEditingController employmentTypeController = TextEditingController();
  TextEditingController exprienceGradeController = TextEditingController();
  TextEditingController managerController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseCollection().employeeCollection.doc(FirebaseAuth.instance.currentUser?.email).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                print('Something went wrong');
                return const Text("Something went wrong");
              }
              else if (!snapshot.hasData || !snapshot.data!.exists) {
                print('Document does not exist');
                return const Center(child: CircularProgressIndicator());
              } else if(snapshot.requireData.exists){
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    ClipOval(
                        child: data['imageUrl'] == "Instance of 'Future<String>'" ? Container(
                          color: AppColor.appColor,
                          height: 80,width: 80,child: Center(
                          child: Text('${FirebaseAuth.instance.currentUser?.displayName?.substring(0,1).toUpperCase()}',
                            style: const TextStyle(color: AppColor.appBlackColor,fontSize: 30),),
                        ),) :
                        Image.network(
                            '${data['imageUrl']}',
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill)),
                    Container(
                      margin: EdgeInsets.only(top:5),
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            TextFieldMixin().textFieldWidget(
                                controller: employeeNameController..text = data['employeeName'],
                                prefixIcon: const Icon(Icons.person, color: AppColor.appColor),
                                labelText: 'Employee Name'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: emailController..text = data['email'],
                                readOnly: true,
                                prefixIcon: const Icon(Icons.email, color: AppColor.appColor),
                                labelText: 'Email'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: mobileController..text = data['mobile'],
                                keyboardType: TextInputType.phone,
                                prefixIcon:
                                const Icon(Icons.phone_android, color: AppColor.appColor),
                                labelText: 'Mobile'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: dobController..text = data['dob'],
                                prefixIcon: const Icon(Icons.date_range_outlined,
                                    color: AppColor.appColor),
                                keyboardType: TextInputType.number,
                                labelText: 'Date of Birth'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: addressController..text = data['address'],
                                keyboardType: TextInputType.text,
                                prefixIcon:
                                const Icon(Icons.location_on, color: AppColor.appColor),
                                labelText: 'Address'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: designationController..text = data['designation'],
                                prefixIcon:
                                const Icon(Icons.post_add, color: AppColor.appColor),
                                readOnly: true,
                                labelText: 'Designation'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: departmentController..text = data['department'],
                                prefixIcon:
                                const Icon(Icons.description, color: AppColor.appColor),
                                readOnly: true,
                                labelText: 'Department'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: branchNameController..text = data['branch'],
                                readOnly: true,
                                prefixIcon:
                                const Icon(Icons.person, color: AppColor.appColor),
                                labelText: 'Branch'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: dateOfJoinController..text = data['dateofjoining'],
                                readOnly: true,
                                prefixIcon:
                                const Icon(Icons.date_range_outlined, color: AppColor.appColor),
                                labelText: 'Date of Joining'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: employmentTypeController..text = data['employment_type'],
                                prefixIcon:
                                const Icon(Icons.person, color: AppColor.appColor),
                                readOnly : true,
                                labelText: 'Employment Type'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: exprienceGradeController..text = data['exprience'],
                                prefixIcon:
                                const Icon(Icons.timeline_sharp, color: AppColor.appColor),
                                readOnly : true,
                                labelText: 'Exprience'),
                            const SizedBox(height: 20),
                            TextFieldMixin().textFieldWidget(
                                controller: managerController..text = data['manager'],
                                readOnly : true,
                                prefixIcon:
                                const Icon(Icons.man, color: AppColor.appColor),
                                labelText: 'Manager'),
                            const SizedBox(height: 20),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () async {},
                                child: ButtonMixin()
                                    .stylishButton(onPress: () {}, text: 'Edit Profile'),
                              ),
                            ),
                            const SizedBox(height: 20)
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              else if (snapshot.connectionState == ConnectionState.done) {
                return const Center(child: CircularProgressIndicator(),);
              }
              else{
                return Center(child: CircularProgressIndicator(),);
              }
            },
          ),
        ),
      ),
    );
  }
}
