import 'package:flutter/material.dart';
// import 'package:scavenger_2/src/constants/image_strings.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/features/authentication/screens/login/login_footer_widget.dart';
import 'package:scavenger_2/src/features/authentication/screens/login/login_form_widget.dart';
import 'package:scavenger_2/src/features/authentication/screens/login/login_header_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(DefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoginHeaderWidget(size: size),
              const SizedBox(
                height: 20,
              ),
              const LoginForm(),
              const LoginFooterWidget()
            ],
          ),
        ),
      ),
    ));
  }
}
