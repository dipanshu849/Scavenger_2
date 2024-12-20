import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   final String? id; // Unique identifier for the user
//   final String fullName;
//   final String email;
//   final String password;
//   final Timestamp? createdAt;
//   final String role;
//   final List<Map<String, dynamic>> fines; // Field to store fines
//   final bool pickupStatus; // New field to track pick-up status

//   UserModel({
//     this.id,
//     required this.fullName,
//     required this.email,
//     required this.password,
//     this.createdAt,
//     required this.role,
//     this.fines = const [],
//     this.pickupStatus = false, // Default to false (not picked up)
//   });

//   // Convert UserModel to JSON for Firestore
//   Map<String, dynamic> toJson() {
//     return {
//       "FullName": fullName,
//       "Email": email,
//       "Password": password,
//       "Role": role,
//       "Created At": createdAt ?? FieldValue.serverTimestamp(),
//       "id": id,
//       "Fines": fines,
//       "PickupStatus": pickupStatus,
//     };
//   }

//   // Factory constructor to create UserModel from Firestore snapshot
//   factory UserModel.fromSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> document) {
//     final data = document.data()!;
//     return UserModel(
//       id: document.id,
//       fullName: data["FullName"],
//       email: data["Email"],
//       password: data["Password"],
//       role: data["Role"],
//       createdAt: data["Created At"],
//       fines: List<Map<String, dynamic>>.from(data["Fines"] ?? []),
//       pickupStatus: data["PickupStatus"] ?? false, // Default to false
//     );
//   }
// }

class UserModel {
  final String fullName;
  final String email;
  final String password;
  final Timestamp? createdAt;
  final String role;
  final List<Map<String, dynamic>> fines;
  final bool pickupStatus;
  final Timestamp? pickupTimestamp; // Field to track pickup timestamp
  final bool fineAdded; // Boolean to track if a fine is added

  UserModel({
    required this.fullName,
    required this.email,
    required this.password,
    this.createdAt,
    required this.role,
    this.fines = const [],
    this.pickupStatus = false,
    this.pickupTimestamp, // Default to null
    this.fineAdded = false, // Default to false
  });

  Map<String, dynamic> toJson() {
    return {
      "FullName": fullName,
      "Email": email,
      "Password": password,
      "Role": role,
      "Created At": createdAt ?? FieldValue.serverTimestamp(),
      "Fines": fines,
      "PickupStatus": pickupStatus,
      "PickupTimestamp": pickupTimestamp,
      "FineAdded": fineAdded,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      fullName: data["FullName"],
      email: data["Email"],
      password: data["Password"],
      role: data["Role"],
      createdAt: data["Created At"],
      fines: List<Map<String, dynamic>>.from(data["Fines"] ?? []),
      pickupStatus: data["PickupStatus"] ?? false,
      pickupTimestamp: data["PickupTimestamp"], // Load timestamp
      fineAdded: data["FineAdded"] ?? false, // Load fine boolean
    );
  }
}
