import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../services/camera_service.dart';
import '../services/face_detector_service.dart';


class TakeAttendanceScreen extends StatefulWidget {
  const TakeAttendanceScreen({super.key});

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  final CameraService cameraService = CameraService();

  final FaceDetectorService faceService = FaceDetectorService();

  File? capturedImage;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    initialize();
  }

  Future<void> initialize() async {
    await cameraService.initializeCamera();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> captureFace() async {
    final image = await cameraService.captureImage();

    if (image != null) {
      setState(() {
        capturedImage = image;
      });
    }
  }

  Future<void> verifyFace() async {
    if (capturedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Capture face first")));

      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await faceService.verifyFace(capturedImage!);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    final matched = result['match'] == true;

    if (matched) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Face Verified ✅")));

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Face Not Matched ❌")));
    }
  }

  @override
  void dispose() {
    cameraService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = cameraService.controller;

    return Scaffold(
      appBar: AppBar(title: const Text("Face Verification")),

      body: Column(
        children: [
          Expanded(
            child: controller != null && controller.value.isInitialized
                ? CameraPreview(controller)
                : const Center(child: CircularProgressIndicator()),
          ),

          if (capturedImage != null)
            const Padding(
              padding: EdgeInsets.all(10),

              child: Text("Face Captured", style: TextStyle(fontSize: 18)),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              ElevatedButton(
                onPressed: captureFace,

                child: const Text("Capture"),
              ),

              ElevatedButton(
                onPressed: isLoading ? null : verifyFace,

                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text("Verify"),
              ),
            ],
          ), const SizedBox(height: 20),
        ],
      ),
    );
  }
}
