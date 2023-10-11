import 'package:flutter/material.dart';

TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController confirmPassword = TextEditingController();

String? validName(String? name) {
  if (name == null || name.trim().isEmpty) return 'Please enter your name';
  return null;
}

String? validEmail(String? email) {
  bool isValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email ?? "");
  return isValid ? null : "Please enter a valid email";
}

String? validPhone(String? phone) {
  String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(phone!) ? null : "please enter valid phone number";
}

String? validPassword(String? password) {
  bool check =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
          .hasMatch(password!);
  return check
      ? null
      : '''       should contain at least one upper case
       should contain at least one lower case
       should contain at least one digit
       should contain at least one Special character like @,#,*.!.&,~
       Must be at least 8 characters in length  ''';
}

String? validPasswordLogIn(String? password) {
  if (password == null || password.trim().isEmpty) {
    return 'Please enter your password';
  }
  return null;
}
