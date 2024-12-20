import 'package:flutter/material.dart';
import 'package:scavenger_2/src/common_widgets/form/form_header_widget.dart';
import 'package:scavenger_2/src/constants/image_strings.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/constants/text_strings.dart';
import 'package:scavenger_2/src/features/authentication/screens/sign_up/sign_up_footer.dart';
import 'package:scavenger_2/src/features/authentication/screens/sign_up/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(DefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FormHeaderWidget(
                    image: welcomeScreenImage2,
                    title: singUpTitle,
                    subtitle: singUpSubTitle),
                const SizedBox(
                  height: 20,
                ),
                SignUpForm(),
                const SignUpFooter()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
