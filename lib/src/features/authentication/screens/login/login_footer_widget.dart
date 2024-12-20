import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/common_widgets/buttons/social_button.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/features/authentication/controllers/log_in_controller.dart';
import 'package:scavenger_2/src/features/authentication/screens/sign_up/sign_up_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogInController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(
          height: 20,
        ),
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton.icon(
        //       icon: const Image(
        //         image: AssetImage(googleLogo1),
        //         width: 20,
        //       ),
        //       onPressed: () {
        //         controller.googleSignIn();
        //       },
        //       label: const Text("Sign-In Google")),
        // ),
        Obx(
          () => SocialButton(
              text: "Connect With Google",
              foreground: Colors.black,
              background: PrimaryColor.withOpacity(0.4),
              isLoading: controller.isGoogleLoading.value ? true : false,
              onPressed: () {}

              // controller.isLoading.value
              //     ? () {}
              //     : controller.isGoogleLoading.value
              //         ? () {}
              //         : () => controller.googleSignIn()
              ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextButton(
            onPressed: () {
              Get.off(() => const SignUpScreen());
            },
            child: Text.rich(TextSpan(
                text: "Don't have an account?",
                style: Theme.of(context).textTheme.bodyLarge,
                children: const [
                  TextSpan(
                      text: "Sign Up", style: TextStyle(color: Colors.blue))
                ])))
      ],
    );
  }
}
