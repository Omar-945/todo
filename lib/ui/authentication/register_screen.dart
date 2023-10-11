import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/database/models/user.dart' as myUser;
import 'package:todo/database/user_dao.dart';
import 'package:todo/ui/authentication/firebase_code_auth.dart';
import 'package:todo/ui/authentication/login-screen.dart';
import 'package:todo/ui/authentication/re_use_header.dart';
import 'package:todo/ui/authentication/user_valid_data.dart';
import 'package:todo/ui/re_use_widgets/cusom_text_field.dart';

import '../re_use_widgets/dialogs.dart';

class Registration extends StatefulWidget {
  static const String route = 'registrationScreen';

  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isHidePassword = true;
  bool isHideConfirmpassword = true;

  @override
  Widget build(BuildContext context) {
    TextStyle formStyle = GoogleFonts.quicksand(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(title: 'Registration'),
          Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: formStyle,
                  ),
                  CustomTextField(
                    control: name,
                    hint: 'Your Name, e.g : John Doe',
                    type: TextInputType.name,
                    check: validName,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Email",
                    style: formStyle,
                  ),
                  CustomTextField(
                    check: validEmail,
                    control: email,
                    hint: 'Your email, e.g : johndoe@gmail.com',
                    type: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Phone Number",
                    style: formStyle,
                  ),
                  CustomTextField(
                    check: validPhone,
                    control: phone,
                    hint: 'Your phone number, e.g : +01 112 xxx xxxx',
                    type: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Password",
                    style: formStyle,
                  ),
                  CustomTextField(
                    check: validPassword,
                    control: password,
                    hint: 'Your password, at least 8 character.',
                    isSecrete: isHidePassword,
                    passwordIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isHidePassword = !isHidePassword;
                          });
                        },
                        icon: Icon(
                          isHidePassword == true
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFFADADAD),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Confirm Password",
                    style: formStyle,
                  ),
                  CustomTextField(
                    check: validConfirmPassword,
                    control: confirmPassword,
                    hint: 'Re-type your password',
                    isSecrete: isHideConfirmpassword,
                    passwordIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isHideConfirmpassword = !isHideConfirmpassword;
                          });
                        },
                        icon: Icon(
                          isHideConfirmpassword == true
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFFADADAD),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFF5D9CEC),
                        borderRadius: BorderRadius.circular(50)),
                    child: TextButton(
                      onPressed: () {
                        createAccount();
                      },
                      child: Text(
                        "Register",
                        style: GoogleFonts.quicksand(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  String? validConfirmPassword(String? checkPassword) {
    if (password.text == checkPassword) {
      return null;
    } else
      return 'not typical';
  }

  void createAccount() async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    try {
      Dialogs.showLoadingDialog(context, 'Loading...');
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      var newUser =
          myUser.User(id: user.user?.uid, name: name.text, email: email.text);
      await UserDao.addUser(newUser);
      Dialogs.closeMessageDialog(context);
      Dialogs.showMessageDialog(
        context,
        'registration successful go to your email to verify account',
        isClosed: false,
        positiveActionText: 'Ok',
        positiveAction: () {
          Navigator.pushReplacementNamed(context, LoginScreen.route);
        },
        icon: Icon(
          Icons.check_circle_sharp,
          color: Colors.green,
          size: 30,
        ),
      );
      user.user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      Dialogs.closeMessageDialog(context);
      if (e.code == FireAuthErrors.weakPassword) {
        Dialogs.showMessageDialog(context, 'weak password',
            isClosed: false,
            positiveActionText: 'ok',
            icon: Icon(
              Icons.dangerous,
              color: Colors.red,
              size: 30,
            ));
      } else if (e.code == FireAuthErrors.emailExcist) {
        Dialogs.showMessageDialog(context, 'Email alredy excist',
            isClosed: false,
            positiveActionText: 'ok',
            icon: Icon(
              Icons.dangerous,
              color: Colors.red,
              size: 30,
            ));
      } else {
        Dialogs.showMessageDialog(context, 'Something went wrong , ${e.code}',
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
}
