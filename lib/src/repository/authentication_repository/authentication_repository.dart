import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:scavenger_2/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:scavenger_2/src/features/core/model/user_model.dart';
import 'package:scavenger_2/src/features/core/model/worker_model.dart';
import 'package:scavenger_2/src/features/core/navigation_menu.dart';
import 'package:scavenger_2/src/features/core_mess_worker/dashboard/mess_worker_home_screen.dart';
import 'package:scavenger_2/src/features/core_worker/navigation_menu_worker.dart';
import 'package:scavenger_2/src/repository/authentication_repository/exceptions/signup_emial_password_failure.dart';
import 'package:scavenger_2/src/repository/user_repository/user_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final auth = FirebaseAuth.instance;
  late final Rx<User?> _firebaseUser;
  var verificationId = ''.obs;
  User? get firebaseUser => _firebaseUser.value;

  final _firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(auth.currentUser);
    _firebaseUser.bindStream(auth.userChanges());
    FlutterNativeSplash.remove();
    setInitialScreen(_firebaseUser.value);
    // ever(firebaseUser, _setInitialScreen);
  }

  // setInitialScreen(User? user) async {
  //   if (user == null) {
  //     Get.offAll(() => SplashScreen()); // ALSO HAVE TO ADD EMAIL VERIFICATION
  //     return;
  //   }

  //   UserModel? userDetails =
  //       await UserRepository.instance.getUserByEmail(user.email!);

  //   if (userDetails != null) {
  //     if (userDetails.role == 'Resident') {
  //       Get.offAll(() => const NavigationMenu());
  //     } else if (userDetails.role == 'Worker') {
  //       Get.offAll(() => const NavigationMenuWorker());
  //     } else {
  //       Get.offAll(() => MessWorkerHome());
  //     }
  //   } else {
  //     Get.offAll(() => SplashScreen());
  //   }
  // }
  Future<void> setInitialScreen(User? user) async {
    await Future.delayed(
        const Duration(seconds: 1)); // Ensure everything is read
    if (user == null) {
      Get.offAll(() => SplashScreen());
      return;
    }

    // Fetch user details from Firestore
    dynamic userDetails =
        await UserRepository.instance.getUserByEmail(user.email!);

    if (userDetails == null) {
      // If user details are not found, log out and show the splash screen
      AuthenticationRepository.instance.logOut();
      Get.offAll(() => SplashScreen());
      return;
    }

    // Navigate based on the role
    if (userDetails is UserModel) {
      if (userDetails.role == 'Resident') {
        Get.offAll(() => const NavigationMenu());
      } else if (userDetails.role == 'Worker') {
        Get.offAll(() => const NavigationMenuWorker());
      }
    } else if (userDetails is MessWorkerModel) {
      Get.offAll(() => MessWorkerHome());
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid != null) {
        final snapshot = await _firestore.collection('Users').doc(uid).get();
        if (snapshot.exists) {
          return UserModel.fromSnapshot(snapshot);
        } else {
          print("User not found in Firestore for uid: $uid");
        }
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user data: $e");
      print("Error fetching user data: $e");
    }
    return null;
  }

  // [EmailAuthentication] - REGISTER
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Print error code for debugging
      print("FirebaseAuthException: ${e.code}");
      final ex = SignupEmialPasswordFailure.code(e.code);
      throw ex;
    } catch (e) {
      print("Unknown Error: $e");
      const ex = SignupEmialPasswordFailure();
      throw ex;
    }
  }

  ///                       - LOGIN
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      // TODO
    } catch (_) {}
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const WelcomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 5000));
    } on FormatException catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 5000));
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 5000));
    }
  }

  /// [EmailVerifcation] -verification
  Future<void> sendEmailVerification() async {
    try {
      await auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      final ex = TExceptions.fromCode(e.code);
      throw ex.message;
    } catch (_) {
      const ex = TExceptions();
      throw ex.message;
    }
  }

  Future<void> deleteUser(String password, String uid) async {
    try {
      final user = firebaseUser;
      if (user == null) {
        Get.snackbar("Error", "No user is signed in.");
        return;
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await _firestore.collection('Users').doc(uid).delete();
      await user.delete();

      Get.offAll(() => const WelcomeScreen());
      Get.snackbar("Success", "Your account has been deleted.");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete account: $e");
    }
  }
}

class TExceptions implements Exception {
  final String message;

  const TExceptions([
    this.message = 'An unknown error occurred.',
  ]);

  factory TExceptions.fromCode(String code) {
    switch (code) {
      case 'auth/claims-too-large':
        return const TExceptions('Claims payload is too large.');
      case 'auth/email-already-exists':
        return const TExceptions('Email already exists.');
      case 'auth/id-token-expired':
        return const TExceptions('ID token has expired.');
      case 'auth/id-token-revoked':
        return const TExceptions('ID token has been revoked.');
      case 'auth/insufficient-permission':
        return const TExceptions('Insufficient permission.');
      default:
        return const TExceptions();
    }
  }
}
