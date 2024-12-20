import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scavenger_2/src/constants/sizes.dart';
import 'package:scavenger_2/src/features/core/screen/statistical_analysis/widget/waste_representation.dart';

class StatisticalAnalysis extends StatelessWidget {
  const StatisticalAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: DefaultSize, right: DefaultSize, bottom: DefaultSize, top: 0),
      child: SizedBox(
        height: min(MediaQuery.of(context).size.height * 0.3,
            480), // Set a specific height
        child: const DefaultTabController(
          length: 2, // Number of tabs
          child: Column(
            children: [
              TabBar(tabs: [
                Tab(text: "North Campus"),
                Tab(text: "South Campus"),
              ]),
              Expanded(
                // Use Expanded to fill the remaining space
                child: TabBarView(
                  children: [
                    // Center(child: Text("North Campus")),
                    // Center(child: Text("South Campus")),
                    WasteRepresentation(),

                    WasteRepresentation()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
