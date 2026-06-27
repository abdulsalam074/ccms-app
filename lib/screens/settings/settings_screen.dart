import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("App Preferences", isDark),
                _buildSwitchTile(
                  "Push Notifications", 
                  notificationsEnabled, 
                  (val) => setState(() => notificationsEnabled = val),
                  isDark
                ),
                _buildSwitchTile(
                  "Location Services", 
                  locationEnabled, 
                  (val) => setState(() => locationEnabled = val),
                  isDark
                ),
                _buildSwitchTile(
                  "Dark Mode", 
                  themeProvider.isDarkMode, 
                  (val) {
                    themeProvider.toggleTheme(val);
                  },
                  isDark
                ),
                
                SizedBox(height: 30.h),
                _buildSectionTitle("Account", isDark),
                _buildActionTile("Privacy Policy", isDark),
                _buildActionTile("Terms of Service", isDark),
                _buildActionTile("About CCMS", isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, left: 5.w),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 14.sp, 
          fontWeight: FontWeight.bold, 
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: SwitchListTile(
        title: Text(
          title, 
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87)
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildActionTile(String title, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: ListTile(
        title: Text(
          title, 
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87)
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey),
        onTap: () {
          // Placeholder
        },
      ),
    );
  }
}
