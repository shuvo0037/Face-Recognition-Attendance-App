import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatelessWidget{
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:const Text("Attendance History"),
      ),
      body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream:FirebaseFirestore.instance
            .collection("attendance")
            .orderBy("timestamp",descending:true)
            .snapshots(),
        builder:(context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(
              child:CircularProgressIndicator(),
            );
          }

          if(snapshot.hasError){
            return Center(
              child:Text(snapshot.error.toString()),
            );
          }

          final docs=snapshot.data?.docs??[];

          if(docs.isEmpty){
            return const Center(
              child:Text(
                "No Attendance Found",
                style:TextStyle(fontSize:18),
              ),
            );
          }

          return ListView.builder(
            padding:const EdgeInsets.all(10),
            itemCount:docs.length,
            itemBuilder:(context,index){
              final data=docs[index].data();

              final Timestamp? ts=data["timestamp"] as Timestamp?;
              final DateTime? dt=ts?.toDate();

              String date="-";

              if(dt!=null){
                date="${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
              }

              return Card(
                elevation:3,
                child:ListTile(
                  leading:const CircleAvatar(
                    child:Icon(Icons.person),
                  ),
                  title:Text(data["studentName"]??"Unknown"),
                  subtitle:Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:[
                      Text("Course : ${data["courseName"]??"-"}"),
                      Text("Student ID : ${data["studentId"]??"-"}"),
                      Text("Time : $date"),
                    ],
                  ),
                  trailing:const Icon(
                    Icons.check_circle,
                    color:Colors.green,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}