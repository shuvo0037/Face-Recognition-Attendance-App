import 'package:flutter/material.dart';

class RegisterFaceScreen extends StatefulWidget {
  const RegisterFaceScreen({super.key});

  @override
  State<RegisterFaceScreen> createState() => _RegisterFaceScreenState();
}

class _RegisterFaceScreenState extends State<RegisterFaceScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Registration"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Student Name",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: "Student ID",
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {

                },
                child: const Text("Register Face"),
              ),
            )

          ],
        ),
      ),
    );
  }
}