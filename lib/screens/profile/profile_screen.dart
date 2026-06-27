import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Loading...";
  String userEmail = "Loading...";
  String? profilePicUrl;
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          userName = doc.data()?['name'] ?? "User";
          userEmail = doc.data()?['email'] ?? user.email ?? "Unknown";
          profilePicUrl = doc.data()?['profilePicUrl'];
        });
      }
    }
  }

  Future<void> _uploadProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() => isUploading = true);
      try {
        File imageFile = File(pickedFile.path);
        
        // Upload to Firebase Storage
        Reference ref = FirebaseStorage.instance.ref().child('profile_pictures').child("\${user.uid}.jpg");
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Save to Firestore
        await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
          "profilePicUrl": downloadUrl,
        });

        setState(() {
          profilePicUrl = downloadUrl;
        });

        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile picture updated successfully!")));
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error uploading: \$e")));
      } finally {
        setState(() => isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _uploadProfilePicture,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 55.r,
                      backgroundColor: isDark ? Colors.grey.shade800 : Colors.blue.shade100,
                      backgroundImage: profilePicUrl != null ? NetworkImage(profilePicUrl!) : null,
                      child: profilePicUrl == null
                          ? Icon(Icons.person, size: 60.sp, color: isDark ? Colors.grey.shade400 : Colors.blue)
                          : null,
                    ),
                    if (isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt, size: 20.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                userName,
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
              ),
              SizedBox(height: 5.h),
              Text(
                userEmail,
                style: TextStyle(fontSize: 16.sp, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
              SizedBox(height: 40.h),
              _buildProfileOption(Icons.edit, "Edit Profile", isDark),
              _buildProfileOption(Icons.lock, "Change Password", isDark),
              _buildProfileOption(Icons.help_outline, "Help & Support", isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("\$title coming soon!")));
        },
      ),
    );
  }
}
