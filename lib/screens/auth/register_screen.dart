import 'package:ccms/services/auth_service.dart';
import 'package:ccms/utils/validators.dart';
import 'package:ccms/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;

  Future<void> register() async {

    if (_formKey.currentState!.validate()) {

      setState(() {
        isLoading = true;
      });

      String result = await authService.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (result == "success") {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration Successful"),
          ),
        );

        Navigator.pushReplacementNamed(
          context,
          '/home',
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
        title: const Text("Register"),
      ),

      body: Padding(

        padding: EdgeInsets.all(20.w),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              CustomTextField(
                controller: nameController,
                hint: "Full Name",
                icon: Icons.person,
                validator: Validators.validateName,
              ),

              SizedBox(height: 20.h),

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

                onPressed: register,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Register"),

              ),

              TextButton(

                onPressed: (){

                  Navigator.pushNamed(
                      context,
                      '/login'
                  );

                },

                child: const Text(
                  "Already have account? Login",
                ),

              )

            ],

          ),

        ),

      ),

    );
  }
}
