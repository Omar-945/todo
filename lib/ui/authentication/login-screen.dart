import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/Provider/auth_provider.dart';
import 'package:todo/ui/authentication/re_use_header.dart';
import 'package:todo/ui/authentication/register_screen.dart';
import 'package:todo/ui/authentication/reset_password.dart';
import 'package:todo/ui/authentication/user_valid_data.dart';

import '../re_use_widgets/cusom_text_field.dart';

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(title: AppLocalizations.of(context)!.login),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: form,
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
                    Text(
                      AppLocalizations.of(context)!.password,
                      style: formStyle,
                    ),
                    CustomTextField(
                      check: validPasswordLogIn,
                      control: password,
                      hint: AppLocalizations.of(context)!.your_password,
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
                              AppLocalizations.of(context)!.forget_password,
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
                          AppLocalizations.of(context)!.login,
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
                          AppLocalizations.of(context)!.have_account,
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
                            AppLocalizations.of(context)!.here,
                            style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.blueAccent),
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
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.login(email.text, password.text, context);
  }
}
