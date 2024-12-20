import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/firebase_options.dart';
import 'package:scavenger_2/src/common_widgets/loading/loading_widget.dart';
import 'package:scavenger_2/src/repository/authentication_repository/authentication_repository.dart';
import 'package:scavenger_2/src/repository/user_repository/user_repository.dart';
import 'package:scavenger_2/src/utils/theme/theme.dart';

// Future<void> main() async {
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   Get.testMode = true;
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
//       .then((FirebaseApp value) {
//     Get.put(AuthenticationRepository());
//     Get.put(UserRepository());
//   });
Future<void> main() async {
  // Ensure that Flutter's binding is initialized before any other initialization
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve the splash screen until Firebase initialization is complete
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize GetX dependencies
  Get.put(AuthenticationRepository());
  Get.put(UserRepository());

  // Remove the splash screen after initialization is complete
  FlutterNativeSplash.remove();
  // FlutterNativeSplash.remove();
  runApp(const BetterFeedback(child: MyApp()));
}

/*
  Loading button on SignUp page
  
*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      defaultTransition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 500),
      // home: const MailVerification(),
      home: const Scaffold(
        body: Center(
          child: LoadingWidget(),
        ),
      ),
    );
  }
}
