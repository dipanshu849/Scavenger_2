import 'package:flutter/material.dart';
import 'package:scavenger_2/src/constants/image_strings.dart';
import 'package:scavenger_2/src/constants/text_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          image: const AssetImage(welcomeScreenImage1),
          height: size.height * 0.2,
        ),
        Text(
          LoginTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          LoginSubtitle,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
