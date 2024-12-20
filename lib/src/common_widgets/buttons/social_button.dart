import 'package:flutter/material.dart';
import 'package:scavenger_2/src/common_widgets/buttons/button_loading_widget.dart';
import 'package:scavenger_2/src/constants/image_strings.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    this.isLoading = false,
    required this.text,
    required this.foreground,
    required this.background,
    required this.onPressed,
  });

  final String text;
  final Color foreground, background;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        label: isLoading
            ? const ButtonLoadingWidget()
            : Text(text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: foreground)),
        icon: isLoading
            ? const SizedBox()
            : const Image(
                image: AssetImage(googleLogo1),
                width: 30,
                height: 30,
              ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: foreground,
          backgroundColor: background,
          side: BorderSide.none,
        ),
      ),
    );
  }
}
