import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../utils/app_utils.dart';
import '../provider/loading_provider.dart';

class LoginAuth {


  static Future<User?> registerUsingEmailPassword({
    required String userType,
    required String email,
    required String mobile,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateDisplayName(mobile);
      await user.updateDisplayName(userType);
      //await user!.updateProfile(displayName: mobile);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        AppUtils.instance.showToast(toastMessage: 'The password provided is too weak.');
      }
      else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        AppUtils.instance.showToast(toastMessage: "The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('dfgsdcdd => $e');
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        print(e);
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        AppUtils.instance.showToast(toastMessage: 'No user found for that email.');
      }
      else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        Provider.of<LoadingProvider>(context,listen: false).stopLoading();
        AppUtils.instance.showToast(toastMessage: 'Wrong password provided.');
      }
    }
    return user;
  }

}