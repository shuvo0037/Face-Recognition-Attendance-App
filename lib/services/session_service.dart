import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

const int kCodeValiditySeconds = 30;

class SessionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _sessions =>
      _db.collection('sessions');

  CollectionReference<Map<String, dynamic>> get _attendance =>
      _db.collection('attendance');


  String _generateCode() {
    final random = Random.secure();

    return List.generate(
      6,
          (_) => random.nextInt(10),
    ).join();
  }


  Future<String> createSession({
    required String teacherId,
    required String courseName,
  }) async {

    if (teacherId.trim().isEmpty) {
      throw SessionException("Teacher id missing.");
    }

    if (courseName.trim().isEmpty) {
      throw SessionException("Course name required.");
    }


    try {

      final doc = await _sessions.add({

        'courseName': courseName.trim(),

        'teacherId': teacherId,

        'active': true,

        'code': _generateCode(),

        'codeSetAt':
        FieldValue.serverTimestamp(),

        'createdAt':
        FieldValue.serverTimestamp(),


        // Future face attendance support
        'faceVerificationRequired': false,

      });


      return doc.id;


    } catch(e){

      throw SessionException(
          "Failed to create session."
      );

    }
  }



  Future<void> rotateCode(String sessionId) async {

    try {

      final snapshot =
      await _sessions.doc(sessionId).get();


      if(!snapshot.exists){
        throw SessionException(
            "Session not found."
        );
      }


      if(snapshot.data()?['active'] != true){
        return;
      }


      await _sessions.doc(sessionId).update({

        'code': _generateCode(),

        'codeSetAt':
        FieldValue.serverTimestamp(),

      });


    }catch(e){

      throw SessionException(
          "Code rotation failed."
      );

    }
  }



  Future<void> endSession(String sessionId) async {

    try {

      await _sessions.doc(sessionId).update({

        'active': false,

        'endedAt':
        FieldValue.serverTimestamp(),

      });


    }catch(e){

      throw SessionException(
          "Unable to end session."
      );

    }

  }



  Stream<DocumentSnapshot<Map<String,dynamic>>> sessionStream(
      String sessionId){

    return _sessions
        .doc(sessionId)
        .snapshots();

  }



  Stream<QuerySnapshot<Map<String,dynamic>>> attendanceStream(
      String sessionId){

    return _attendance
        .where(
      'sessionId',
      isEqualTo: sessionId,
    )
        .orderBy(
      'timestamp',
      descending: true,
    )
        .snapshots();

  }



  // Stream<QuerySnapshot<Map<String,dynamic>>> activeSessionsStream(){
  //
  //   return _sessions
  //       .where(
  //     'active',
  //     isEqualTo: true,
  //   )
  //       .orderBy(
  //     'createdAt',
  //     descending: true,
  //   )
  //       .snapshots();
  //
  // }

  Stream<QuerySnapshot<Map<String,dynamic>>> activeSessionsStream(){

    return _sessions
        .where(
      'active',
      isEqualTo: true,
    )
        .snapshots();

  }




  Future<void> submitAttendance({

    required String sessionId,

    required String studentId,

    required String studentName,

    required String enteredCode,

  }) async {


    if(enteredCode.trim().isEmpty){

      throw SessionException(
          "Enter code first."
      );

    }



    try {


      final sessionSnap =
      await _sessions
          .doc(sessionId)
          .get();



      if(!sessionSnap.exists){

        throw SessionException(
            "Session not found."
        );

      }



      final session =
      sessionSnap.data()!;



      if(session['active'] != true){

        throw SessionException(
            "Session ended."
        );

      }




      final Timestamp? timestamp =
      session['codeSetAt'];



      if(timestamp == null){

        throw SessionException(
            "Code not ready."
        );

      }



      final difference =
          DateTime.now()
              .difference(
            timestamp.toDate(),
          )
              .inSeconds;



      if(difference >
          kCodeValiditySeconds + 2){

        throw SessionException(
            "Code expired."
        );

      }




      if(
      enteredCode.trim()
          !=
          session['code']
      ){

        throw SessionException(
            "Wrong code."
        );

      }




      final existing =
      await _attendance
          .where(
        'sessionId',
        isEqualTo: sessionId,
      )
          .where(
        'studentId',
        isEqualTo: studentId,
      )
          .limit(1)
          .get();



      if(existing.docs.isNotEmpty){

        throw SessionException(
            "Attendance already submitted."
        );

      }




      await _attendance.add({

        'sessionId': sessionId,

        'courseName':
        session['courseName'],

        'studentId':
        studentId,

        'studentName':
        studentName,


        'timestamp':
        FieldValue.serverTimestamp(),


        // Future face recognition
        'verifiedByFace':
        false,

      });



    }catch(e){

      if(e is SessionException){
        rethrow;
      }


      throw SessionException(
          "Attendance failed."
      );

    }

  }

}



class SessionException implements Exception{

  final String message;


  SessionException(this.message);



  @override
  String toString()=>message;

}