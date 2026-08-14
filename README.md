# Face Attendance System

A **Flutter-based** automated attendance management system . The application supports separate **Teacher** and **Student** workflows — teachers manage attendance sessions with rotating session codes, while students register their face data and mark attendance through a face-verification process.


## 📖 Overview

Traditional attendance systems are time-consuming and vulnerable to proxy attendance and manual errors. This app provides a digital alternative — a single Flutter codebase handling UI, camera-based face capture, session management, and attendance flow, backed by Firebase for authentication and cloud data storage.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter / Dart | App UI, camera handling, face capture, and core logic |
| Firebase Authentication | User registration & login |
| Cloud Firestore | Cloud database for app/attendance data |
| Google ML Kit | On-device face detection |


## 🏗️ System Architecture

```
Student/Teacher → Flutter App
Flutter App → Firebase Authentication
Flutter App → Cloud Firestore
Flutter App → Camera → ML Kit Face Detection
Attendance Session → Student Verification → Attendance Record
```

## 👥 User Roles

**Teacher**
- Log in and access the teacher dashboard
- Create and manage attendance sessions
- Generate/rotate session codes
- Monitor active sessions

**Student**
- Register an account and log in
- Register personal information & facial data
- Join an active attendance session
- Submit attendance via face verification

## ✨ Main Features

- User registration & authentication (Firebase)
- Role-based navigation (Teacher / Student)
- Camera-based face data capture and registration
- On-device face detection via Google ML Kit
- Teacher-controlled attendance sessions with time-based session code rotation (currently 5-second validity)
- Cloud-based attendance data storage
- Responsive Flutter UI across platforms

## 📱 Application Screens

| Screen | Description |
|---|---|
| Login Screen | Secure entry point via Firebase Authentication |
| Registration Screen | New user account creation |
| Authentication Gate | Routes users based on auth state |
| Teacher Home Screen | Access to session management |
| Student Home Screen | Access to profile, face registration, sessions |
| Register Student Screen | Register student info + start face registration |
| Face Registration Screen | Camera-based facial data capture |
| Teacher Session Screen | Create/manage an attendance session |
| Student Session Screen | Join an active session and submit attendance |

## 🧠 Face Registration & Recognition

1. **Capture** — The app's camera screen captures facial samples for each student
2. **Detect** — Google ML Kit performs on-device face detection on captured frames
3. **Verify** — The detection result is used as part of the attendance verification workflow

## 📋 Attendance Flow

1. Teacher logs in and creates an attendance session
2. Session becomes active; a session code is generated and rotates on a configured interval
3. Student opens the active session and completes face verification
4. Attendance result is submitted and stored in Cloud Firestore

## 📂 Project Structure

```
attendance_app/
├── lib/
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── student_home_screen.dart
│   │   ├── teacher_home_screen.dart
│   │   ├── auth_gate.dart
│   │   ├── register_face_screen.dart
│   │   ├── register_student_screen.dart
│   │   ├── student_session_screen.dart
│   │   └── teacher_session_screen.dart
│   └── services/
│       ├── auth_service.dart
│       ├── session_service.dart
│       ├── camera_service.dart
│       └── face_detector_service.dart
├── android/ ios/ web/ ...    # Flutter platform folders
├── backend/                   # optional Python/OpenCV experiments
├── pubspec.yaml
└── firebase configuration files
```

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>=3.11.0)
- Android Studio or VS Code with Flutter/Dart plugins
- A Firebase project (for Auth + Firestore)

### 1. Clone & Install

```bash
git clone https://github.com/shuvo0037/Face-Recognition-Attendance-App.git
cd Face-Recognition-Attendance-App
flutter pub get
```



### 2. Run the App

```bash
flutter run
```

## 🔮 Future Improvements
- Administrator functionality
- Class, course, semester, and timetable management
- Analytics and attendance percentage dashboards
- Improved offline handling and sync
- Stronger privacy controls for biometric data


## 🤝 Contributor
Fuad Intisar(2023831041)<br>
Sushanto Kumar Sarkar(2022831039)
