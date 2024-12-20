import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scavenger_2/src/common_widgets/loading/loading_widget.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/constants/sizes.dart';

class WasteRepresentation extends StatefulWidget {
  const WasteRepresentation({super.key});

  @override
  State<WasteRepresentation> createState() => _WasteRepresentationState();
}

class _WasteRepresentationState extends State<WasteRepresentation> {
  Map<String, double> wasteData = {
    "Breakfast": 0,
    "Lunch": 0,
    "Snacks": 0,
    "Dinner": 0,
  };

  List<Map<String, String>> messData = [];

  int? touchedIndex;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWasteData();
  }

  Future<void> fetchWasteData() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Access the Firestore instance
      final firestore = FirebaseFirestore.instance;

      // Get the latest document by ordering by date (document ID) in descending order
      final snapshot = await firestore
          .collection('statistics')
          .orderBy(FieldPath.documentId, descending: true)
          .limit(1)
          .get();

      // Check if any document was returned
      if (snapshot.docs.isEmpty) {
        return;
      }

      final doc = snapshot.docs.first;
      final messDataMap = doc.data()['messData'] as Map<String, dynamic>?;

      if (messDataMap == null) {
        return;
      }

      // Update messData list
      List<Map<String, String>> updatedMessData = [];
      messDataMap.forEach((key, value) {
        final totalWaste = (value as Map<String, dynamic>)
            .values
            .fold(0.0, (sum, element) => sum + (element as num).toDouble());

        updatedMessData.add({
          'name': key,
          'waste': '${totalWaste.toStringAsFixed(2)} KG',
        });
      });

      // Sort the mess data in descending order based on waste
      updatedMessData.sort((a, b) => double.parse(b['waste']!.split(' ')[0])
          .compareTo(double.parse(a['waste']!.split(' ')[0])));

      // Update state
      setState(() {
        messData = updatedMessData;
        isLoading = false;
      });

      // Calculate total waste for pie chart
      Map<String, double> updatedWasteData = {
        'Breakfast': 0,
        'Lunch': 0,
        'Snacks': 0,
        'Dinner': 0,
      };

      messDataMap.forEach((_, value) {
        final wasteMap = value as Map<String, dynamic>;
        updatedWasteData['Breakfast'] = updatedWasteData['Breakfast']! +
            (wasteMap['Breakfast'] ?? 0).toDouble();
        updatedWasteData['Lunch'] =
            updatedWasteData['Lunch']! + (wasteMap['Lunch'] ?? 0).toDouble();
        updatedWasteData['Snacks'] =
            updatedWasteData['Snacks']! + (wasteMap['Snacks'] ?? 0).toDouble();
        updatedWasteData['Dinner'] =
            updatedWasteData['Dinner']! + (wasteMap['Dinner'] ?? 0).toDouble();
      });

      // Update state for pie chart data
      setState(() {
        wasteData = updatedWasteData;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.26,
          padding: const EdgeInsets.all(DefaultSize),
          margin: const EdgeInsets.only(
            top: 10,
            // bottom: 5,
            right: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: PrimaryColor.withOpacity(0.8), width: 3),
          ),
          child: isLoading
              ? const LoadingWidget(
                  size: 30,
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side - Pie chart with interactive labels
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.57,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 5,
                                centerSpaceRadius:
                                    MediaQuery.of(context).size.width * 0.08,
                                borderData: FlBorderData(show: true),
                                sections: getSections(),
                                pieTouchData: PieTouchData(
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (pieTouchResponse != null &&
                                          pieTouchResponse.touchedSection !=
                                              null) {
                                        touchedIndex = pieTouchResponse
                                            .touchedSection!
                                            .touchedSectionIndex;
                                      } else {
                                        touchedIndex = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Right side - Scrollable mess list
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: messData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              color: Colors.green.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      messData[index]['name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      messData[index]['waste']!,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  List<PieChartSectionData> getSections() {
    if (wasteData.isEmpty) {
      return [];
    }

    final List<Color> colorList = [
      Colors.red,
      Colors.blue,
      Colors.orange,
      Colors.green,
    ];

    final List<String> categories = wasteData.keys.toList();
    final List<double> values = wasteData.values.toList();

    return List.generate(wasteData.length, (index) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 75 : 70;
      final String category = categories[index];
      final double value = values[index];

      return PieChartSectionData(
        color: colorList[index],
        value: value,
        title: '$value KG',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              )
            : null,
        badgePositionPercentageOffset: 0.2,
      );
    });
  }
}
