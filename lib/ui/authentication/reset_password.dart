import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(title: AppLocalizations.of(context)!.reset_password),
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
                        AppLocalizations.of(context)!.email,
                        style: formStyle,
                      ),
                      CustomTextField(
                        check: validEmail,
                        control: email,
                        hint: AppLocalizations.of(context)!.your_email,
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
                            AppLocalizations.of(context)!.send_link,
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
      Dialogs.showLoadingDialog(context, AppLocalizations.of(context)!.loading);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      Dialogs.closeMessageDialog(context);
      Dialogs.showMessageDialog(
          context, AppLocalizations.of(context)!.password_dialog,
          icon: Icon(
            Icons.check_circle_sharp,
            color: Colors.green,
            size: 30,
          ),
          positiveActionText: AppLocalizations.of(context)!.ok,
          positiveAction: () {
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
