import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/addemployee/auth/add_employee_fire_auth.dart';
import 'package:employee_attendance_app/admin/home/screen/admin_home_screen.dart';
import 'package:employee_attendance_app/mixin/textfield_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../mixin/button_mixin.dart';
import '../../utils/app_utils.dart';

class AddEmployeeScreen extends StatelessWidget with TextFieldMixin {
  AddEmployeeScreen({Key? key}) : super(key: key);

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
        title: const Text('Employee Information'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ClipOval(
                child: Image.network(
                    'https://miro.medium.com/max/1400/0*0fClPmIScV5pTLoE.jpg',
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: Column(
                  children: [
                    TextFieldMixin().textFieldWidget(
                        controller: employeeNameController,
                        prefixIcon:
                            const Icon(Icons.person, color: AppColor.appColor),
                        labelText: 'Employee Name'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: emailController,
                        prefixIcon: const Icon(Icons.email, color: AppColor.appColor),
                        labelText: 'Email'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: mobileController,
                        prefixIcon:
                            const Icon(Icons.phone_android, color: AppColor.appColor),
                        labelText: 'Mobile'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: dobController,
                        prefixIcon: const Icon(Icons.date_range_outlined,
                            color: AppColor.appColor),
                        labelText: 'Date of Birth'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: addressController,
                        prefixIcon:
                            const Icon(Icons.location_on, color: AppColor.appColor),
                        labelText: 'Address'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: designationController,
                        prefixIcon:
                            const Icon(Icons.post_add, color: AppColor.appColor),
                        labelText: 'Designation'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: departmentController,
                        prefixIcon:
                            const Icon(Icons.description, color: AppColor.appColor),
                        labelText: 'Department'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: branchNameController,
                        prefixIcon:
                        const Icon(Icons.person, color: AppColor.appColor),
                        labelText: 'Branch'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: dateOfJoinController,
                        prefixIcon:
                        const Icon(Icons.date_range_outlined, color: AppColor.appColor),
                        labelText: 'Date of Joining'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: employmentTypeController,
                        prefixIcon:
                        const Icon(Icons.person, color: AppColor.appColor),
                        labelText: 'Employment Type'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: exprienceGradeController,
                        prefixIcon:
                        const Icon(Icons.timeline_sharp, color: AppColor.appColor),
                        labelText: 'Exprience'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: managerController,
                        prefixIcon:
                        const Icon(Icons.man, color: AppColor.appColor),
                        labelText: 'Manager'),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldWidget(
                        controller: passwordController,
                        prefixIcon:
                        const Icon(Icons.lock, color: AppColor.appColor),
                        labelText: 'Password'),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () async {
                          User? user = await AddEmployeeFireAuth.registerEmployeeUsingEmailPassword(
                              employeeName: employeeNameController.text,
                              email: emailController.text,
                              password: passwordController.text);

                          if (user != null) {
                            AppUtils.instance.showToast(toastMessage: "Employee Added");
                            AddEmployeeFireAuth().addEmployee(email: emailController.text, employeeName: employeeNameController.text,
                                mobile: mobileController.text, dob: dobController.text,
                                address: addressController.text, designation: designationController.text, department: departmentController.text,
                                branch: branchNameController.text, dateOfJoining: dateOfJoinController.text,
                                employmentType: employmentTypeController.text, exprience: exprienceGradeController.text,
                                manager: managerController.text, type: 'Employee');
                            Get.offAll(AdminHomeScreen());
                          }
                        },
                        child: ButtonMixin()
                            .stylishButton(onPress: () {}, text: 'Add Employee'),
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
