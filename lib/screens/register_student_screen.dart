import 'dart:io';
import 'package:flutter/material.dart';

class RegisterStudentScreen extends StatefulWidget{
  const RegisterStudentScreen({super.key});

  @override
  State<RegisterStudentScreen> createState()=>_RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen>{
  final _nameController=TextEditingController();
  final _idController=TextEditingController();

  bool loading=false;

  Future<void> registerStudent()async{
    if(_nameController.text.trim().isEmpty||
        _idController.text.trim().isEmpty){
      return;
    }

    setState(() {
      loading=true;
    });

    try{

      final capture=await Process.run(
        "python",
        [
          "backend/capture_faces.py",
          _idController.text.trim(),
        ],
      );

      debugPrint(capture.stdout.toString());
      debugPrint(capture.stderr.toString());

      final train=await Process.run(
        "python",
        [
          "backend/train_model.py",
        ],
      );

      debugPrint(train.stdout.toString());
      debugPrint(train.stderr.toString());

      if(!mounted)return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:Text("Student Registered Successfully"),
        ),
      );

      _nameController.clear();
      _idController.clear();

    }catch(e){

      debugPrint(e.toString());

    }

    if(mounted){
      setState(() {
        loading=false;
      });
    }
  }

  @override
  void dispose(){
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:const Text("Register Student"),
      ),
      body:Padding(
        padding:const EdgeInsets.all(20),
        child:Column(
          children:[
            TextField(
              controller:_nameController,
              decoration:const InputDecoration(
                labelText:"Student Name",
                border:OutlineInputBorder(),
              ),
            ),
            const SizedBox(height:15),
            TextField(
              controller:_idController,
              decoration:const InputDecoration(
                labelText:"Student ID",
                border:OutlineInputBorder(),
              ),
            ),
            const SizedBox(height:20),
            SizedBox(
              width:double.infinity,
              height:55,
              child:ElevatedButton(
                onPressed:loading?null:registerStudent,
                child:loading
                    ?const CircularProgressIndicator()
                    :const Text("Start Face Registration"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}