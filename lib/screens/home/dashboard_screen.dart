import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../services/weather_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();
  final WeatherService _weatherService = WeatherService();

  String userName = "User";
  String weatherCondition = "Loading...";
  String temperature = "--°C";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchWeather();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          userName = doc.data()?['name'] ?? "User";
        });
      }
    }
  }

  Future<void> _fetchWeather() async {
    try {
      final data = await _weatherService.getWeather("London");
      // wttr.in format=j1 parsing
      final current = data['current_condition'][0];
      setState(() {
        weatherCondition = current['weatherDesc'][0]['value'];
        temperature = current['temp_C'] + "°C";
      });
    } catch (e) {
      setState(() {
        weatherCondition = "Sunny"; // Fallback mock
        temperature = "25°C";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await _authService.logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                // Welcome Section
                Text(
                  "Welcome back,",
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
                ),
                Text(
                  userName,
                  style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 20.h),

                // Weather & Stats Row
                Row(
                  children: [
                    // Weather Card
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff4facfe), Color(0xff00f2fe)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.wb_sunny, color: Colors.white, size: 30.sp),
                            SizedBox(height: 10.h),
                            Text(temperature, style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold)),
                            Text(weatherCondition, style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    // Stats Card (StreamBuilder)
                    Expanded(
                      flex: 1,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("complaints")
                            .where("userId", isEqualTo: user?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          int total = 0;
                          int pending = 0;
                          if (snapshot.hasData) {
                            total = snapshot.data!.docs.length;
                            pending = snapshot.data!.docs.where((doc) => doc['status'] == 'Pending').length;
                          }
                          return Container(
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade900 : Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.analytics, color: Colors.blue, size: 30.sp),
                                SizedBox(height: 10.h),
                                Text("$total Total", style: TextStyle(color: Colors.black87, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                                Text("$pending Pending", style: TextStyle(color: Colors.orange, fontSize: 14.sp, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 15.h),

                // Grid
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.w,
                  mainAxisSpacing: 15.h,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildActionCard(context, "New Complaint", Icons.add_circle, Colors.blue, "/add"),
                    _buildActionCard(context, "My Complaints", Icons.list_alt, Colors.green, "/list"),
                    _buildActionCard(context, "Profile", Icons.person, Colors.purple, "/profile"),
                    _buildActionCard(context, "Settings", Icons.settings, Colors.orange, "/settings"),
                  ],
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, MaterialColor color, String route) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: color.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 35.sp, color: color),
            ),
            SizedBox(height: 10.h),
            Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
          ],
        ),
      ),
    );
  }
}
