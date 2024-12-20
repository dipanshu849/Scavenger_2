import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/constants/image_strings.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/constants/text_strings.dart';
import 'package:scavenger_2/src/features/authentication/controllers/on_boarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    final Size size = MediaQuery.sizeOf(context);
    var isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return SafeArea(
        child: Scaffold(
            body: Stack(
      children: [
        /// Horizontal scrollable pages
        PageView(
          controller: controller.pageController,
          onPageChanged: controller.updatePageIndicator,
          children: [
            OnBoardingPage(
              size: size,
              image: onBoardingImage1,
              title: onBoardingTitle1,
              subtitle: onBoardingSubTitle1,
            ),
            OnBoardingPage(
              size: size,
              image: onBoardingImage2,
              title: onBoardingTitle2,
              subtitle: onBoardingSubTitle2,
            ),
            OnBoardingPage(
              size: size,
              image: onBoardingImage3,
              title: onBoardingTitle3,
              subtitle: onBoardingSubTitle3,
            ),
            OnBoardingPage(
              size: size,
              image: onBoardingImage4,
              title: onBoardingTitle4,
              subtitle: onBoardingSubTitle4,
            ),
            OnBoardingPage(
              size: size,
              image: onBoardingImage5,
              title: onBoardingTitle5,
              subtitle: onBoardingSubTitle5,
            ),
            OnBoardingPage(
              size: size,
              image: onBoardingImage6,
              title: onBoardingTitle6,
              subtitle: onBoardingSubTitle6,
            ),
            OnBoardingPage(
              size: size,
              image: onBoardingImage7,
              title: onBoardingTitle7,
              subtitle: onBoardingSubTitle7,
            ),
          ],
        )

        /// Skip Button
        ,
        Positioned(
            right: DefaultSize * 0.5,
            child: TextButton(
                onPressed: () => controller.skipPage(),
                child: const Text("Skip")))

        /// Dot Navigation SmoothPageIndicator
        ,
        Positioned(
            bottom: DefaultSize * 1.3,
            left: DefaultSize,
            child: SmoothPageIndicator(
              controller: controller.pageController,
              onDotClicked: OnBoardingController.instance.dotNavigationClick,
              count: 7,
              effect: ExpandingDotsEffect(
                  activeDotColor: isDark ? Colors.white : Colors.black,
                  dotHeight: 6),
            ))

        /// Circular Button
        ,
        Positioned(
            bottom: DefaultSize,
            right: DefaultSize,
            child: ElevatedButton(
                onPressed: () => OnBoardingController.instance.nextPage(),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: isDark ? PrimaryColor : Colors.black,
                ),
                child: const Icon(LineAwesomeIcons.angle_right_solid)))
      ],
    )));
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.size,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final Size size;
  final String image, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(DefaultSize),
      child: Column(
        children: [
          Image(
            height: size.height * 0.6,
            width: size.width * 0.8,
            image: AssetImage(image),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: spaceBtwItems,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
