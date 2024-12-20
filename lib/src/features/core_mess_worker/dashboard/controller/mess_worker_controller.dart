import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessWorkerController extends GetxController {
  var messName = ''.obs;

  // Controllers for waste input fields
  final breakfastWasteController = TextEditingController();
  final lunchWasteController = TextEditingController();
  final snacksWasteController = TextEditingController();
  final dinnerWasteController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // Function to get the current user's UID
  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  // Fetch the current user's mess assignment and waste data
  Future<void> fetchUserData() async {
    String uid = getCurrentUserId();
    try {
      // Fetch the mess worker document
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('MessWorkers')
          .doc(uid)
          .get();

      if (doc.exists) {
        // Use doc.data() with proper type casting
        final data = doc.data() as Map<String, dynamic>?;

        // Safely access the 'messName' field
        if (data != null && data.containsKey('MessName')) {
          messName.value = data['MessName'] as String;
        } else {
          messName.value = 'Unknown';
        }

        Map<String, dynamic> wasteProduced = doc['WasteProduced'] ?? {};

        // Pre-fill the text controllers with existing data
        breakfastWasteController.text =
            (wasteProduced['Breakfast'] ?? 0.0).toString();
        lunchWasteController.text = (wasteProduced['Lunch'] ?? 0.0).toString();
        snacksWasteController.text =
            (wasteProduced['Snacks'] ?? 0.0).toString();
        dinnerWasteController.text =
            (wasteProduced['Dinner'] ?? 0.0).toString();
      }
    } catch (e) {
      print("Error fetching user data: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch user data",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Function to submit waste data
  Future<void> submitWasteData(String mealType, String amount) async {
    if (amount.isEmpty) return;

    double wasteAmount = double.parse(amount);
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String uid = getCurrentUserId();

    try {
      // Update MessWorkers collection
      await FirebaseFirestore.instance
          .collection('MessWorkers')
          .doc(uid)
          .update({
        'WasteProduced.$mealType': wasteAmount,
      });

      // Update statistics collection
      DocumentReference statsDoc =
          FirebaseFirestore.instance.collection('statistics').doc(currentDate);

      DocumentSnapshot snapshot = await statsDoc.get();

      if (snapshot.exists) {
        // Update the specific mess
        await statsDoc.update({
          'messData.${messName.value}.$mealType': wasteAmount,
        });
      } else {
        // Create a new document if it doesn't exist
        Map<String, dynamic> defaultMessData = {
          'Oak': {'Breakfast': 0.0, 'Lunch': 0.0, 'Snacks': 0.0, 'Dinner': 0.0},
          'Pine': {
            'Breakfast': 0.0,
            'Lunch': 0.0,
            'Snacks': 0.0,
            'Dinner': 0.0
          },
          'Alder': {
            'Breakfast': 0.0,
            'Lunch': 0.0,
            'Snacks': 0.0,
            'Dinner': 0.0
          },
          'Peepal': {
            'Breakfast': 0.0,
            'Lunch': 0.0,
            'Snacks': 0.0,
            'Dinner': 0.0
          },
        };

        // Update the specific mess with the new data
        defaultMessData[messName.value][mealType] = wasteAmount;

        await statsDoc.set({'messData': defaultMessData});
      }

      Get.snackbar(
        "Success",
        "$mealType waste submitted: $amount kg",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to submit waste data: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Functions to handle individual waste submissions
  void submitBreakfastWaste() {
    submitWasteData('Breakfast', breakfastWasteController.text);
  }

  void submitLunchWaste() {
    submitWasteData('Lunch', lunchWasteController.text);
  }

  void submitSnacksWaste() {
    submitWasteData('Snacks', snacksWasteController.text);
  }

  void submitDinnerWaste() {
    submitWasteData('Dinner', dinnerWasteController.text);
  }
}
