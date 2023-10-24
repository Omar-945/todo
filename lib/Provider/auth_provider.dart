import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo/database/models/user.dart' as appUser;
import 'package:todo/ui/authentication/login-screen.dart';
import 'package:todo/ui/home_screen.dart';

import '../database/user_dao.dart';
import '../ui/authentication/firebase_code_auth.dart';
import '../ui/re_use_widgets/dialogs.dart';

class AuthProvider extends ChangeNotifier {
  User? fireUser;

  appUser.User? user;

  Future<void> registration(
    String email,
    String password,
    String name,
  ) async {
    var user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    var newUser = appUser.User(id: user.user?.uid, name: name, email: email);
    await UserDao.addUser(newUser);
    user.user?.sendEmailVerification();
  }

  login(String email, String password, BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(context, AppLocalizations.of(context)!.loading,
          isCanceled: false);
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Dialogs.closeMessageDialog(context);
      fireUser = result.user;
      if (fireUser?.emailVerified == true) {
        user = await UserDao.getUser(result.user?.uid);
        Navigator.pushReplacementNamed(context, HomeScreen.route);
      } else {
        Dialogs.showMessageDialog(context, AppLocalizations.of(context)!.verify,
            icon: Icon(
              Icons.dangerous,
              color: Colors.red,
              size: 30,
            ));
      }
    } on FirebaseAuthException catch (e) {
      Dialogs.closeMessageDialog(context);
      if (e.code == FireAuthErrors.userNotFound) {
        Dialogs.showMessageDialog(context, 'email or password is wrong',
            isClosed: false,
            positiveActionText: 'ok',
            icon: Icon(
              Icons.dangerous,
              color: Colors.red,
              size: 30,
            ));
      } else if (e.code == FireAuthErrors.wrongPassword) {
        Dialogs.showMessageDialog(context, 'email or password is wrong',
            isClosed: false,
            positiveActionText: 'ok',
            icon: Icon(
              Icons.dangerous,
              color: Colors.red,
              size: 30,
            ));
      } else {
        Dialogs.showMessageDialog(context, 'email or password is wrong',
            isClosed: false,
            positiveActionText: 'ok',
            icon: Icon(
              Icons.dangerous,
              color: Colors.red,
              size: 30,
            ));
      }
    }
  }

 signOut(BuildContext context) async {
    user = null;
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, LoginScreen.route);
  }

  bool isLogedBefore() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> getUserData() async {
    fireUser = FirebaseAuth.instance.currentUser;
    user = await UserDao.getUser(fireUser?.uid);
  }
}
