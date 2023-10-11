import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/ui/authentication/re_use_header.dart';
import 'package:todo/ui/authentication/register_screen.dart';
import 'package:todo/ui/authentication/reset_password.dart';
import 'package:todo/ui/authentication/user_valid_data.dart';

import '../re_use_widgets/cusom_text_field.dart';
import '../re_use_widgets/dialogs.dart';
import 'firebase_code_auth.dart';

class LoginScreen extends StatefulWidget {
  static const String route = 'loginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHidePassword = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle formStyle = GoogleFonts.quicksand(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(title: 'Login'),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Email",
                      style: formStyle,
                    ),
                    CustomTextField(
                      check: validEmail,
                      control: email,
                      hint: 'Your Email',
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Password",
                      style: formStyle,
                    ),
                    CustomTextField(
                      check: validPasswordLogIn,
                      control: password,
                      hint: 'Your password',
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
                            color: const Color(0xFFADADAD),
                          )),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                          width: double.infinity,
                        )),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, ResetPassword.route);
                            },
                            child: Text(
                              'Forgot Password?',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.quicksand(
                                  color: Color(0xFF302F2F), fontSize: 12),
                            )),
                      ],
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
                          createAcount();
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.quicksand(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don’t have an account yet? Register',
                          style: GoogleFonts.quicksand(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Registration.route);
                          },
                          child: Text(
                            ' here',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void createAcount() async {
    if (form.currentState?.validate() == false) {
      return;
    }
    try {
      Dialogs.showLoadingDialog(context, 'Loading...', isCanceled: false);
      var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      Dialogs.closeMessageDialog(context);
      FirebaseAuth.instance.currentUser?.emailVerified == true
          ? Dialogs.showMessageDialog(context, "Email verified",
              positiveActionText: 'ok')
          : Dialogs.showMessageDialog(
              context, "Please go to your email to verify your account",
              icon: Icon(
                Icons.dangerous,
                color: Colors.red,
                size: 30,
              ));
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
}
