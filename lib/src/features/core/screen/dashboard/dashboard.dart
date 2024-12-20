import 'package:flutter/material.dart';
import 'package:scavenger_2/src/features/core/screen/homeScreen/home_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      // appBar: AppBar(
      //   // leading: const Icon(
      //   //   LineAwesomeIcons.home_solid,
      //   //   color: Colors.black,
      //   // ),
      //   title: const Text(
      //     "HOME",
      //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      //   ),
      //   //   backgroundColor: LinearGradient(
      //   //   begin: Alignment.topCenter,
      //   //   end: Alignment.bottomCenter,
      //   //   colors: [PrimaryColor, Colors.white38],
      //   // ),
      //   // deco
      //   // centerTitle: true,

      //   actions: [
      //     IconButton(
      //       icon: const Icon(
      //         LineAwesomeIcons.bell,
      //         size: 28,
      //       ),
      //       onPressed: () {
      //         // Functionality for notifications
      //       },
      //     ),
      //     Container(
      //       margin: const EdgeInsets.only(right: 20, top: 7),
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(10),
      //         color: PrimaryColor.withOpacity(0.3),
      //       ),
      //       child: IconButton(
      //           onPressed: () {
      //             // AuthenticationRepository.instance.logOut();
      //             Get.to(const ProfileScreen());
      //           },
      //           icon: const Icon(
      //             Icons.person_2_sharp,
      //             size: 28,
      //           )),
      //     )
      //   ],
      // ),
      body: HomeScreen(),
    ));
  }
}
