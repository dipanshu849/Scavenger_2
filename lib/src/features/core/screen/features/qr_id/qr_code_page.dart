import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/common_widgets/loading/loading_widget.dart';
import 'package:scavenger_2/src/features/core/model/user_model.dart';
import 'package:scavenger_2/src/features/core/screen/features/qr_id/qr_code.dart';
import 'package:scavenger_2/src/repository/authentication_repository/authentication_repository.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tag ID",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<UserModel?>(
        future: AuthenticationRepository.instance.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          } else if (snapshot.hasError || snapshot.data == null) {
            // Use addPostFrameCallback to show snackbar after build is complete
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.snackbar("Error", "User  data not found.");
            });
            return const Center(child: Text('User  data not found.'));
          } else {
            // final user = snapshot.data!;
            final userUID = FirebaseAuth.instance.currentUser?.uid;
            return QRCodeViewWidget(userId: userUID ?? '');
          }
        },
      ),
    );
  }
}
