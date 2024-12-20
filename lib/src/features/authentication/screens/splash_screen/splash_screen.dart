import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/constants/text_strings.dart';
import 'package:scavenger_2/src/features/authentication/controllers/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final splashController = Get.put(SplashScreenController());
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;
    splashController.startAnimation();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Obx(
              () => AnimatedPositioned(
                  duration: const Duration(milliseconds: 1000),
                  top: splashController.animate.value ? 0 : -30,
                  left: splashController.animate.value ? 0 : -30,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: const BoxDecoration(
                      color: SecondaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(300),
                      ),
                    ),
                  )),
            ),
            Obx(
              () => AnimatedPositioned(
                // Text Goes here
                duration: const Duration(milliseconds: 1000),
                top: 180,
                left: splashController.animate.value ? DefaultSize + 20 : -80,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  opacity: splashController.animate.value ? 1 : 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(AppTagLine,
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                // logo will go here
                top: height / 2 - 100,
                left: width / 2 - 100,
                child: Obx(
                  () => AnimatedOpacity(
                      duration: const Duration(milliseconds: 1400),
                      opacity: splashController.animate.value ? 1 : 0,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.circular(20),
                          // gradient: const RadialGradient(
                          //   center: Alignment.center,
                          //   radius: 0.5,
                          //   colors: [Colors.white38, PrimaryColor],
                          //   stops: [0.4, 1.0],
                          // ),
                        ),
                        child: const Center(
                            child: Text(
                          "SCAVENGER",
                          style: TextStyle(
                              color: SecondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        )),
                      )),
                )),
            Positioned(
                top: height / 2 + 50,
                left: width / 2 - 100 - SplashContainerSize,
                child: Container(
                  width: 200 + 2 * SplashContainerSize,
                  height: SplashContainerSize,
                  decoration: BoxDecoration(
                    color: PrimaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                )),
            Obx(
              () => AnimatedPositioned(
                  duration: const Duration(milliseconds: 2000),
                  top: height / 2 + 50,
                  left: splashController.animate.value
                      ? width / 2 + 100
                      : width / 2 - 100 - SplashContainerSize,
                  child: Container(
                    width: SplashContainerSize,
                    height: SplashContainerSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white38,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
