import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/common_widgets/loading/loading_widget.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/features/core/controller/profile_controller.dart';
import 'package:scavenger_2/src/features/core/model/user_model.dart';

class ShowAllUsers extends StatelessWidget {
  const ShowAllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Padding(
      padding: const EdgeInsets.all(DefaultSize),
      child: FutureBuilder<List<UserModel>>(
        future: controller.getAllData(), // Fetch user data from the controller
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LoadingWidget());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          final userList = snapshot.data!; // Get the list of users
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.8,
            ),
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: PrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: PrimaryColor, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LineAwesomeIcons.user_alt_solid,
                      color: PrimaryColor,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    user.createdAt != null
                        ? Text(
                            "Joined: ${DateFormat.yMMMd().format(user.createdAt!.toDate())}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const Text(
                            'No data available',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                    const SizedBox(height: 8),
                    // Display Pickup Status
                    Text(
                      user.pickupStatus
                          ? "Status: Picked Up"
                          : "Status: Not Picked Up",
                      style: TextStyle(
                        color: user.pickupStatus ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
