import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/common_widgets/controller/theme_controller.dart';
import 'package:scavenger_2/src/common_widgets/loading/loading_widget.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/features/core/controller/profile_controller.dart';
import 'package:scavenger_2/src/features/core/model/user_model.dart';
import 'package:scavenger_2/src/features/core/screen/profile/profile_functions/delete_user.dart';
import 'package:scavenger_2/src/features/core/screen/profile/update_profile_screen.dart';
import 'package:scavenger_2/src/features/core/screen/profile/widgets/profile_menu.dart';
import 'package:scavenger_2/src/repository/authentication_repository/authentication_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    // var isDark =
    //     (MediaQuery.platformBrightnessOf(context) == Brightness.dark).obs;
    final controller = Get.put(ProfileController());

    // void toogleTheme() {
    //   isDark.value = !isDark.value;
    //   Get.changeTheme(isDark.value ? AppTheme.darkTheme : AppTheme.lightTheme);
    // }

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       Get.back();
        //     },
        //     icon: const Icon(LineAwesomeIcons.angle_left_solid)),
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                themeController.toggleTheme();
              },
              icon: Obx(() => Icon(themeController.isDark.value
                  ? LineAwesomeIcons.sun
                  : LineAwesomeIcons.moon))),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(DefaultSize),
          child: Column(
            children: [
              FutureBuilder<UserModel?>(
                future: controller.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: SizedBox(
                      width: double.infinity,
                      height: 254,
                      child: LoadingWidget(),
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text("User data not found"));
                  }

                  UserModel userModel = snapshot.data!;

                  return Container(
                      padding: const EdgeInsets.all(DefaultSize),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 120,
                            width: 120,
                            child: Icon(
                              Icons.person_2_rounded,
                              size: 120,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            userModel.fullName.toUpperCase(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(userModel.email,
                              style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ));
                },
              ),
              // SizedBox(
              //   width: 200,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Get.to(() => const UpdateProfileScreen());
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: PrimaryColor.withOpacity(0.9),
              //       side: BorderSide.none,
              //       shape: const StadiumBorder(),
              //     ),
              //     child: const Text(
              //       "Edit Profile",
              //       // style: TextStyle(color: SecondaryColor),
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 30,
              // ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),

              //Menu
              // ProfileMenuWidget(
              //   title: "Setting",
              //   icon: LineAwesomeIcons.cog_solid,
              //   onPress: () {},
              // ),
              ProfileMenuWidget(
                  title: "Edit Profile",
                  icon: LineAwesomeIcons.edit_solid,
                  onPress: () => Get.to(const UpdateProfileScreen())),
              // ProfileMenuWidget(
              //   title: "Rewards",
              //   icon: LineAwesomeIcons.wallet_solid,
              //   onPress: () {},
              // ),
              // ProfileMenuWidget(
              //   title: "User Managment",
              //   icon: LineAwesomeIcons.user_check_solid,
              //   onPress: () {
              //     // Get.to(() => const ShowAllUsers());
              //   },
              // ),
              const Divider(
                  // color: Colors.grey,
                  ),
              const SizedBox(
                height: 20,
              ),
              ProfileMenuWidget(
                title: "Delete Account",
                icon: LineAwesomeIcons.info_solid,
                onPress: () => Get.to(const DeleteUser()),
              ),
              ProfileMenuWidget(
                title: "Logout",
                textColor: Colors.red,
                endIcon: false,
                icon: LineAwesomeIcons.sign_out_alt_solid,
                onPress: AuthenticationRepository.instance.logOut,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
