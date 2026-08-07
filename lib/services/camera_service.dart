import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';


class CameraService {

  CameraController? controller;


  Future<void> initializeCamera() async {

    try {

      final cameras = await availableCameras();

      debugPrint(
        "Camera count: ${cameras.length}",
      );


      if(cameras.isEmpty){

        throw Exception(
          "No camera found",
        );

      }


      final camera =
      cameras.firstWhere(

            (cam) =>
        cam.lensDirection ==
            CameraLensDirection.front,


        orElse: () => cameras.first,

      );


      controller = CameraController(

        camera,

        ResolutionPreset.medium,

        enableAudio: false,

      );


      await controller!.initialize();


      debugPrint(
        "Camera initialized",
      );


    } catch(e){

      debugPrint(
        "Camera error: $e",
      );

      rethrow;

    }

  }




  Future<File?> captureImage() async {


    if(controller == null ||
        !controller!.value.isInitialized){

      return null;

    }


    try {


      final image =
      await controller!.takePicture();


      return File(
        image.path,
      );


    }catch(e){


      debugPrint(
        "Capture error: $e",
      );


      return null;

    }

  }




  void dispose(){

    controller?.dispose();

  }

}