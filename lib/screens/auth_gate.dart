import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';
import 'student_home.dart';
import 'teacher_home.dart';


class AuthGate extends StatelessWidget {

  const AuthGate({super.key});


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(

      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {


        if(snapshot.connectionState ==
            ConnectionState.waiting){

          return const Scaffold(
            body: Center(
              child:CircularProgressIndicator(),
            ),
          );

        }


        if(!snapshot.hasData){

          return const LoginScreen();

        }


        final uid =
            snapshot.data!.uid;


        return FutureBuilder<DocumentSnapshot>(

          future: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get(),


          builder:(context, userSnapshot){


            if(!userSnapshot.hasData){

              return const Scaffold(
                body:Center(
                  child:CircularProgressIndicator(),
                ),
              );

            }


            final data =
            userSnapshot.data!.data()
            as Map<String,dynamic>;


            if(data['role']=="teacher"){

              return const TeacherHome();

            }


            else{

              return const StudentHome();

            }


          },


        );


      },


    );

  }

}