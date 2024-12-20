import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/constants/text_strings.dart';
import 'package:scavenger_2/src/features/authentication/controllers/mail_verification_controller.dart';
import 'package:scavenger_2/src/repository/authentication_repository/authentication_repository.dart';

class MailVerification extends StatelessWidget {
  const MailVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MailVerificationController());
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 5 * DefaultSize,
              left: DefaultSize,
              right: DefaultSize,
              bottom: DefaultSize * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LineAwesomeIcons.envelope_open_solid, size: 100),
              const SizedBox(
                height: DefaultSize,
              ),
              Text(emailVerificationTitle,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(
                height: DefaultSize,
              ),
              const Text(
                emailVerificationSubTitle1,
                // style: Theme.of(context).textTheme.bodyLarge,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                emailVerificationSubTitle2,
                // style: Theme.of(context).textTheme.bodyMedium,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: OutlinedButton(
                    onPressed: () =>
                        controller.mannuallyCheckMailVerificationStatus(),
                    child: const Text(
                      "Continue",
                    )),
              ),
              const SizedBox(
                height: DefaultSize * 2,
              ),
              TextButton(
                  onPressed: () => controller.sendVerificationMail(),
                  child: const Text('Resend email link')),
              TextButton(
                  onPressed: () => AuthenticationRepository.instance.logOut(),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LineAwesomeIcons.long_arrow_alt_left_solid),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Back to login")
                    ],
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
