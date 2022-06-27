import 'package:employee_attendance_app/login/screen/admin_register_screen.dart';
import 'package:employee_attendance_app/mixin/button_mixin.dart';
import 'package:employee_attendance_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:provider/provider.dart';
import '../../mixin/textfield_mixin.dart';
import '../../utils/app_preference_key.dart';
import '../../utils/app_utils.dart';
import '../auth/fire_auth.dart';
import '../provider/login_provider.dart';
import 'reset_password_screen.dart';


class LoginScreen extends StatefulWidget with ButtonMixin,TextFieldMixin{
   LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisibility = false;
  String? chooseType;
  bool chooseValue = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text("Employee"),
                          Radio(
                              value: "Employee",
                              groupValue: chooseType,
                              onChanged: (value){
                                setState(() {
                                  chooseType = value.toString();
                                  chooseValue = false;
                                });
                              }),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Admin"),
                          Radio(
                              value: "Admin",
                              groupValue: chooseType,
                              onChanged: (value){
                                setState(() {
                                  chooseType = value.toString();
                                  chooseValue = true;
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please sign in to continue',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFieldMixin().textFieldCardWidget(
                  controller: emailController,
                  prefixIcon: const Icon(Icons.email, color: AppColor.appColor),
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
                  controller: passwordController,
                  prefixIcon: const Icon(Icons.lock, color: AppColor.appColor),
                  labelText: 'Password',
                  obscureText: passwordVisibility ? false : true,
                  suffixIcon: IconButton(
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          passwordVisibility = !passwordVisibility;
                        });
                      },
                      icon: passwordVisibility
                          ? const Icon(
                        Icons.visibility,
                        color: AppColor.appColor,
                      )
                          : const Icon(Icons.visibility_off,
                          color: AppColor.appColor)),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: (){
                    Get.to(ResetPasswordScreen());
                  },
                    child: Text('Reset Password')),
                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () async {
                      User? user = await FireAuth.signInUsingEmailPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(), context: context,
                      );
                      if (user != null) {
                        AppUtils.instance.setPref(PreferenceKey.boolKey, PreferenceKey.prefLogin, true);
                        AppUtils.instance.setPref(PreferenceKey.stringKey, PreferenceKey.prefEmail, emailController.text);
                        Provider.of<LoginProvider>(context,listen: false).getSharedPreferenceData(emailController.text);
                        if (_formKey.currentState!.validate()) {
                          Provider.of<LoginProvider>(context,listen: false).getData(emailController.text);
                        }
                      }
                    },
                    child: ButtonMixin()
                        .stylishButton(onPress: () {}, text: 'Sign In'),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: chooseValue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 25),
                child: const Text(
                  'Don' "'" 't Have An Account Yet? ',
                  style: TextStyle(
                      decorationThickness: 2,
                      decoration: TextDecoration.none,
                      color:AppColor.appBlackColor),
                ),
              ),
              GestureDetector(
                onTap: (){Get.off(RegisterScreen());},
                child: Container(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 16,
                        decorationThickness: 1,
                        decoration: TextDecoration.underline,
                        color:AppColor.appColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



