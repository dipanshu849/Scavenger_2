import 'package:flutter/material.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/constants/text_strings.dart';
import 'package:scavenger_2/src/features/authentication/screens/forgot_password/forgot_password_email/forgot_password_mail_screen.dart';
import 'package:scavenger_2/src/features/authentication/screens/forgot_password/forgot_password_option/forgot_password_btn_widget.dart';

class ForgotPasswordScreen {
  static PersistentBottomSheetController buildShowBottomSheet(
      BuildContext context, Size size) {
    return showBottomSheet(
        context: context,
        builder: (context) => Container(
              height: size.height * 0.5,
              padding: const EdgeInsets.all(DefaultSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    forgotPasswordTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    forgotPasswordSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ForgetPasswordButtonWidget(
                      btnIcon: Icons.mail_outline_rounded,
                      title: "E-Mail",
                      subTitle: resetViaEmail,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordMailScreen()));
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ForgetPasswordButtonWidget(
                      btnIcon: Icons.mobile_friendly_rounded,
                      title: "Phone Number",
                      subTitle: resetViaPhone,
                      onTap: () {})
                ],
              ),
            ));
  }
}
