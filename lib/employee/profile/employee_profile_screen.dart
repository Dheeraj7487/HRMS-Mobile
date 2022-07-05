import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/employee/home/screen/employee_home_screen.dart';
import 'package:employee_attendance_app/firebase/firebase_collection.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';

import '../../admin/addemployee/auth/add_employee_fire_auth.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_utils.dart';

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

  File? file;
  String url = '';

  Future<File> imageSizeCompress(
      {required File image,
        quality = 50,
        percentage = 1}) async {
    var path = await FlutterNativeImage.compressImage(image.absolute.path,quality: 100,percentage: 10);
    return path;
  }

  void _selectProfileImage(BuildContext context) async{
    //Pick Image File
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image
    );
    if(result == null) return;
    final filePath = result.files.single.path;
    File compressImage = await imageSizeCompress(image: File(filePath!));
    setState(() {
      // file = File(filePath!);
      file = compressImage;
    });
  }

  void uploadFile() async {
    //_selectProfileImage(context);
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
      final url1 = (await ref.getDownloadURL()).toString();
      setState((){
        url = url1;
      });
      print(url);

    } catch (e) {
      print('error occurred');
    }
  }

  /*void uploadFile() async {
    _selectProfileImage(context);
    //Store Image in firebase database
    if (file == null) return;
    final fireauth = FirebaseAuth.instance.currentUser!.email;
    final destination = 'images/$fireauth';
    try {
      final ref = FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(file!);
      // var dowurl = await (await ref.putFile(file!).whenComplete(() => ref.getDownloadURL()));
      print("Image Upload");

      //  final ref1 =
      //  FirebaseStorage.instance.ref().child("images/${FirebaseAuth.instance.currentUser!.email}.jpg");
      final url1 = (await ref.getDownloadURL()).toString();
      setState((){
        url = url1;
      });
      print(url);
    } catch (e) {
      print('error occurred');
    }
  }*/

  @override
  Widget build(BuildContext context) {

    //final ref1 = FirebaseStorage.instance.ref().child("images/${FirebaseAuth.instance.currentUser!.email}.jpg");
    //url = (ref1.getDownloadURL()).toString();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                      GestureDetector(
                        onTap: (){
                          _selectProfileImage(context);
                        },
                        child: ClipOval(
                            child: file == null ?
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
                                fit: BoxFit.fill) :
                                Image.file(
                                  file!,
                                  height: 100,width: 100,
                                  fit: BoxFit.fill,),
                        ),
                      ),
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
                                  onTap: () async {

                                    if (formKey.currentState!.validate() ) {
                                      uploadFile();
                                      Timer(Duration(seconds: 5), () {
                                        AppUtils.instance.showToast(toastMessage: "Update Profile");
                                        AddEmployeeFireAuth().addEmployee(email: emailController.text, employeeName: employeeNameController.text,
                                            mobile: mobileController.text, dob: dobController.text,
                                            address: addressController.text, designation: designationController.text, department: departmentController.text,
                                            branch: branchNameController.text, dateOfJoining: dateOfJoinController.text,
                                            imageUrl: url,
                                            employmentType: employmentTypeController.text, exprience: exprienceGradeController.text,
                                            manager: managerController.text, type: 'Employee');
                                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeeHomeScreen()));
                                        Get.offAll(EmployeeHomeScreen());
                                      });
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
      ),
    );
  }
}
