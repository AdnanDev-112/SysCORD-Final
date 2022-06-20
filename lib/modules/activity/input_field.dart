import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  // const InputField({Key? key}) : super(key: key);

  final String hint;
  final TextEditingController? controller;

  const InputField({
    Key? key,
    required this.hint,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      autofocus: false,
      cursorColor: Colors.black,
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter Time";
        } else {
          return null;
        }
      },
      style: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0))),
    );
  }
}
