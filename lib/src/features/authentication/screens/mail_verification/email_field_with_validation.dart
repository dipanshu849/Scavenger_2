import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailFieldWithValidation extends StatelessWidget {
  final TextEditingController controller;

  const EmailFieldWithValidation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: "Email",
            hintText: "Enter your email",
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            String email = controller.text.trim();

            // Regex to match emails ending with @students.iitmandi.ac.in or @iitmandi.ac.in
            bool isValidIITMandiEmail =
                RegExp(r'^[a-zA-Z0-9._%+-]+@(students\.)?iitmandi\.ac\.in$')
                    .hasMatch(email);

            if (!isValidIITMandiEmail) {
              // Show error snackbar if email is invalid
              Get.snackbar(
                "Invalid Email",
                "Please enter a valid IIT Mandi email.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            } else {
              // Proceed if email is valid
              Get.snackbar(
                "Valid Email",
                "The email is correct.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
              // Add your next steps here (e.g., form submission)
            }
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
