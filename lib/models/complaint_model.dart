class ComplaintModel {
  String? id;
  String title;
  String description;
  String category;
  String status;
  String userId;
  DateTime createdAt;
  
  String? location;
  String? priority;
  String? mediaUrl;
  String? assignedDepartment;
  String? adminRemarks;

  ComplaintModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.userId,
    required this.createdAt,
    this.location,
    this.priority,
    this.mediaUrl,
    this.assignedDepartment,
    this.adminRemarks,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "category": category,
      "status": status,
      "userId": userId,
      "createdAt": createdAt.toIso8601String(),
      "location": location,
      "priority": priority,
      "mediaUrl": mediaUrl,
      "assignedDepartment": assignedDepartment,
      "adminRemarks": adminRemarks,
    };
  }

  factory ComplaintModel.fromMap(Map<String, dynamic> map, String docId) {
    return ComplaintModel(
      id: docId,
      title: map["title"] ?? "",
      description: map["description"] ?? "",
      category: map["category"] ?? "",
      status: map["status"] ?? "Pending",
      userId: map["userId"] ?? "",
      createdAt: map["createdAt"] != null 
          ? DateTime.parse(map["createdAt"]) 
          : DateTime.now(),
      location: map["location"],
      priority: map["priority"],
      mediaUrl: map["mediaUrl"],
      assignedDepartment: map["assignedDepartment"],
      adminRemarks: map["adminRemarks"],
    );
  }
}
