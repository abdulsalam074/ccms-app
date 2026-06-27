# Digital Complaint Management System (CCMS)

A modern, responsive, and robust mobile application built using Flutter to digitize and streamline the process of submitting, tracking, and resolving civic complaints. 

This project is tailored to provide a seamless citizen-to-administration communication channel, complete with real-time tracking, geolocation, and secure multimedia evidence uploads.

## ✨ Key Features
- **Secure Authentication:** Firebase-powered User Login, Registration, and automated Session Management.
- **Responsive Dashboard:** Intelligent UI that beautifully adapts to mobile and tablet screen sizes in both portrait and landscape orientations. Includes live statistics and real-time weather integration.
- **Complaint Management:** Easily submit new complaints including severity level categorization. 
- **Geolocation Support:** Automatically fetch precise user coordinates for accurate issue mapping.
- **Evidence Uploads:** Gallery and Camera access to upload images/evidence securely to Firebase Cloud Storage.
- **Global Dark Mode:** Instantly toggle between Light and Dark themes dynamically using a custom global ThemeProvider.
- **Push Notifications:** Instant feedback alerts for complaint submissions.
- **System Permissions:** Clean hardware privilege initialization for Location, Storage, and Camera.

## 🛠️ Technology Stack
- **Framework:** Flutter (Dart)
- **Backend:** Firebase (Authentication, Cloud Firestore, Cloud Storage)
- **State Management:** Provider
- **Local Storage:** SharedPreferences

## 🚀 Getting Started

### Prerequisites
Make sure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.11.1 or higher)
- Android Studio / Xcode for device emulation
- An active Firebase Project configured for Android/iOS

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/abdulsalam074/ccms-app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd ccms-app
   ```
3. Install the dependencies:
   ```bash
   flutter pub get
   ```
4. Configure Firebase:
   - Ensure `google-services.json` is correctly placed inside the `android/app/` directory (for Android).
   - Verify Firebase Storage and Firestore rules are set up in your Firebase Console.
5. Run the application:
   ```bash
   flutter run
   ```

## 📦 Dependencies
Please refer to the `requirements.txt` or `pubspec.yaml` file for the complete list of packages utilized in this project. Major integrations include `firebase_core`, `firebase_auth`, `cloud_firestore`, `provider`, and `flutter_screenutil`.

## 👤 Author
- **Abdulsalam** (23-se-074@student.hitecuni.edu.pk)
