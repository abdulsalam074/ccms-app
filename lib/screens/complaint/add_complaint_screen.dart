import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/complaint_model.dart';
import '../../services/complaint_service.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  
  String? selectedCategory;
  String? selectedPriority = "Medium";
  File? _selectedImage;
  bool isLoading = false;
  bool isGettingLocation = false;

  final ComplaintService _complaintService = ComplaintService();
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();

  final List<String> priorities = ["High", "Medium", "Low"];

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => isGettingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        locationController.text = "Lat: ${position.latitude}, Lng: ${position.longitude}";
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error getting location: \$e")));
    } finally {
      setState(() => isGettingLocation = false);
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
      Reference ref = FirebaseStorage.instance.ref().child('complaints').child(fileName);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      if (selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a category")));
        return;
      }

      setState(() => isLoading = true);

      String? mediaUrl;
      if (_selectedImage != null) {
        mediaUrl = await _uploadImage(_selectedImage!);
      }

      final user = _authService.getCurrentUser();
      final userId = user?.uid ?? "unknown_user";

      ComplaintModel newComplaint = ComplaintModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory!,
        status: "Pending",
        userId: userId,
        createdAt: DateTime.now(),
        location: locationController.text.trim(),
        priority: selectedPriority,
        mediaUrl: mediaUrl,
        assignedDepartment: "Pending Assignment",
        adminRemarks: "",
      );

      String result = await _complaintService.addComplaint(newComplaint);

      if (!mounted) return;
      setState(() => isLoading = false);

      if (result == "success") {
        await _notificationService.showNotification(
          "Complaint Submitted", 
          "Your complaint '${titleController.text}' has been received."
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Complaint submitted successfully!")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Complaint", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "We are here to help.",
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Please provide the details of your issue so we can resolve it as soon as possible.",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category
                        Text("Category", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                        SizedBox(height: 10.h),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          hint: const Text("Select Category"),
                          items: Constants.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (val) => setState(() => selectedCategory = val),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Priority
                        Text("Priority Level", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                        SizedBox(height: 10.h),
                        DropdownButtonFormField<String>(
                          value: selectedPriority,
                          items: priorities.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                          onChanged: (val) => setState(() => selectedPriority = val),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Title
                        Text("Title", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: titleController,
                          hint: "E.g. Broken Streetlight",
                          icon: Icons.title,
                          validator: (val) => val == null || val.isEmpty ? "Title is required" : null,
                        ),
                        SizedBox(height: 20.h),

                        // Location
                        Text("Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: locationController,
                                decoration: InputDecoration(
                                  hintText: "Enter or fetch location...",
                                  prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
                                ),
                                validator: (val) => val == null || val.isEmpty ? "Location is required" : null,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            isGettingLocation
                                ? const CircularProgressIndicator()
                                : IconButton(
                                    icon: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                                    onPressed: _getCurrentLocation,
                                  ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        // Media Upload
                        Text("Attach Evidence (Optional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 120.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera_alt, size: 40.sp, color: Colors.grey),
                                      SizedBox(height: 5.h),
                                      Text("Tap to upload an image", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Description
                        Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Provide detailed information...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
                            contentPadding: EdgeInsets.all(15.w),
                          ),
                          validator: (val) => val == null || val.isEmpty ? "Description is required" : null,
                        ),
                        SizedBox(height: 30.h),

                        // Submit
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(text: "Submit Complaint", onPressed: submitComplaint),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
