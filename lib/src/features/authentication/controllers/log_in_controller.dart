import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/repository/authentication_repository/authentication_repository.dart';
import 'package:scavenger_2/src/repository/user_repository/user_repository.dart';

class LogInController extends GetxController {
  static LogInController get instance => Get.find<LogInController>();

  final email = TextEditingController();
  final password = TextEditingController();
  final showPassword = false.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final loginFormKey = GlobalKey<FormState>();

  final userRepo = Get.put(UserRepository());

  Future<void> login() async {
    try {
      isLoading.value = true;
      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      final auth = AuthenticationRepository.instance;
      await auth.loginWithEmailAndPassword(
          email.text.trim(), password.text.trim());
      auth.setInitialScreen(auth.firebaseUser);

      // Fetch user details and set in UserController
      dynamic userDetails = await userRepo.getUserByEmail(email.text.trim());
      if (userDetails != null) {
        // UserController.instance.setUser(userDetails);
        // Navigate based on the user's role
        // await AuthHelper.navigateBasedOnUserRole();
      } else {
        Get.snackbar("Error", "User not found.",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5));
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5));
    }
  }

  // Future<void> googleSignIn() async {
  //   try {
  //     isGoogleLoading.value = true;
  //     final auth = AuthenticationRepository.instance;
  //     await auth.signInWithGoogle();
  //     auth.setInitialScreen(auth.firebaseUser);
  //     isGoogleLoading.value = false;
  //   } catch (e) {
  //     isGoogleLoading.value = false;
  //     Get.snackbar("Error", e.toString(),
  //         snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 5));
  //   }
  // }
}
