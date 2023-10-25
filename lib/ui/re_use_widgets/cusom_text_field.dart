import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

typedef valid = String? Function(String?);

class CustomTextField extends StatelessWidget {
  String hint;
  TextStyle? hintStyle;

  TextStyle? textStyle;
  IconButton? passwordIcon;
  bool isSecrete;
  TextInputType type;
  TextEditingController control;
  valid? check;
  int? maxline;
  int? minline;
  bool withBoarder;

  CustomTextField(
      {super.key,
      required this.hint,
      this.isSecrete = false,
      this.type = TextInputType.text,
      this.passwordIcon,
      required this.control,
      this.hintStyle,
      this.textStyle,
      this.check,
      this.maxline,
      this.minline,
      this.withBoarder = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxline != null ? maxline : 1,
      minLines: minline != null ? minline : 1,
      style: textStyle,
      validator: check,
      controller: control,
      keyboardType: type,
      obscureText: isSecrete,
      decoration: InputDecoration(
        hintStyle: hintStyle,
        suffixIcon: passwordIcon,
        hintText: hint,
        helperStyle: GoogleFonts.quicksand(
            fontSize: 5,
            color: Color(0xFFADADAD),
            fontWeight: FontWeight.normal),
        enabledBorder: withBoarder
            ? UnderlineInputBorder(
                borderSide: BorderSide(width: 1, color: Color(0xFF707070)))
            : null,
      ),
    );
  }
}
