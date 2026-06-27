import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: 55.h,

      child: ElevatedButton(
        onPressed: onPressed,

        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }
}
