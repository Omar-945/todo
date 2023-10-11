import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef valid = String? Function(String?);

class CustomTextField extends StatelessWidget {
  String hint;
  IconButton? passwordIcon;
  bool isSecrete;

  TextInputType type;

  TextEditingController control;
  valid? check;

  CustomTextField(
      {super.key,
      required this.hint,
      this.isSecrete = false,
      this.type = TextInputType.text,
      this.passwordIcon,
      required this.control,
      this.check});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: check,
      controller: control,
      keyboardType: type,
      obscureText: isSecrete,
      decoration: InputDecoration(
          suffixIcon: passwordIcon,
          hintText: hint,
          helperStyle: GoogleFonts.quicksand(
              fontSize: 5,
              color: Color(0xFFADADAD),
              fontWeight: FontWeight.normal)),
    );
  }
}
