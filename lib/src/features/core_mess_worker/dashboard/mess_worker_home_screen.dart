import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/common_widgets/widget/container/circular_container.dart';
import 'package:scavenger_2/src/common_widgets/widget/curved_edges/curved_edges_widget.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/features/core/screen/features/feedback/user_feedback.dart';
import 'package:scavenger_2/src/features/core/screen/features/updates/update_screen.dart';
import 'package:scavenger_2/src/features/core_mess_worker/dashboard/controller/mess_worker_controller.dart';
import 'package:scavenger_2/src/repository/authentication_repository/authentication_repository.dart';

class MessWorkerHome extends StatelessWidget {
  MessWorkerHome({super.key});
  final controller = Get.put(MessWorkerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedEdgeWidget(
              child: Container(
                color: PrimaryColor,
                child: SizedBox(
                  height: 200,
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
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 20, top: 7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: PrimaryColor.withOpacity(0.3),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  await AuthenticationRepository.instance
                                      .logOut();
                                },
                                icon:
                                    const Icon(Icons.logout_outlined, size: 28),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                          bottom: 45,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Obx(
                              () => Text(
                                controller.messName.value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0), // Add padding here
              child: Column(
                children: [
                  // Breakfast Waste Section
                  _buildWasteSubmissionSection(
                    title: 'Breakfast Waste (kg)',
                    controller: controller.breakfastWasteController,
                    onSubmit: controller.submitBreakfastWaste,
                  ),
                  const SizedBox(height: 20),

                  // Lunch Waste Section
                  _buildWasteSubmissionSection(
                    title: 'Lunch Waste (kg)',
                    controller: controller.lunchWasteController,
                    onSubmit: controller.submitLunchWaste,
                  ),
                  const SizedBox(height: 20),

                  // Snacks Waste Section
                  _buildWasteSubmissionSection(
                    title: 'Snacks Waste (kg)',
                    controller: controller.snacksWasteController,
                    onSubmit: controller.submitSnacksWaste,
                  ),
                  const SizedBox(height: 20),

                  // Dinner Waste Section
                  _buildWasteSubmissionSection(
                    title: 'Dinner Waste (kg)',
                    controller: controller.dinnerWasteController,
                    onSubmit: controller.submitDinnerWaste,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteSubmissionSection({
    required String title,
    required TextEditingController controller,
    required Function() onSubmit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter waste amount',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity, // Make the button full width
          child: ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }
}
