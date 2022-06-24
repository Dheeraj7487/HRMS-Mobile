import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_attendance_app/admin/home/screen/admin_home_screen.dart';
import 'package:employee_attendance_app/login/auth/fire_auth.dart';
import 'package:employee_attendance_app/login/screen/admin_login_screen.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../mixin/button_mixin.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_utils.dart';

class RegisterScreen extends StatefulWidget with ButtonMixin,TextFieldMixin {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();
  var companyNameController = TextEditingController();
  var mobileController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<dynamic> adminData = [];
  RegExp passwordValidation = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

  final CollectionReference _mainCollection =
      FirebaseFirestore.instance.collection('admin');

  Future<void> signUpAdmin(
      {required String email,
      required String companyName,
      required String mobile,
      required String type}) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(emailController.text);

    Map<String, dynamic> data = <String, dynamic>{
      "email": email.toString(),
      "companyName": companyName.toString(),
      "mobile": mobile.toString(),
      "employement_type": 'Admin',
    };
    print('employee data=> $data');

    FirebaseFirestore.instance.collection("admin").get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        print(result.data());
        adminData.add(result.data());
      }
    });
    await documentReferencer
        .set(data)
        .whenComplete(() => print("Register Admin"))
        .catchError((e) => print(e));
    emailController.clear();
    companyNameController.clear();
    mobileController.clear();
    passwordController.clear();
    companyNameController.clear();
  }
  @override
  void dispose() {
    companyNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text(
                        "Create Admin Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextFieldMixin().textFieldCardWidget(
                      controller: companyNameController,
                      prefixIcon: Icon(Icons.person, color: AppColor.appColor),
                      labelText: 'Company Name',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().isEmpty) {
                          return 'Please enter company name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldCardWidget(
                      controller: emailController,
                      prefixIcon: Icon(Icons.email, color: AppColor.appColor),
                      labelText: 'Email',
                      validator: (value) {
                        if (value!.isEmpty ||
                            value.trim().isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
                            r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldCardWidget(
                      controller: mobileController,
                      prefixIcon: Icon(Icons.phone, color: AppColor.appColor),
                      labelText: 'Mobile Number',
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
                    TextFieldMixin().textFieldCardWidget(
                      controller: passwordController,
                      prefixIcon: Icon(Icons.lock, color: AppColor.appColor),
                      labelText: 'Password',
                      onChanged: (val) {
                        final key = encrypt.Key.fromUtf8('my 32 length key................');
                        final iv = encrypt.IV.fromLength(16);
                        final encrypter = encrypt.Encrypter(encrypt.AES(key));

                        print("Password is encrypted::: ${encrypter.encrypt(val, iv: iv).base64}");
                        print("Password is decrypted::: ${encrypter.decrypt(encrypter.encrypt(val, iv: iv), iv: iv)}");
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.trim().isEmpty) {
                          return 'Enter a valid password';
                        } else if (!passwordValidation
                            .hasMatch(passwordController.text)) {
                          return 'Password must contain at least one number and both lower upper case letters and special characters.';
                        } else if (value.length < 8) {
                          return 'Password must be atLeast 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFieldMixin().textFieldCardWidget(
                      controller: confirmPasswordController,
                      prefixIcon: Icon(Icons.lock, color: AppColor.appColor),
                      labelText: 'Confirm Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter confirm password!';
                        }
                        if (value != passwordController.text) {
                          return "Password does Not Match";
                        } else if (passwordController.text.isNotEmpty &&
                            passwordController.text.length >= 8 &&
                            passwordController.text.length <= 16 &&
                            !passwordController.text.contains(' ') &&
                            RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                .hasMatch(
                                passwordController.text.toString())) {
                          return null;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () async{
                          if (_formKey.currentState!.validate()) {
                           // final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8('my 32 length key................')));
                            /*signUpAdmin(
                                    email: emailController.text,
                                    companyName: companyNameController.text,
                                    mobile: mobileController.text,
                                    password: encrypter.encrypt(passwordController.text,iv: encrypt.IV.fromLength(16)).base64).toString();*/
                            User? user = await FireAuth.registerUsingEmailPassword(
                              email: emailController.text,
                              password: passwordController.text,
                              userType: 'Admin', mobile: mobileController.text,
                            );
                            if (user != null) {
                              Get.off(AdminHomeScreen());
                              AppUtils.instance.showToast(toastMessage: "Register Successfully");
                              signUpAdmin(email: emailController.text, companyName: companyNameController.text,
                                  mobile: mobileController.text,type: 'Admin');
                            }
                          }
                        },
                        child: ButtonMixin()
                            .stylishButton(onPress: () {}, text: 'Sign Up'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 25),
              child: const Text(
                'Already have an Account ',
                style: TextStyle(
                    decorationThickness: 2,
                    decoration: TextDecoration.none,
                    color: AppColor.appBlackColor),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.off(AdminLoginScreen());
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 25),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 16,
                      decorationThickness: 1,
                      decoration: TextDecoration.underline,
                      color: AppColor.appColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
