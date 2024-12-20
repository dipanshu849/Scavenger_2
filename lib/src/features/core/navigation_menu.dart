import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/features/core/screen/complain/mainComplain.dart';
import 'package:scavenger_2/src/features/core/screen/features/qr_id/qr_code_page.dart';
import 'package:scavenger_2/src/features/core/screen/statistical_analysis/analysis.dart';
import 'package:scavenger_2/src/features/core/screen/homeScreen/home_screen.dart';
import 'package:scavenger_2/src/features/core/screen/profile/profile_screen.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

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
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
          },
          backgroundColor: isDark ? Colors.black38 : Colors.white38,
          indicatorColor: PrimaryColor.withOpacity(0.8),
          destinations: const [
            NavigationDestination(
                icon: Icon(LineAwesomeIcons.home_solid), label: "Home"),
            NavigationDestination(
                icon: Icon(LineAwesomeIcons.pen_fancy_solid),
                label: "Complain"),
            NavigationDestination(
                icon: Icon(LineAwesomeIcons.qrcode_solid), label: "Tag"),
            NavigationDestination(
                icon: Icon(LineAwesomeIcons.chart_bar), label: "Statistics"),
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

  final List<Widget> screens = [
    const HomeScreen(),
    const ComplaintPage(),
    const QRCodePage(),
    Statistics(),
    const ProfileScreen(),
  ];
}
