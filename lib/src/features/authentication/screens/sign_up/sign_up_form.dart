import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/common_widgets/buttons/button_loading_widget.dart';
import 'package:scavenger_2/src/features/authentication/controllers/sign_up_controller.dart';

class SignUpForm extends StatelessWidget {
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    final obscurePassword = true.obs;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: controller.signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.fullName,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: "Full Name",
                hintText: "Enter your full name",
                prefixIcon: Icon(Icons.person_outline_rounded),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => TextField(
                  controller: controller.password,
                  obscureText: obscurePassword.value,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                    prefixIcon: const Icon(Icons.fingerprint),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        obscurePassword.value = !obscurePassword.value;
                      },
                      icon: Icon(obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            // Role Selection
            const Text("Select Role:"),
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio<String>(
                          value: 'Resident',
                          groupValue: controller.role.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.setRole(value);
                            }
                          },
                        ),
                        const Text('Resident'),
                        Radio<String>(
                          value: 'Worker',
                          groupValue: controller.role.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.setRole(value);
                            }
                          },
                        ),
                        const Text('Worker'),
                        Radio<String>(
                          value: 'MessWorkers',
                          groupValue: controller.role.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.setRole(value);
                            }
                          },
                        ),
                        const Text('Mess Workers'),
                      ],
                    ),

                    // Show dropdown menu for Mess Worker role
                    if (controller.role.value == 'MessWorkers')
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Select Mess:"),
                              Obx(() => DropdownButton<String>(
                                    value: controller.messName.value.isNotEmpty
                                        ? controller.messName.value
                                        : null, // Handle null case
                                    hint: const Text("Select Mess"),
                                    items: ['Oak', 'Pine', 'Alder', 'Peepal']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        controller.setMessName(newValue);
                                      }
                                    },
                                  )),
                            ]),
                      ),
                  ],
                )),

            // Obx(() => Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Radio<String>(
            //           value: 'Resident',
            //           groupValue: controller.role.value,
            //           onChanged: (value) {
            //             if (value != null) {
            //               controller.setRole(value);
            //             }
            //           },
            //         ),
            //         const Text('Resident'),
            //         Radio<String>(
            //           value: 'Worker',
            //           groupValue: controller.role.value,
            //           onChanged: (value) {
            //             if (value != null) {
            //               controller.setRole(value);
            //             }
            //           },
            //         ),
            //         const Text('Worker'),
            //       ],
            //     )),

            const SizedBox(height: 20),
            Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            String email = controller.email.text.trim();
                            print("reached Here");
                            bool isValidIITMandiEmail = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@(students\.)?iitmandi\.ac\.in$')
                                .hasMatch(email);
                            if (!isValidIITMandiEmail) {
                              Get.snackbar(
                                "Invalid Email",
                                "Please enter a valid IIT Mandi email.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } else if (controller.role.value.isEmpty) {
                              // Show error if no role is selected
                              Get.snackbar(
                                "Role Required",
                                "Please select your role (Resident or Worker).",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } else {
                              print("ALSO here");
                              controller.createUser();
                            }
                          },
                    child: controller.isLoading.value
                        ? const ButtonLoadingWidget()
                        : const Text("SIGN UP"))))
          ],
        ),
      ),
    );
  }
}
