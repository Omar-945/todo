import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/Provider/auth_provider.dart';
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(title: AppLocalizations.of(context)!.registration),
              Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.name,
                        style: formStyle,
                      ),
                      CustomTextField(
                        control: name,
                        hint: AppLocalizations.of(context)!
                            .registration_name_hint,
                        type: TextInputType.name,
                        check: validName,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        AppLocalizations.of(context)!.email,
                        style: formStyle,
                      ),
                      CustomTextField(
                        check: validEmail,
                        control: email,
                        hint: AppLocalizations.of(context)!
                            .registration_email_hint,
                        type: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        AppLocalizations.of(context)!.registration_phone_hint,
                        style: formStyle,
                      ),
                      CustomTextField(
                        check: validPhone,
                        control: phone,
                        hint: AppLocalizations.of(context)!
                            .registration_phone_hint,
                        type: TextInputType.phone,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        AppLocalizations.of(context)!.password,
                        style: formStyle,
                      ),
                      CustomTextField(
                        check: validPassword,
                        control: password,
                        hint: AppLocalizations.of(context)!
                            .registration_password_hint,
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
                        AppLocalizations.of(context)!.config_password,
                        style: formStyle,
                      ),
                      CustomTextField(
                        check: validConfirmPassword,
                        control: confirmPassword,
                        hint:
                            AppLocalizations.of(context)!.config_password_hint,
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
                            AppLocalizations.of(context)!.registration,
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
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      Dialogs.showLoadingDialog(context, AppLocalizations.of(context)!.loading);
      await authProvider.registration(email.text, password.text, name.text);
      Dialogs.closeMessageDialog(context);
      Dialogs.showMessageDialog(
        context,
        AppLocalizations.of(context)!.registration_dialog,
        isClosed: false,
        positiveActionText: AppLocalizations.of(context)!.ok,
        positiveAction: () {
          Navigator.pushReplacementNamed(context, LoginScreen.route);
        },
        icon: Icon(
          Icons.check_circle_sharp,
          color: Colors.green,
          size: 30,
        ),
      );
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
