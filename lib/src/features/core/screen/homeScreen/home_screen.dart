import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/common_widgets/loading/loading_widget.dart';
import 'package:scavenger_2/src/common_widgets/widget/container/circular_container.dart';
import 'package:scavenger_2/src/common_widgets/widget/curved_edges/curved_edges_widget.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/features/core/controller/profile_controller.dart';
import 'package:scavenger_2/src/features/core/model/user_model.dart';
import 'package:scavenger_2/src/features/core/screen/features/bins/bins_overview_page.dart';
import 'package:scavenger_2/src/features/core/screen/features/news/news_carousel.dart';
import 'package:scavenger_2/src/features/core/screen/statistical_analysis/statistical_analysis.dart';
import 'package:scavenger_2/src/features/core/screen/features/feedback/user_feedback.dart';
import 'package:scavenger_2/src/features/core/screen/features/updates/update_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Show fines details when clicked
  void _showFinesDetails(
      BuildContext context, List<Map<String, dynamic>> fines) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: fines.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No Fines Applied!",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: fines.length,
                  itemBuilder: (context, index) {
                    final fine = fines[index];
                    final reason = fine["reason"] ?? "No reason provided";
                    final timestamp = fine["timestamp"];
                    final photoUrl = fine["photoUrl"];

                    // Format timestamp
                    final formattedTimestamp = timestamp != null
                        ? DateFormat('dd/MM/yyyy HH:mm')
                            .format(timestamp.toDate())
                        : "Unknown Date";

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.redAccent,
                          size: 36,
                        ),
                        title: const Text(
                          "Fine Applied",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Reason: $reason"),
                            Text("Applied on: $formattedTimestamp"),
                            photoUrl != null && photoUrl.isNotEmpty
                                ? TextButton(
                                    onPressed: () {
                                      _showImageProof(context, photoUrl);
                                    },
                                    child: const Text(
                                      "View Proof",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  )
                                : const Text(
                                    "No proof provided",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // Show image proof in a dialog or modal
  void _showImageProof(BuildContext context, String photoUrl) {
    // Check if the photoUrl is valid
    if (photoUrl.isEmpty) {
      _showSnackBar(context, "No proof available.");
      return;
    }

    // Show the image using a dialog or bottom sheet
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Image.network(
              photoUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text("Failed to load image"));
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showPickupTime(BuildContext context, Timestamp? pickupTimestamp) {
    if (pickupTimestamp == null) {
      _showSnackBar(context, "Pickup time not available!");
      return;
    }

    final DateTime pickupTime = pickupTimestamp.toDate();
    final String formattedDate =
        "${pickupTime.day}/${pickupTime.month}/${pickupTime.year}";
    final String formattedTime =
        "${pickupTime.hour.toString().padLeft(2, '0')}:${pickupTime.minute.toString().padLeft(2, '0')}";

    // Display a custom bottom sheet
    showCupertinoModalPopup(
      context: context,
      // isScrollControlled: true,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      // ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Illustration or Icon
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: Colors.greenAccent.withOpacity(0.2),
              //     shape: BoxShape.circle,
              //   ),
              //   child: const Icon(
              //     Icons.check_circle,
              //     color: Colors.green,
              //     size: 60,
              //   ),
              // ),
              const SizedBox(height: 15),

              // Pickup Time Header
              const Text(
                "Waste Pick-Up Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // Display the pickup date and time
              const Text(
                "Picked up on:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "at $formattedTime",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              // Close Button
              const SizedBox(height: 20),
              // ElevatedButton.icon(
              //   onPressed: () => Navigator.pop(context),
              //   icon: const Icon(Icons.close, size: 18),
              //   label: const Text("Close"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: PrimaryColor,
              //     foregroundColor: Colors.white,
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(25),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedEdgeWidget(
              child: Container(
                color: PrimaryColor,
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: 450,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -150,
                        right: -250,
                        child: CircularContainer(
                            backgroundColor: Colors.white38.withOpacity(0.1)),
                      ),
                      Positioned(
                        top: 100,
                        right: -300,
                        child: CircularContainer(
                            backgroundColor: Colors.white38.withOpacity(0.1)),
                      ),
                      // Existing AppBar
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: AppBar(
                          title: const Text(
                            "HOME",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          actions: [
                            Container(
                              margin: const EdgeInsets.only(right: 15, top: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: PrimaryColor.withOpacity(0.3),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Get.to(() => UpdatesScreen());
                                },
                                icon:
                                    const Icon(LineAwesomeIcons.bell, size: 28),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20, top: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: PrimaryColor.withOpacity(0.3),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  feedback(context);
                                },
                                icon: const Icon(Icons.error_outline_outlined,
                                    size: 28),
                              ),
                            )
                          ],
                        ),
                      ),

                      // Adding Pick-Up Status and Fines
                      Positioned(
                        top: 120,
                        left: 20,
                        right: 20,
                        child: Column(
                          children: [
                            FutureBuilder<UserModel?>(
                              future: controller.getUserData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: SizedBox(
                                    width: double.infinity,
                                    height: 254,
                                    child: LoadingWidget(),
                                  ));
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text("Error: ${snapshot.error}"));
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return const Center(
                                      child: Text("User data not found"));
                                }

                                UserModel user = snapshot.data!;

                                return Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      // Pick-Up Status
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (user.pickupStatus) {
                                                _showPickupTime(context,
                                                    user.pickupTimestamp); // Show pickup time
                                              } else {
                                                _showSnackBar(context,
                                                    "Waste not picked up yet!");
                                              }
                                            },
                                            icon: Icon(
                                              user.pickupStatus
                                                  ? Icons.check_circle
                                                  : Icons
                                                      .cancel, // Conditional Icon
                                              color: user.pickupStatus
                                                  ? Colors.greenAccent
                                                  : Colors.redAccent,
                                              size: 28,
                                            ),
                                          ),
                                          Text(
                                            user.pickupStatus
                                                ? "Picked Up"
                                                : "Not Picked Up",
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                          const Text(
                                            "Pick-Up Status",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Fines Section
                                      Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (user.fines.isEmpty) {
                                                _showSnackBar(context,
                                                    "No fines applied!");
                                              } else {
                                                _showFinesDetails(context,
                                                    user.fines); // Show fines details
                                              }
                                            },
                                            icon: Icon(
                                              user.fines.isEmpty
                                                  ? Icons.check_circle
                                                  : Icons
                                                      .warning_amber_rounded, // Conditional Icon
                                              color: user.fines.isEmpty
                                                  ? Colors.greenAccent
                                                  : Colors.redAccent,
                                              size: 28,
                                            ),
                                          ),
                                          Text(
                                            user.fines.isEmpty
                                                ? "No Fines"
                                                : "Fines Pending",
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                            ),
                                          ),
                                          const Text(
                                            "Fines",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),

                            // New Expandable Card Below the Container
                            const SizedBox(height: 65),
                            GestureDetector(
                              onTap: () {
                                // Navigate to the bins overview page
                                Get.to(() =>
                                    const BinsOverviewPage()); // Replace with your target screen
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 25),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(
                                      0xFF357960), // Amazon Green color
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.map_outlined,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          "Explore Campus Bins",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // FROM HERE WIDGETS ARE IN WHITE SECTION
            const StatisticalAnalysis(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            NewsCarousel(),
          ],
        ),
      ),
    );
  }
}
