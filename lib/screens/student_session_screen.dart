import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import '../services/session_service.dart';

import 'take_attendance_screen.dart';



class StudentSessionScreen extends StatefulWidget {


  final String sessionId;
  final String courseName;



  const StudentSessionScreen({

    super.key,

    required this.sessionId,

    required this.courseName,

  });



  @override
  State<StudentSessionScreen> createState() =>
      _StudentSessionScreenState();

}




class _StudentSessionScreenState
    extends State<StudentSessionScreen> {



  final TextEditingController _codeController =
  TextEditingController();



  final SessionService _sessionService =
  SessionService();



  final AuthService _auth =
  AuthService();



  bool _submitting = false;

  bool _success = false;

  bool _faceVerified = false;


  String? _error;





  @override
  void dispose(){


    _codeController.dispose();


    super.dispose();

  }





  Future<String> _getStudentName() async {


    final user =
        _auth.currentUser;



    if(user == null){

      return "Student";

    }




    final doc =
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();




    return doc.data()?['name'] ??
        user.email ??
        "Student";


  }






  Future<void> _verifyFace() async {



    final result =
    await Navigator.push(

      context,


      MaterialPageRoute(

        builder: (context)=>

        const TakeAttendanceScreen(),

      ),

    );



    if(result == true){


      if(!mounted) return;


      setState((){


        _faceVerified = true;


      });



    }


  }








  Future<void> _submit() async {



    if(!_faceVerified){

      setState((){

        _error =
        "Please verify face first";

      });


      return;

    }





    if(_codeController.text.trim().isEmpty){

      return;

    }





    setState((){


      _submitting = true;

      _error = null;


    });





    try{



      final user =
          _auth.currentUser;




      if(user == null){

        throw Exception(
            "Please login again"
        );

      }





      final studentName =
      await _getStudentName();





      await _sessionService.submitAttendance(


        sessionId:
        widget.sessionId,


        studentId:
        user.uid,


        studentName:
        studentName,


        enteredCode:
        _codeController.text.trim(),


      );





      if(!mounted) return;




      setState((){


        _success = true;


      });




    }


    catch(e){


      if(!mounted) return;



      setState((){


        _error =
            e.toString();


      });


    }



    finally{


      if(mounted){


        setState((){


          _submitting = false;


        });


      }


    }



  }








  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar:

      AppBar(

        title:

        Text(widget.courseName),

      ),





      body:


      Center(



        child:


        Padding(



          padding:

          const EdgeInsets.all(24),





          child:



          _success

              ?

          _successWidget()

              :

          _formWidget(),



        ),



      ),



    );

  }








  Widget _successWidget(){


    return Column(


      mainAxisSize:

      MainAxisSize.min,



      children:[



        const Icon(

          Icons.check_circle,

          color: Colors.green,

          size:80,

        ),



        const SizedBox(height:20),



        const Text(

          "Attendance Marked!",

          style:

          TextStyle(

            fontSize:24,

            fontWeight:FontWeight.bold,

          ),

        ),



      ],



    );

  }









  Widget _formWidget(){


    return Column(



      mainAxisSize:

      MainAxisSize.min,




      children:[



        Icon(


          _faceVerified

              ?

          Icons.face_retouching_natural

              :

          Icons.face,


          size:70,


          color:

          _faceVerified

              ?

          Colors.green

              :

          Colors.indigo,


        ),





        const SizedBox(height:20),






        FilledButton(


          onPressed:

          _verifyFace,



          child:

          Text(


            _faceVerified

                ?

            "Face Verified ✅"

                :

            "Verify Face",



          ),



        ),






        const SizedBox(height:20),






        TextField(


          controller:

          _codeController,



          keyboardType:

          TextInputType.number,



          maxLength:

          6,



          textAlign:

          TextAlign.center,



          decoration:

          const InputDecoration(


            border:

            OutlineInputBorder(),



            labelText:

            "Enter Code",



          ),



        ),






        if(_error != null)


          Text(


            _error!,


            style:

            const TextStyle(

              color:Colors.red,

            ),



          ),







        const SizedBox(height:20),






        FilledButton(


          onPressed:


          _submitting

              ?

          null

              :

          _submit,




          child:


          _submitting


              ?

          const CircularProgressIndicator()



              :


          const Text(

              "Submit Attendance"

          ),




        ),



      ],



    );


  }




}