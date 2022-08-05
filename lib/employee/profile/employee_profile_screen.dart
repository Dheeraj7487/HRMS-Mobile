import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

import '../../admin/employeeprofile/auth/add_employee_fire_auth.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_images.dart';
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
  var url = '';
  //final ref;

  @override
  Widget build(BuildContext context) {

    //final ref1 = FirebaseStorage.instance.ref().child("images/${FirebaseAuth.instance.currentUser!.email}.jpg");
    //url = (ref1.getDownloadURL()).toString();
    final formKey = GlobalKey<FormState>();

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
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                      Stack(
                        clipBehavior: Clip.none,
                        children : [
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
                          Positioned(
                            left: 70,
                            top: 60,
                            child: ClipOval(child: Container(
                              height: 40,width: 40,
                              color:AppColor.whiteColor,child: Icon(Icons.camera_alt,color: AppColor.appColor,),)),
                          )
                        ]
                      ),


                      Container(
                        margin: EdgeInsets.only(top:5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),

                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Name',
                              controller: employeeNameController..text = data['employeeName'],
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Name is Required';
                                }
                              },
                            ),
                            SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Email',
                              controller: emailController..text = data['email'],
                              readOnly: true,
                            ),
                            SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'DOB',
                              controller: dobController..text = data['dob'],
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Address',
                              controller: addressController..text = data['address'],
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Designation',
                              controller: designationController..text = data['designation'],
                              readOnly: true,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Department',
                              controller: departmentController..text = data['department'],
                              readOnly: true,
                            ),

                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Branch',
                              controller: branchNameController..text = data['branch'],
                              readOnly: true,
                            ),

                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Joining Date',
                              controller: dateOfJoinController..text = data['dateofjoining'],
                              readOnly: true,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Employment Type',
                              controller: employmentTypeController..text = data['employment_type'],
                              readOnly: true,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Exprience',
                              controller: exprienceGradeController..text = data['exprience'],
                              readOnly: true,
                            ),
                            const SizedBox(height: 10,),
                            TextFieldMixin().textFieldProfileWidget(
                              labelText: 'Manager',
                              controller: managerController..text = data['manager'],
                              readOnly: true,
                            ),

                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () async {
                                  if(url == ''){
                                    var querySnapshots = await FirebaseCollection().employeeCollection.get();
                                    for (var snapshot in querySnapshots.docChanges) {
                                      url = snapshot.doc.get("imageUrl");
                                    }
                                  }
                                  if(formKey.currentState!.validate() ) {
                                    // if(url != ''){
                                    uploadFile();
                                    Timer(const Duration(seconds: 5), () {
                                      AppUtils.instance.showToast(toastMessage: "Edit Profile");
                                      AddEmployeeFireAuth().addEmployee(email: emailController.text, employeeName: employeeNameController.text,
                                          mobile: mobileController.text, dob: dobController.text,
                                          address: addressController.text, designation: designationController.text, department: departmentController.text,
                                          branch: branchNameController.text, dateOfJoining: dateOfJoinController.text,
                                          imageUrl: url,
                                          employmentType: employmentTypeController.text, exprience: exprienceGradeController.text,
                                          manager: managerController.text, type: 'Employee');
                                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeeHomeScreen()));
                                      Get.offAll(const EmployeeHomeScreen());
                                    });
                                    // } else{
                                    //   print('Image Url is null = > $url');
                                  }

                              //  print('Image Url = > $url');
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
      ),
    );
  }
}
