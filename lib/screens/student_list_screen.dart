import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentListScreen extends StatelessWidget{
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:const Text("Student List"),
      ),
      body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream:FirebaseFirestore.instance
            .collection('users')
            .where('role',isEqualTo:'student')
            .orderBy('name')
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
              child:Text("No Students Found"),
            );
          }

          return ListView.builder(
            itemCount:docs.length,
            itemBuilder:(context,index){
              final data=docs[index].data();

              return Card(
                margin:const EdgeInsets.symmetric(
                  horizontal:10,
                  vertical:5,
                ),
                child:ListTile(
                  leading:CircleAvatar(
                    child:Text(
                      (data['name']??'S')
                          .toString()
                          .substring(0,1)
                          .toUpperCase(),
                    ),
                  ),
                  title:Text(data['name']??"Unknown"),
                  subtitle:Text(data['email']??""),
                  trailing:const Icon(
                    Icons.verified_user,
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