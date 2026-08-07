import 'dart:convert';
import 'dart:io';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
 import 'package:http/http.dart' as http;

class FaceDetectorService{
  late final FaceDetector _detector;

  static const String _baseUrl="http://127.0.0.1:8001";

  FaceDetectorService(){
    _detector=FaceDetector(
      options:FaceDetectorOptions(
        performanceMode:FaceDetectorMode.accurate,
        enableContours:true,
        enableLandmarks:true,
        enableClassification:true,
        minFaceSize:0.15,
      ),
    );
  }

  Future<List<Face>> detect(InputImage image)async{
    return await _detector.processImage(image);
  }

  Future<bool> hasSingleFace(InputImage image)async{
    final faces=await detect(image);
    return faces.length==1;
  }

  Future<Map<String,dynamic>> verifyFace(File imageFile)async{
    final request=http.MultipartRequest(
      "POST",
      Uri.parse("$_baseUrl/verify"),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        imageFile.path,
      ),
    );

    final response=await request.send();

    final body=await response.stream.bytesToString();

    return jsonDecode(body);
  }

  Future<void> dispose()async{
    await _detector.close();
  }
}