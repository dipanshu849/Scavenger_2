import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/features/core/screen/profile/profile_screen.dart';
import 'package:scavenger_2/src/features/core_worker/dashboard/dashboard_worker.dart';
import 'package:scavenger_2/src/features/core_worker/features/qr_scanner/qr_scanner.dart';

class NavigationMenuWorker extends StatelessWidget {
  const NavigationMenuWorker({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 70,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: isDark ? Colors.black38 : Colors.white38,
          indicatorColor: PrimaryColor.withOpacity(0.8),
          destinations: const [
            NavigationDestination(
                icon: Icon(LineAwesomeIcons.home_solid), label: "Home"),
            NavigationDestination(
                icon: Icon(LineAwesomeIcons.qrcode_solid), label: "Scan"),
            NavigationDestination(
                icon: Icon(Icons.person_2_outlined), label: "Profile"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const DashboardWorker(),
    const QRScannerPage(),
    const ProfileScreen(),
  ];
}
