import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../models/complaint_model.dart';

class ComplaintDetailScreen extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintDetailScreen({
    super.key,
    required this.complaint,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text("Complaint Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status and Category Banner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Text(
                        complaint.category,
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14.sp),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(complaint.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16.sp, color: _getStatusColor(complaint.status)),
                          SizedBox(width: 5.w),
                          Text(
                            complaint.status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(complaint.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                // Title
                Text(
                  complaint.title,
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 15.h),

                // Date & Priority
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18.sp, color: Colors.grey),
                        SizedBox(width: 8.w),
                        Text(
                          DateFormat('MMM dd, yyyy - hh:mm a').format(complaint.createdAt),
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    if (complaint.priority != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: _getPriorityColor(complaint.priority)),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          "\${complaint.priority} Priority",
                          style: TextStyle(color: _getPriorityColor(complaint.priority), fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 15.h),

                // Location
                if (complaint.location != null && complaint.location!.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 18.sp, color: Colors.redAccent),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          complaint.location!,
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 30.h),

                // Media Attachment
                if (complaint.mediaUrl != null && complaint.mediaUrl!.isNotEmpty) ...[
                  Text("Attached Evidence", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 15.h),
                  Container(
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.network(
                        complaint.mediaUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey.shade200, child: const Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],

                // Description Box
                Text("Description", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 15.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: Text(
                    complaint.description,
                    style: TextStyle(fontSize: 16.sp, color: Colors.black87, height: 1.5),
                  ),
                ),
                SizedBox(height: 30.h),

                // Official Response
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.admin_panel_settings, color: Colors.blue, size: 24.sp),
                          SizedBox(width: 10.w),
                          Text(
                            "Official Response",
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      if (complaint.assignedDepartment != null && complaint.assignedDepartment!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Text(
                            "Assigned to: \${complaint.assignedDepartment}",
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                          ),
                        ),
                      Text(
                        (complaint.adminRemarks != null && complaint.adminRemarks!.isNotEmpty)
                            ? complaint.adminRemarks!
                            : (complaint.status.toLowerCase() == 'pending'
                                ? "Your complaint is currently under review by our team. You will be updated here once there is progress."
                                : "We are actively looking into this issue."),
                        style: TextStyle(fontSize: 14.sp, color: Colors.blue.shade900, height: 1.4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
