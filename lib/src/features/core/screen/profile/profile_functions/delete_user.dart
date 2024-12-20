import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/features/core/controller/profile_controller.dart';
import 'package:scavenger_2/src/features/core/model/user_model.dart';
import 'package:scavenger_2/src/repository/authentication_repository/authentication_repository.dart';

class DeleteUser extends StatelessWidget {
  const DeleteUser({super.key});

  @override
  Widget build(BuildContext context) {
    var passwordController = TextEditingController();
    final passwordTrue = false.obs;
    final controller = Get.put(ProfileController());

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(LineAwesomeIcons.angle_left_solid)),
              title: const Text(
                "Delete Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
            ),
            body: FutureBuilder<UserModel?>(
              future: controller.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("User data not found"));
                }

                UserModel userModel = snapshot.data!;

                return Container(
                    padding: const EdgeInsets.all(DefaultSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter password to proceed:",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              label: Text("Enter Password"),
                              prefixIcon: Icon(Icons.fingerprint_rounded)),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (passwordController.text ==
                                      userModel.password) {
                                    passwordTrue.value = true;

                                    // Fetch the UID from FirebaseAuth
                                    final userUID =
                                        FirebaseAuth.instance.currentUser?.uid;

                                    if (userUID != null) {
                                      AuthenticationRepository.instance
                                          .deleteUser(
                                              passwordController.text, userUID);
                                    } else {
                                      Get.snackbar(
                                          "Error", "User not authenticated.");
                                    }
                                  } else {
                                    Get.snackbar("Error", "Incorrect Password");
                                  }
                                },
                                child: const Text("Submit")))
                      ],
                    ));
              },
            )));
  }
}
