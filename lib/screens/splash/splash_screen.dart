import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Wait briefly to show the splash
    await Future.delayed(const Duration(seconds: 2));
    
    // Request permissions
    await _requestPermissions();

    if (!mounted) return;

    // Check session
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/home'); 
    }
  }

  Future<void> _requestPermissions() async {
    // Request crucial permissions for the app
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
      Permission.storage,
      Permission.notification,
    ].request();
    
    // We don't strictly block the user here if they deny, 
    // but the permissions are requested upfront.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.report_problem,
              size: 100.sp,
              color: Colors.blue,
            ),
            SizedBox(height: 20.h),
            Text(
              "Citizen Complaint Portal",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
