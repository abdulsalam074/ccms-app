import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?) validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText=false,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {

    return TextFormField(

      controller: controller,
      obscureText: obscureText,
      validator: validator,

      decoration: InputDecoration(

        prefixIcon: Icon(icon),

        hintText: hint,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),

      ),

    );
  }
}
