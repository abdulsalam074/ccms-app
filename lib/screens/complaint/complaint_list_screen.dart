import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/complaint_model.dart';
import '../../services/complaint_service.dart';
import '../../widgets/complaint_card.dart';
import 'complaint_detail_screen.dart';

class ComplaintListScreen extends StatefulWidget {
  const ComplaintListScreen({super.key});

  @override
  State<ComplaintListScreen> createState() => _ComplaintListScreenState();
}

class _ComplaintListScreenState extends State<ComplaintListScreen> {
  final ComplaintService _complaintService = ComplaintService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("My Complaints", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                "Track the status of your reported issues below.",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: StreamBuilder<List<ComplaintModel>>(
                  stream: _complaintService.getComplaints(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: \${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assignment_turned_in, size: 80.sp, color: Colors.grey.shade300),
                            SizedBox(height: 20.h),
                            Text(
                              "No complaints found.",
                              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Any issues you report will appear here.",
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    List<ComplaintModel> complaints = snapshot.data!;

                    return ListView.builder(
                      itemCount: complaints.length,
                      itemBuilder: (context, index) {
                        final complaint = complaints[index];
                        return ComplaintCard(
                          complaint: complaint,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ComplaintDetailScreen(complaint: complaint),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Colors.blue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("New Complaint", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
