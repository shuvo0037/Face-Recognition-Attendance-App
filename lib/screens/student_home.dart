import 'package:flutter/material.dart';
import 'face_registration.dart';

class StudentHome extends StatelessWidget {
  const StudentHome({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Student Dashboard"),
      ),

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.school,
              size: 80,
              color: Colors.indigo,
            ),

            const SizedBox(height:20),


            const Text(
              "Welcome Student",
              style: TextStyle(
                fontSize:24,
                fontWeight: FontWeight.bold
              ),
            ),


            const SizedBox(height:40),


            ElevatedButton.icon(

              icon: const Icon(Icons.face),

              label: const Text(
                "Register Face"
              ),

              onPressed: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(context)=> 
                    const FaceRegistration()
                  ),
                );

              },

            ),


            const SizedBox(height:20),


            ElevatedButton.icon(

              icon: const Icon(Icons.history),

              label: const Text(
                "My Attendance"
              ),

              onPressed: (){},

            ),

          ],
        ),

      ),

    );
  }
}