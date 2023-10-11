import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/ui/authentication/login-screen.dart';
import 'package:todo/ui/authentication/re_use_header.dart';
import 'package:todo/ui/authentication/user_valid_data.dart';

import '../re_use_widgets/cusom_text_field.dart';
import '../re_use_widgets/dialogs.dart';

class ResetPassword extends StatefulWidget {
  static const String route = 'resetPassword';

  ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<FormState> form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextStyle formStyle = GoogleFonts.quicksand(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(title: 'Reset Password'),
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: form,
                child: Padding(
                  padding: EdgeInsets.only(top: 130),
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
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xFF5D9CEC),
                            borderRadius: BorderRadius.circular(50)),
                        child: TextButton(
                          onPressed: () {
                            resetPassword();
                          },
                          child: Text(
                            'send link to rest password',
                            style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void resetPassword() async {
    if (form.currentState?.validate() == false) {
      return;
    }
    try {
      Dialogs.showLoadingDialog(context, 'loading...');
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      Dialogs.closeMessageDialog(context);
      Dialogs.showMessageDialog(context, 'go to your email to change password',
          icon: Icon(
            Icons.check_circle_sharp,
            color: Colors.green,
            size: 30,
          ),
          positiveActionText: 'ok', positiveAction: () {
        Navigator.pushReplacementNamed(context, LoginScreen.route);
      });
    } on FirebaseAuthException catch (e) {
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
