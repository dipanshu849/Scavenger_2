import 'package:flutter/material.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/constants/image_strings.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/constants/text_strings.dart';
import 'package:scavenger_2/src/features/authentication/screens/login/login_screen.dart';
import 'package:scavenger_2/src/features/authentication/screens/sign_up/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var brightness = MediaQuery.of(context).platformBrightness;
    final Size size = MediaQuery.sizeOf(context);
    // var isDarkMode = brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: isDarkMode ? SecondaryColor : PrimaryColor,
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [PrimaryColor, Colors.white38],
          )),
          padding: const EdgeInsets.all(DefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage(welcomeScreenImage1),
                height: size.height * 0.6,
              ),
              Column(
                children: [
                  Text(WelcomeTitle,
                      style: Theme.of(context).textTheme.headlineLarge),
                  Text(
                    WelcomeSubTitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text("Login"))),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text("Sign Up")))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
