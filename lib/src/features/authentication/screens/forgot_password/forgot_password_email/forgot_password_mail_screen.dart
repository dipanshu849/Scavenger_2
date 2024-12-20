import 'package:flutter/material.dart';
import 'package:scavenger_2/src/common_widgets/form/form_header_widget.dart';
import 'package:scavenger_2/src/constants/image_strings.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/constants/text_strings.dart';
import 'package:scavenger_2/src/features/authentication/screens/forgot_password/forgot_password_otp/otp_screen.dart';

class ForgotPasswordMailScreen extends StatelessWidget {
  const ForgotPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(DefaultSize),
            child: Column(
              children: [
                const SizedBox(
                  height: 120,
                ),
                const FormHeaderWidget(
                  image: forgotPasswordImage1,
                  title: forgotPasswordTitle,
                  subtitle: forgotPasswordSubtitle,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                    child: Column(
                  children: [
                    const TextField(
                      decoration: InputDecoration(
                        label: Text("E-Mail"),
                        hintText: "E-Mail",
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const OtpScreen()));
                            },
                            child: const Text("Next")))
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
