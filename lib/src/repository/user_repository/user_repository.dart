import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scavenger_2/src/features/core/model/user_model.dart';
import 'package:scavenger_2/src/features/core/model/worker_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  // Future<void> createUser(UserModel user, FirebaseAuth auth) async {
  //   try {
  //     // Get the current user's UID from Firebase Auth
  //     final uid = auth.currentUser?.uid;
  //     if (uid != null) {
  //       // Set the user's `id` to match the Firebase Auth `uid`
  //       user = UserModel(
  //         id: uid,
  //         fullName: user.fullName,
  //         email: user.email,
  //         password: user.password,
  //         role: user.role,
  //         createdAt: user.createdAt,
  //       );

  //       // Save user data in Firestore with `uid` as the document ID
  //       await _db.collection("Users").doc(uid).set(user.toJson()).whenComplete(
  //             () => Get.snackbar("Success", "Your account has been created.",
  //                 snackPosition: SnackPosition.BOTTOM,
  //                 backgroundColor: PrimaryColor.withOpacity(0.1),
  //                 colorText: PrimaryColor),
  //           );
  //     } else {
  //       Get.snackbar("Error", "User not authenticated.",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.redAccent.withOpacity(0.1),
  //           colorText: Colors.red);
  //     }
  //   } catch (error) {
  //     Get.snackbar("Error", "Something went wrong. Try again.",
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.redAccent.withOpacity(0.1),
  //         colorText: Colors.red);
  //     rethrow;
  //   }
  // }
  Future<void> createUser(dynamic user) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        return;
      }
      String collection = _getCollectionByRole(user.role);
      await _db.collection(collection).doc(uid).set(user.toJson()).whenComplete(
          () => Get.snackbar("Success", "Account created successfully!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white));
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  String _getCollectionByRole(String role) {
    switch (role) {
      case 'Resident':
        return 'Users';
      case 'Worker':
        return 'Users';
      case 'MessWorkers':
        return 'MessWorkers';
      default:
        return 'Users';
    }
  }

  // Fetch User Details by Email
  // Future<UserModel?> getUserByEmail(String email) async {
  //   try {
  //     final snapshot = await _db
  //         .collection("Users")
  //         .where("Email", isEqualTo: email)
  //         .limit(1)
  //         .get();

  //     if (snapshot.docs.isNotEmpty) {
  //       return UserModel.fromSnapshot(snapshot.docs.first);
  //     }
  //     return null; // Return null if user does not exist
  //   } catch (error) {
  //     print("Error fetching user by email: $error");
  //     return null; // Return null if there's an error
  //   }
  // }
  Future<dynamic> getUserByEmail(String email) async {
    try {
      // First, search in the 'Users' collection
      final userSnapshot = await _db
          .collection('Users')
          .where("Email", isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        return UserModel.fromSnapshot(userSnapshot.docs.first);
      }

      // If not found in 'Users', search in 'MessWorkers'
      final messWorkerSnapshot = await _db
          .collection('MessWorkers')
          .where("Email", isEqualTo: email)
          .limit(1)
          .get();

      if (messWorkerSnapshot.docs.isNotEmpty) {
        print("RETURNED THE MESSWORKER DETAILS");
        return MessWorkerModel.fromSnapshot(messWorkerSnapshot.docs.first);
      }
      print("DIDN'T RETURNED THE MESSWORKER DETAILS");
      // Return null if user is not found in either collection
      return null;
    } catch (error) {
      print("Error fetching user by email: $error");
      return null;
    }
  }

  Future<bool> checkIfMessWorkerExists(String messName) async {
    try {
      final snapshot = await _db
          .collection("MessWorkers")
          .where("messName", isEqualTo: messName)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking mess worker: $e");
      return false;
    }
  }

  // Fetch User Details by Email (General method)
  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }
  // Future<dynamic> getUserDetails(String email, String role) async {
  //   String collection = _getCollectionByRole(role);
  //   final snapshot =
  //       await _db.collection(collection).where("Email", isEqualTo: email).get();

  //   if (snapshot.docs.isNotEmpty) {
  //     return role == 'MessWorkers'
  //         ? MessWorkerModel.fromSnapshot(snapshot.docs.first)
  //         : UserModel.fromSnapshot(snapshot.docs.first);
  //   }
  //   throw Exception("User not found");
  // }

  // Fetch all User Details
  Future<List<UserModel>> getAllDetails() async {
    final snapshot = await _db.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }
  // Future<List<dynamic>> getAllDetails(String role) async {
  //   String collection = _getCollectionByRole(role);
  //   final snapshot = await _db.collection(collection).get();

  //   return snapshot.docs.map((e) {
  //     return role == 'MessWorkers'
  //         ? MessWorkerModel.fromSnapshot(e)
  //         : UserModel.fromSnapshot(e);
  //   }).toList();
  // }

  // Update User Record
  Future<void> updateUserRecord(UserModel user) async {
    final userUID = FirebaseAuth.instance.currentUser?.uid;
    await _db.collection("Users").doc(userUID).update(user.toJson());
  }
}
