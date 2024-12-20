import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/constants/text_strings.dart';
// import 'package:scavenger_2/src/features/authentication/controllers/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var otp;
    // var otpController = Get.put(OtpController());
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                otpTitle,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 80),
              ),
              Text(
                otpSubtitle.toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                "${otpMessge}Mail@written.Before",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              OtpTextField(
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                onSubmit: (code) {
                  // otp = code;
                  // OtpController.instance.verifyOTP(otp);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        // otpController.verifyOTP(otp);
                      },
                      child: const Text("Next")))
            ],
          ),
        ),
      ),
    ));
  }
}
