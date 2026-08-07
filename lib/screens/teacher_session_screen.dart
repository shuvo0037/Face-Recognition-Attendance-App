import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/session_service.dart';


class TeacherSessionScreen extends StatefulWidget {

  final String sessionId;
  final String courseName;


  const TeacherSessionScreen({
    super.key,
    required this.sessionId,
    required this.courseName,
  });


  @override
  State<TeacherSessionScreen> createState() =>
      _TeacherSessionScreenState();

}



class _TeacherSessionScreenState
    extends State<TeacherSessionScreen> {


  final SessionService _sessionService =
  SessionService();


  Timer? _rotationTimer;


  bool _ending = false;



  @override
  void initState() {
    super.initState();


    // Generate new code immediately
    _sessionService.rotateCode(widget.sessionId);


    _rotationTimer = Timer.periodic(
      const Duration(
        seconds: kCodeValiditySeconds,
      ),
          (_) async {

        try {

          await _sessionService
              .rotateCode(widget.sessionId);


        } catch(e){

          debugPrint(
            "Code rotation error: $e",
          );

        }

      },
    );

  }




  @override
  void dispose() {

    _rotationTimer?.cancel();

    super.dispose();

  }





  Future<void> _endSession() async {


    if(_ending) return;


    final confirm =
    await showDialog<bool>(
      context: context,
      builder: (context){

        return AlertDialog(

          title:
          const Text(
            "End session?",
          ),


          content:
          const Text(
            "Students cannot submit attendance anymore.",
          ),


          actions:[


            TextButton(
              onPressed: (){
                Navigator.pop(
                  context,
                  false,
                );
              },
              child:
              const Text(
                "Cancel",
              ),
            ),



            FilledButton(
              onPressed: (){
                Navigator.pop(
                  context,
                  true,
                );
              },
              child:
              const Text(
                "End",
              ),
            )

          ],

        );

      },
    );



    if(confirm != true){
      return;
    }



    setState(() {
      _ending = true;
    });



    try {


      _rotationTimer?.cancel();


      await _sessionService
          .endSession(
        widget.sessionId,
      );



      if(mounted){

        Navigator.pop(context);

      }



    }catch(e){


      if(mounted){

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


    }


  }






  @override
  Widget build(BuildContext context) {


    return PopScope(

      canPop: false,


      onPopInvokedWithResult:
          (didPop,result) async {

        if(!didPop){

          await _endSession();

        }

      },


      child: Scaffold(


        appBar: AppBar(

          title:
          Text(
            widget.courseName,
          ),



          actions:[


            TextButton.icon(

              onPressed:
              _endSession,


              icon:
              const Icon(
                Icons.stop_circle,
                color: Colors.white,
              ),


              label:
              const Text(
                "End",
                style:
                TextStyle(
                  color: Colors.white,
                ),
              ),

            )


          ],

        ),




        body: Column(

          children:[


            _CodeDisplay(

              sessionId:
              widget.sessionId,

              sessionService:
              _sessionService,

            ),



            const Divider(),




            Expanded(

              child:
              _AttendeeList(

                sessionId:
                widget.sessionId,


                sessionService:
                _sessionService,

              ),

            )


          ],

        ),

      ),

    );


  }

}







class _CodeDisplay extends StatelessWidget {


  final String sessionId;

  final SessionService sessionService;



  const _CodeDisplay({

    required this.sessionId,

    required this.sessionService,

  });




  @override
  Widget build(BuildContext context){


    return StreamBuilder<

        DocumentSnapshot<Map<String,dynamic>>

    >(


      stream:
      sessionService
          .sessionStream(
        sessionId,
      ),



      builder:(context,snapshot){


        if(snapshot.hasError){

          return const Center(
            child:
            Text(
              "Failed loading code",
            ),
          );

        }



        final code =
            snapshot.data
                ?.data()?['code']
                ??
                "------";



        return Container(

          width:
          double.infinity,


          padding:
          const EdgeInsets.symmetric(
            vertical:30,
          ),



          child:
          Column(

            children:[


              const Text(
                "CURRENT CODE",
                style:
                TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  letterSpacing:2,
                ),
              ),



              const SizedBox(
                height:10,
              ),



              Text(

                code,

                style:
                const TextStyle(

                  fontSize:60,

                  fontWeight:
                  FontWeight.bold,

                  letterSpacing:8,

                ),

              ),



              Text(

                "Changes every $kCodeValiditySeconds seconds",

              )


            ],

          ),

        );


      },

    );

  }

}







class _AttendeeList extends StatelessWidget {


  final String sessionId;

  final SessionService sessionService;



  const _AttendeeList({

    required this.sessionId,

    required this.sessionService,

  });




  @override
  Widget build(BuildContext context){


    return StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(


      stream:
      sessionService
          .attendanceStream(
        sessionId,
      ),



      builder:(context,snapshot){



        if(snapshot.hasError){

          return const Center(
            child:
            Text(
              "Attendance loading failed",
            ),
          );

        }



        final docs =
            snapshot.data?.docs
                ??
                [];



        if(docs.isEmpty){

          return const Center(
            child:
            Text(
              "No check-ins yet",
            ),
          );

        }



        return ListView.builder(

          itemCount:
          docs.length,


          itemBuilder:(context,index){


            final data =
            docs[index].data();



            return ListTile(

              leading:
              const Icon(
                Icons.check_circle,
                color:
                Colors.green,
              ),



              title:
              Text(
                data['studentName']
                    ??
                    "Unknown",
              ),

            );


          },

        );


      },

    );


  }

}