import 'package:employee_attendance_app/login/provider/login_provider.dart';
import 'package:employee_attendance_app/mixin/textfield_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../mixin/button_mixin.dart';
import '../../utils/app_colors.dart';

class ResetPasswordScreen extends StatelessWidget {
   ResetPasswordScreen({Key? key}) : super(key: key);

   TextEditingController emailController = TextEditingController();
   final _formKey = GlobalKey<FormState>();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.appColor,
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top:40,left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipOval(
                  child: Image.network('https://png.pngtree.com/png-vector/20191113/ourmid/pngtree-lock-password-password-lock-secure-password-blue-icon-on-abst-png-image_1985473.jpg',
                   height: 200,width: 200,fit: BoxFit.fill),
                ),
                SizedBox(height: 20,),
                Text('Reset Your Password',style: TextStyle(fontSize: 24)),
                const SizedBox(height: 30,),
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
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          Provider.of<LoginProvider>(context,listen: false).resetPassword(email: emailController.text.trim());
                        }
                      },
                    child: ButtonMixin()
                        .stylishButton(onPress: () {}, text: 'Reset Password'),
                  ),
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
