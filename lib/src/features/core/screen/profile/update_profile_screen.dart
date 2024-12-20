import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/common_widgets/loading/loading_widget.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/features/core/controller/profile_controller.dart';
import 'package:scavenger_2/src/features/core/model/user_model.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final Size size = MediaQuery.sizeOf(context);
    // var isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(DefaultSize),
            child: FutureBuilder(
              future: controller.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel userModel = snapshot.data as UserModel;
                    final email = TextEditingController(text: userModel.email);
                    final password =
                        TextEditingController(text: userModel.password);
                    final fullName =
                        TextEditingController(text: userModel.fullName);
                    // final id = TextEditingController(text: userModel.id);
                    return Column(
                      children: [
                        const Stack(
                          children: [
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: Icon(
                                Icons.person_2_rounded,
                                size: 120,
                              ),
                            ),
                            // Positioned(
                            //   bottom: 0,
                            //   right: 0,
                            //   child: Container(
                            //     width: 35,
                            //     height: 35,
                            //     decoration: BoxDecoration(
                            //         color: PrimaryColor,
                            //         borderRadius: BorderRadius.circular(100)),
                            //     child: const Icon(
                            //       LineAwesomeIcons.pencil_alt_solid,
                            //       color: Colors.white,
                            //       size: 23,
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                        Form(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            TextFormField(
                              controller: fullName,
                              // initialValue: userModel.fullName,
                              decoration: const InputDecoration(
                                  label: Text("Full Name"),
                                  prefixIcon:
                                      Icon(Icons.person_outline_rounded)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: email,
                              // initialValue: userModel.email,
                              decoration: const InputDecoration(
                                  label: Text("Email"),
                                  prefixIcon: Icon(Icons.email_outlined)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: password,
                              // initialValue: userModel.password,
                              decoration: const InputDecoration(
                                  label: Text("Password"),
                                  prefixIcon: Icon(Icons.fingerprint)),
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // TextFormField(
                            //   initialValue: userModel.phone,
                            //   decoration: const InputDecoration(
                            //       label: Text("Phone Number"),
                            //       prefixIcon: Icon(Icons.fingerprint)),
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                            // Align(
                            //   alignment: Alignment.center,
                            //   child: SizedBox(
                            //       width: size.width / 2,
                            //       child: ElevatedButton(
                            //           onPressed: () async {
                            //             final userData = UserModel(
                            //                 fullName: fullName.text.trim(),
                            //                 email: email.text.trim(),
                            //                 password: password.text.trim());
                            //             await controller.updateRecord(userData);
                            //           },
                            //           child: const Text("EDIT"))),
                            // )
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: size.width / 2,
                                child: _isLoading
                                    ? const LoadingWidget() // Show loading indicator

                                    : ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true; // Start loading
                                          });

                                          final userData = UserModel(
                                            fullName: fullName.text.trim(),
                                            email: email.text.trim(),
                                            password: password.text.trim(),
                                            // id: id.text,
                                            role: "ROLE",
                                          );

                                          await controller
                                              .updateRecord(userData);

                                          setState(() {
                                            _isLoading = false; // Stop loading
                                          });
                                        },
                                        child: const Text("EDIT"),
                                      ),
                              ),
                            )
                          ],
                        )),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return const Center(child: Text("Something went wrong"));
                  }
                } else {
                  return const Center(
                    child: LoadingWidget(),
                  );
                }
              },
            )),
      ),
    ));
  }
}
