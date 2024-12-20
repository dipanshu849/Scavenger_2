import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  DateTime _selectedDate = DateTime.now();
  String _selectedMess = 'All'; // Default to show all mess data
  Map<String, double> foodWasteData = {
    'Breakfast': 0.0,
    'Lunch': 0.0,
    'Snacks': 0.0,
    'Dinner': 0.0,
  };

  final List<String> messTypes = [
    'All',
    'Oak',
    'Pine',
    'Peepal',
    'Alder'
  ]; // Add more mess types as needed

  @override
  void initState() {
    super.initState();
    fetchFoodWasteDataForDateAndMess(_selectedDate, _selectedMess);
  }

  Future<void> fetchFoodWasteDataForDateAndMess(
      DateTime date, String messType) async {
    String dateString = DateFormat('yyyy-MM-dd').format(date);
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('statistics')
        .doc(dateString)
        .get();

    if (!mounted) return;

    setState(() {
      foodWasteData = {
        'Breakfast': 0.0,
        'Lunch': 0.0,
        'Snacks': 0.0,
        'Dinner': 0.0,
      };

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            (documentSnapshot.data() as Map<String, dynamic>)['messData'] ?? {};
        if (_selectedMess == 'All') {
          // Sum data for all mess types
          data.forEach((mess, values) {
            foodWasteData['Breakfast'] = (foodWasteData['Breakfast'] ?? 0) +
                (values['Breakfast'] is num
                    ? (values['Breakfast'] as num).toDouble()
                    : 0.0);
            foodWasteData['Lunch'] = (foodWasteData['Lunch'] ?? 0) +
                (values['Lunch'] is num
                    ? (values['Lunch'] as num).toDouble()
                    : 0.0);
            foodWasteData['Snacks'] = (foodWasteData['Snacks'] ?? 0) +
                (values['Snacks'] is num
                    ? (values['Snacks'] as num).toDouble()
                    : 0.0);
            foodWasteData['Dinner'] = (foodWasteData['Dinner'] ?? 0) +
                (values['Dinner'] is num
                    ? (values['Dinner'] as num).toDouble()
                    : 0.0);
          });
        } else if (data.containsKey(_selectedMess)) {
          foodWasteData = {
            'Breakfast': (data[_selectedMess]['Breakfast'] ?? 0.0) as double,
            'Lunch': (data[_selectedMess]['Lunch'] ?? 0.0) as double,
            'Snacks': (data[_selectedMess]['Snacks'] ?? 0.0) as double,
            'Dinner': (data[_selectedMess]['Dinner'] ?? 0.0) as double,
          };
        }
      }
      if (!documentSnapshot.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "No data available for the selected date.",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.redAccent,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Daily Waste Stats",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.green],
                  ),
                ),
                child: Center(
                  child: Text(
                    "Select Date",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TableCalendar(
                  focusedDay: _selectedDate,
                  firstDay: DateTime(2022),
                  lastDay: DateTime(2025),
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      fetchFoodWasteDataForDateAndMess(
                          _selectedDate, _selectedMess);
                    });
                    Navigator.pop(context); // Close the drawer after selecting
                  },
                  calendarFormat: CalendarFormat.month,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [Colors.tealAccent, Colors.greenAccent],
                  // ),
                  ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Statistics for ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        // isDense: true,
                        value: _selectedMess,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: PrimaryColor),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (newMess) {
                          setState(() {
                            _selectedMess = newMess!;
                            fetchFoodWasteDataForDateAndMess(
                                _selectedDate, _selectedMess);
                          });
                        },
                        items: messTypes
                            .map<DropdownMenuItem<String>>((String mess) {
                          return DropdownMenuItem<String>(
                            value: mess,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.restaurant,
                                  color: PrimaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  mess,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 6,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: foodWasteData.values.isNotEmpty
                              ? foodWasteData.values
                                      .reduce((a, b) => a > b ? a : b) *
                                  1.2
                              : 20,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()} kg');
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text('Breakfast');
                                    case 1:
                                      return const Text('Lunch');
                                    case 2:
                                      return const Text('Snacks');
                                    case 3:
                                      return const Text('Dinner');
                                    default:
                                      return const Text('');
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: foodWasteData['Breakfast'] ?? 0,
                                  color: Colors.blue,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: foodWasteData['Lunch'] ?? 0,
                                  color: Colors.green,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: foodWasteData['Snacks'] ?? 0,
                                  color: Colors.orange,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 3,
                              barRods: [
                                BarChartRodData(
                                  toY: foodWasteData['Dinner'] ?? 0,
                                  color: Colors.red,
                                  width: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
