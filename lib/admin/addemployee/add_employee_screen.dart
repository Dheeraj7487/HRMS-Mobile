import 'dart:io';

import 'package:employee_attendance_app/admin/addemployee/auth/add_employee_fire_auth.dart';
import 'package:employee_attendance_app/admin/home/screen/admin_home_screen.dart';
import 'package:employee_attendance_app/mixin/textfield_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:get/get.dart';
import '../../mixin/button_mixin.dart';
import '../../utils/app_utils.dart';
import '../../validation/validation.dart';

class AddEmployeeScreen extends StatefulWidget with TextFieldMixin {
  AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
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

  File? file;
  String url = '';


  /*uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;

      image = await _imagePicker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if (image != null){
        //Upload to Firebase
        var snapshot = await _firebaseStorage.ref()
            .child('images/imageName')
            .putFile(file).onComplete;
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }


  }*/

  void _selectProfileImage(BuildContext context) async{
    //Pick Image File
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result == null) return;
    final filePath = result.files.single.path;
    setState(()=> file = File(filePath!));

  }

  void uploadFile() async {
    _selectProfileImage(context);
    //Store Image in firebase database
    if (file == null) return;
    final fireauth = FirebaseAuth.instance.currentUser!.email;
    final destination = 'images/$fireauth';
    try {

      final ref =
      FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(file!);
     // var dowurl = await (await ref.putFile(file!).whenComplete(() => ref.getDownloadURL()));
        print("Image Upload");

    //  final ref1 =
    //  FirebaseStorage.instance.ref().child("images/${FirebaseAuth.instance.currentUser!.email}.jpg");
     url = (await ref.getDownloadURL()).toString();
     print(url);

    } catch (e) {
        print('error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ref1 = FirebaseStorage.instance.ref().child("images/${FirebaseAuth.instance.currentUser!.email}.jpg");
    url = (ref1.getDownloadURL()).toString();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Employee Information'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  uploadFile();
                },
                child: ClipOval(
                    child: file == null ? /*Image.network(
                        'https://miro.medium.com/max/1400/0*0fClPmIScV5pTLoE.jpg',
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill) :*/
                    Container(
                        height: 100,width: 100,color: AppColor.appColor,
                        child: const Icon(Icons.camera_alt,size: 50,color: AppColor.whiteColor,)) :
                  Image.file(
                  file!,
                  height: 100,width: 100,
                  fit: BoxFit.fill,),
                )
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFieldMixin().textFieldWidget(
                          controller: employeeNameController,
                          keyboardType: TextInputType.text,
                          prefixIcon: const Icon(Icons.person, color: AppColor.appColor),
                          labelText: 'Employee Name',
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().isEmpty) {
                              return 'Please enter employee name';
                            }
                            return null;
                          },
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email, color: AppColor.appColor),
                          labelText: 'Email',
                          validator: (value){
                              if (value!.isEmpty ||
                              value.trim().isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                              r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                              return 'Enter a valid email';
                              }
                              return null;
                          }
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone_android, color: AppColor.appColor),
                          labelText: 'Mobile',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: dobController,
                          keyboardType: TextInputType.datetime,
                          prefixIcon: const Icon(Icons.date_range_outlined,
                              color: AppColor.appColor),
                          labelText: 'Date of Birth',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter date of birth';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: addressController,
                          prefixIcon:
                              const Icon(Icons.location_on, color: AppColor.appColor),
                          labelText: 'Address',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: designationController,
                          keyboardType: TextInputType.text,
                          prefixIcon:
                              const Icon(Icons.post_add, color: AppColor.appColor),
                          labelText: 'Designation',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter designation';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: departmentController,
                          keyboardType: TextInputType.text,
                          prefixIcon:
                              const Icon(Icons.description, color: AppColor.appColor),
                          labelText: 'Department',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter department';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: branchNameController,
                          keyboardType: TextInputType.text,
                          prefixIcon:
                          const Icon(Icons.person, color: AppColor.appColor),
                          labelText: 'Branch',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter branch';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: dateOfJoinController,
                          keyboardType: TextInputType.datetime,
                          prefixIcon:
                          const Icon(Icons.date_range_outlined, color: AppColor.appColor),
                          labelText: 'Date of Joining',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter joining date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: employmentTypeController,
                          keyboardType: TextInputType.text,
                          prefixIcon:
                          const Icon(Icons.person, color: AppColor.appColor),
                          labelText: 'Employment Type',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter employment type';
                          }
                          return null;
                        }
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: exprienceGradeController,
                          keyboardType: TextInputType.number,
                          prefixIcon:
                          const Icon(Icons.timeline_sharp, color: AppColor.appColor),
                          labelText: 'Exprience',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter exprience year';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: managerController,
                          keyboardType: TextInputType.text,
                          prefixIcon:
                          const Icon(Icons.man, color: AppColor.appColor),
                          labelText: 'Manager',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Please enter manager name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFieldMixin().textFieldWidget(
                          controller: passwordController,
                          prefixIcon:
                          const Icon(Icons.lock, color: AppColor.appColor),
                          labelText: 'Password',
                        validator: (value){
                            if (value!.isEmpty || value.trim().isEmpty) {
                              return 'Enter a valid password';
                            } else if (value.length < 8) {
                              return 'Password must be atLeast 8 characters';
                            }
                            return null;
                         },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
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
                            imageUrl: url,
                            employmentType: employmentTypeController.text, exprience: exprienceGradeController.text,
                            manager: managerController.text, type: 'Employee');
                        Get.offAll(AdminHomeScreen());
                      }
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
    );
  }
}
