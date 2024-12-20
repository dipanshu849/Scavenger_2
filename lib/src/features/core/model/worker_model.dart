import 'package:cloud_firestore/cloud_firestore.dart';

class MessWorkerModel {
  final String? id;
  final String fullName;
  final String? messName;
  final Map<String, double> wasteProduced;
  final String role;
  final String email;
  final String password;

  MessWorkerModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.messName = "new mess",
    this.wasteProduced = const {
      "Breakfast": 0,
      "Lunch": 0,
      "Snacks": 0,
      "Dinner": 0,
    },
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "FullName": fullName,
      "MessName": messName,
      "WasteProduced": wasteProduced,
      "Role": role,
      "Email": email,
      "Password": password,
    };
  }

  factory MessWorkerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return MessWorkerModel(
      id: document.id,
      fullName: data["FullName"],
      messName: data["MessName"],
      email: data["Email"],
      password: data["Password"],
      wasteProduced: Map<String, double>.from(data["WasteProduced"] ?? {}),
      role: data["Role"],
    );
  }
}
