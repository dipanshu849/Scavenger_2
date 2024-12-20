import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/features/core/model/user_model.dart';
import 'package:scavenger_2/src/features/core/model/worker_model.dart';
import 'package:scavenger_2/src/repository/authentication_repository/authentication_repository.dart';
import 'package:scavenger_2/src/repository/user_repository/user_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find<SignUpController>();
  final controller = Get.put(UserRepository());

  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  var role = ''.obs;
  var messName = 'Oak'.obs;
  final isLoading = false.obs;
  final signupFormKey = GlobalKey<FormState>();

  final userRepo = Get.put(UserRepository());

  void registerUser(String email, String password) {
    AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password);
  }

  void setRole(String selectedRole) {
    role.value = selectedRole;
    if (selectedRole != 'MessWorkers') {
      messName.value = '';
    }
  }

  void setMessName(String selectedMess) {
    messName.value = selectedMess;
  }

  void createUser() async {
    try {
      isLoading.value = true;
      if (!signupFormKey.currentState!.validate()) return;

      String role = this.role.value;
      dynamic user;

      if (role == 'Resident' || role == 'Worker') {
        user = UserModel(
          fullName: fullName.text,
          email: email.text,
          password: password.text,
          role: role,
        );
      }
      // else if (role == 'MessWorkers') {
      //   user = MessWorkerModel(
      //     fullName: fullName.text,
      //     role: role,
      //     messName: messName.value,
      //     email: email.text,
      //     password: password.text,email: email.text,
      //     password: password.text,
      //   );
      // }
      else if (role == 'MessWorkers') {
        // Check if a mess worker for the selected mess already exists
        bool messWorkerExists =
            await controller.checkIfMessWorkerExists(messName.value);

        if (messWorkerExists) {
          Get.snackbar(
            "Error",
            "A worker for ${messName.value} is already registered.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isLoading.value = false;
          return; // Stop registration
        }

        // Proceed with creating the Mess Worker user
        user = MessWorkerModel(
          fullName: fullName.text,
          role: role,
          messName: messName.value,
          email: email.text,
          password: password.text,
        );
      }

      final auth = AuthenticationRepository.instance;
      await auth.createUserWithEmailAndPassword(user.email, user.password);
      await userRepo.createUser(user);
      auth.setInitialScreen(auth.firebaseUser);
    } finally {
      isLoading.value = false;
    }
    // catch (e) {
    //     isLoading.value = false;
    //     Get.snackbar("Error", e.toString(),
    //         snackPosition: SnackPosition.BOTTOM,
    //         backgroundColor: Colors.red,
    //         colorText: Colors.white);
    //   }
  }

  // Future<void> createUser() async {
  //   try {
  //     isLoading.value = true;
  //     if (!signupFormKey.currentState!.validate()) {
  //       isLoading.value = false;
  //       return;
  //     }

  //     final existingUser = await userRepo.getUserByEmail(email.text.trim()); // HERE IS FIRST PROBLEM
  //     if (existingUser != null) {
  //       isLoading.value = false;
  //       Get.snackbar("User Exists", "This email is already registered.",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.red,
  //           colorText: Colors.white);
  //       return;
  //     }

  //     final user = UserModel(   // HERE IS SECOND  PROBLEM
  //       fullName: fullName.text.trim(),
  //       email: email.text.trim(),
  //       password: password.text.trim(),
  //       role: role.value,
  //     );

  //     final auth = AuthenticationRepository.instance;
  //     await auth.createUserWithEmailAndPassword(user.email, user.password);
  //     await userRepo.createUser(user, auth.auth);
  //     auth.setInitialScreen(auth.firebaseUser);

  //     isLoading.value = false;
  //   }
}
