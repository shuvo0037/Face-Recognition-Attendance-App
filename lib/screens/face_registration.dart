

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';



class FaceRegistration extends StatefulWidget {

  const FaceRegistration({super.key});


  @override
  State<FaceRegistration> createState() =>
      _FaceRegistrationState();

}



class _FaceRegistrationState 
extends State<FaceRegistration>{


CameraController? controller;

List<CameraDescription>? cameras;



@override
void initState(){

super.initState();

_initializeCamera();

}



Future<void> _initializeCamera() async{


cameras = await availableCameras();


controller = CameraController(

cameras!.firstWhere(
(camera)=>camera.lensDirection ==
CameraLensDirection.front
),

ResolutionPreset.medium,

);


await controller!.initialize();


if(mounted){
setState((){});
}


}




@override
Widget build(BuildContext context){


if(controller == null ||
!controller!.value.isInitialized){

return const Scaffold(

body: Center(

child:CircularProgressIndicator(),

),

);

}


return Scaffold(

appBar: AppBar(

title:const Text(
"Register Face"
),

),


body: Column(

children:[


Expanded(

child:CameraPreview(
controller!
),

),



Padding(

padding:const EdgeInsets.all(20),


child:ElevatedButton(

child:const Text(
"Capture Face"
),


  onPressed:()async{

    try {

      final image =
      await controller!.takePicture();

      debugPrint(image.path);

      // next step:
      // upload image + face detection


    } catch(e){

      debugPrint(e.toString());

    }


  },


),

)


],


),


);


}



@override
void dispose(){

controller?.dispose();

super.dispose();

}

}