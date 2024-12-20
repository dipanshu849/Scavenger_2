import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/repository/authentication_repository/authentication_repository.dart';

class MailVerificationController extends GetxController {
  // static MailVerificationController get instance => Get.find();
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    sendVerificationMail();
    setTimerForAutoRedirect();
  }

  void mannuallyCheckMailVerificationStatus() {
    FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      AuthenticationRepository.instance.setInitialScreen(user);
    }
  }

  Future<void> sendVerificationMail() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
    } catch (e) {
      // Helper.errorSnackBar(co,title: "Snap", message: e.toString());
    }
  }

  void setTimerForAutoRedirect() {
    timer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified) {
        timer.cancel();
        AuthenticationRepository.instance.setInitialScreen(user);
      }
    });
  }
}

class Helper {
  /// Displays an error SnackBar with the given title and message.

  static void errorSnackBar({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    // Create a SnackBar

    final snackBar = SnackBar(
      content: Text('$title: $message'),

      backgroundColor: Colors.red, // Optional: Set background color

      duration: const Duration(seconds: 3), // Optional: Set duration
    );

    // Show the SnackBar using the ScaffoldMessenger

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
