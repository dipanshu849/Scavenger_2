import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/constants/text_strings.dart';
import 'package:scavenger_2/src/features/authentication/screens/login/login_screen.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("OR"),
          const SizedBox(
            height: 10,
          ),
          // SizedBox(
          //   width: double.infinity,
          //   child: OutlinedButton.icon(
          //     onPressed: () {},
          //     icon: const Image(
          //       image: AssetImage(googleLogo1),
          //       width: 20,
          //     ),
          //     label: Text(signInWithGoogle.toUpperCase()),
          //   ),
          // ),
          TextButton(
              onPressed: () {
                Get.off(() => const LoginScreen());
              },
              child: Text.rich(TextSpan(
                  text: alreadyHaveAnAccount,
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: const [
                    TextSpan(text: login, style: TextStyle(color: Colors.blue)),
                  ])))
        ],
      ),
    );
  }
}
