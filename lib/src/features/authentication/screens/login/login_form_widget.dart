import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/common_widgets/buttons/button_loading_widget.dart';
import 'package:scavenger_2/src/features/authentication/controllers/log_in_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogInController());
    final Size size = MediaQuery.sizeOf(context);
    final obscurePassword = true.obs;
    return Form(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Form(
        key: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.email,
              // autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: "Email",
                hintText: "Enter your email",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => TextFormField(
                  controller: controller.password,
                  obscureText: obscurePassword.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.fingerprint),
                    labelText: "Password",
                    hintText: "Enter your password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // Toggle password visibility
                        obscurePassword.value = !obscurePassword.value;
                      },
                      icon: Icon(obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                )),

            const SizedBox(
              height: 20,
            ),

            // Align(
            //   alignment: Alignment.centerRight,
            //   child: TextButton(
            //       onPressed: () {
            //         ForgotPasswordScreen.buildShowBottomSheet(context, size);
            //       },
            //       child: const Text("Forgot Password?")),
            // ),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? () {}
                      : () => controller.login(),
                  child: controller.isLoading.value
                      ? const ButtonLoadingWidget()
                      : Text("LOGIN",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .apply(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
