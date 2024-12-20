import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/constants/sizes.dart';

class UpdatesScreen extends StatelessWidget {
  UpdatesScreen({Key? key}) : super(key: key);

  // Mock data simulating app updates
  final List<Map<String, dynamic>> updates = [
    {
      'title':
          '- Roles [New]\n- Latest Changes [New]\n- Bottom Navigation Bar [New]\n- Fix Known Bugs',
      'date': '29 Oct 2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Latest Changes',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(LineAwesomeIcons.angle_left_solid)),
      ),
      body: Container(
        padding: const EdgeInsets.all(DefaultSize - 5),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 16.0),
          itemCount: updates.length,
          itemBuilder: (context, index) {
            final update = updates[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: PrimaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          update['date'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      update['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
