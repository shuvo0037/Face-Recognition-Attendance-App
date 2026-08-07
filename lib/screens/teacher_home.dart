import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/session_service.dart';
import 'teacher_session_screen.dart';


class TeacherHome extends StatefulWidget {

  const TeacherHome({super.key});


  @override
  State<TeacherHome> createState() =>
      _TeacherHomeState();

}



class _TeacherHomeState extends State<TeacherHome> {


  final SessionService _sessionService =
  SessionService();


  bool loading = false;



  Future<void> startAttendance() async {


    setState(() {
      loading = true;
    });



    try {


      final user =
          FirebaseAuth.instance.currentUser;



      if(user == null){

        throw Exception(
            "Teacher not logged in"
        );

      }



      final sessionId =
      await _sessionService.createSession(

        teacherId: user.uid,

        courseName: "SWE",

      );



      if(!mounted) return;



      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) =>
              TeacherSessionScreen(

                sessionId: sessionId,

                courseName: "SWE",

              ),

        ),

      );



    }catch(e){


      if(!mounted) return;


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
            e.toString(),
          ),

        ),

      );


    }



    if(mounted){

      setState(() {

        loading = false;

      });

    }


  }






  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title:
        const Text(
          "Teacher Dashboard",
        ),

      ),



      body:
      Center(

        child:
        Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[



            const Icon(

              Icons.person,

              size:80,

              color:Colors.indigo,

            ),



            const SizedBox(
              height:20,
            ),




            const Text(

              "Welcome Teacher",

              style:
              TextStyle(

                fontSize:24,

                fontWeight:
                FontWeight.bold,

              ),

            ),




            const SizedBox(
              height:40,
            ),




            ElevatedButton.icon(


              icon:
              const Icon(
                Icons.play_arrow,
              ),



              label:
              loading

                  ?

              const SizedBox(

                width:20,

                height:20,

                child:
                CircularProgressIndicator(

                  strokeWidth:2,

                ),

              )

                  :

              const Text(
                "Start Attendance",
              ),





              onPressed:
              loading
                  ?
              null
                  :
              startAttendance,



            ),



          ],

        ),

      ),

    );


  }

}