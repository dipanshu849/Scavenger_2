import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/common_widgets/widget/container/circular_container.dart';
import 'package:scavenger_2/src/common_widgets/widget/curved_edges/curved_edges_widget.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/features/core/screen/features/feedback/user_feedback.dart';
import 'package:scavenger_2/src/features/core/screen/features/updates/update_screen.dart';
import 'package:scavenger_2/src/features/core/screen/profile/profile_functions/show_all_users.dart';

class DashboardWorker extends StatelessWidget {
  const DashboardWorker({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CurvedEdgeWidget(
                child: Container(
                  color: PrimaryColor,
                  padding: const EdgeInsets.all(0),
                  child: SizedBox(
                    height: 300,
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
                              "Worker Dashboard",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            actions: [
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 15, top: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: PrimaryColor.withOpacity(0.3),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      Get.to(() => UpdatesScreen());
                                    },
                                    icon: const Icon(
                                      LineAwesomeIcons.bell,
                                      size: 28,
                                    )),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 20, top: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: PrimaryColor.withOpacity(0.3),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      feedback(context);
                                    },
                                    icon: const Icon(
                                      Icons.error_outline_outlined,
                                      size: 28,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const ShowAllUsers(),
            ],
          ),
        ),
      ),
    );
  }
}
