import 'package:ccms/services/auth_service.dart';
import 'package:ccms/utils/validators.dart';
import 'package:ccms/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;

  Future<void> login() async {

    if (_formKey.currentState!.validate()) {

      setState(() {
        isLoading = true;
      });

      String result = await authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (result == "success") {

        Navigator.pushReplacementNamed(
          context,
          '/dashboard',
        );

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
          ),
        );

      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Padding(

        padding: EdgeInsets.all(20.w),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              CustomTextField(
                controller: emailController,
                hint: "Email",
                icon: Icons.email,
                validator: Validators.validateEmail,
              ),

              SizedBox(height: 20.h),

              CustomTextField(
                controller: passwordController,
                hint: "Password",
                icon: Icons.lock,
                obscureText: true,
                validator: Validators.validatePassword,
              ),

              SizedBox(height: 25.h),

              ElevatedButton(
                onPressed: login,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),

              TextButton(

                onPressed: () {

                  Navigator.pushNamed(
                    context,
                    '/register',
                  );

                },

                child: const Text(
                    "Create New Account"
                ),

              )

            ],

          ),

        ),

      ),

    );
  }
}
