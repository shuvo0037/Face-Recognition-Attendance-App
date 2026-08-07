import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import 'attendance_history_screen.dart';
import 'register_student_screen.dart';
import 'student_list_screen.dart';
import 'teacher_session_screen.dart';

class TeacherHomeScreen extends StatefulWidget{
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState()=>_TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen>{
final AuthService _auth=AuthService();
final SessionService _sessionService=SessionService();

Widget buildButton(
String title,
IconData icon,
Color color,
VoidCallback onTap,
){
return SizedBox(
width:double.infinity,
height:60,
child:ElevatedButton.icon(
style:ElevatedButton.styleFrom(
backgroundColor:color,
foregroundColor:Colors.white,
),
onPressed:onTap,
icon:Icon(icon),
label:Text(
title,
style:const TextStyle(fontSize:18),
),
),
);
}

Future<void> startSession()async{
final controller=TextEditingController();

final course=await showDialog<String>(
context:context,
builder:(context){
return AlertDialog(
title:const Text("Course Name"),
content:TextField(
controller:controller,
decoration:const InputDecoration(
border:OutlineInputBorder(),
),
),
actions:[
TextButton(
onPressed:(){
Navigator.pop(context);
},
child:const Text("Cancel"),
),
FilledButton(
onPressed:(){
Navigator.pop(
context,
controller.text.trim(),
);
},
child:const Text("Start"),
)
],
);
},
);

if(course==null||course.isEmpty){
return;
}

try{
final user=_auth.currentUser;

if(user==null){
throw Exception("Teacher not found");
}

final sessionId=
await _sessionService.createSession(
teacherId:user.uid,
courseName:course,
);

if(!mounted)return;

Navigator.push(
context,
MaterialPageRoute(
builder:(_)=>TeacherSessionScreen(
sessionId:sessionId,
courseName:course,
),
),
);
}catch(e){
if(!mounted)return;
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content:Text(e.toString())),
);
}
}
@override
Widget build(BuildContext context){
  return Scaffold(
    appBar:AppBar(
      title:const Text("Face Attendance System"),
      centerTitle:true,
      actions:[
        IconButton(
          onPressed:(){
            _auth.signOut();
          },
          icon:const Icon(Icons.logout),
        )
      ],
    ),
    body:Padding(
      padding:const EdgeInsets.all(20),
      child:ListView(
        children:[
          const SizedBox(height:20),
          const Icon(
            Icons.face,
            size:100,
            color:Colors.blue,
          ),
          const SizedBox(height:20),
          const Center(
            child:Text(
              "Teacher Dashboard",
              style:TextStyle(
                fontSize:28,
                fontWeight:FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height:40),
          buildButton(
            "Start Attendance Session",
            Icons.play_circle_fill,
            Colors.red,
            startSession,
          ),
          const SizedBox(height:15),
          buildButton(
            "Register Student",
            Icons.person_add,
            Colors.green,
                (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(_)=>const RegisterStudentScreen(),
                ),
              );
            },
          ),
          const SizedBox(height:15),
          buildButton(
            "Student List",
            Icons.people,
            Colors.purple,
                (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(_)=>const StudentListScreen(),
                ),
              );
            },
          ),
          const SizedBox(height:15),
          buildButton(
            "Attendance History",
            Icons.history,
            Colors.orange,
                (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(_)=>const AttendanceHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}
}