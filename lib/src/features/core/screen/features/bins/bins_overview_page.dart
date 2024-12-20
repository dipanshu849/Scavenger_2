import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scavenger_2/src/constants/colors.dart';
import 'package:scavenger_2/src/constants/sizes.dart';

class BinsOverviewPage extends StatefulWidget {
  const BinsOverviewPage({super.key});

  @override
  _BinsOverviewPageState createState() => _BinsOverviewPageState();
}

class _BinsOverviewPageState extends State<BinsOverviewPage> {
  Map<String, dynamic> binsData = {};
  bool isLoading = false;
  late GoogleMapController _mapController;
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchBinData();
  }

  Future<void> _fetchBinData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DatabaseReference ref = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            "https://scavenger-54568-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref("bin");

      ref.onValue.listen((DatabaseEvent event) {
        if (event.snapshot.exists) {
          final data = event.snapshot.value as Map<dynamic, dynamic>?;

          if (data != null) {
            setState(() {
              binsData = data.map((key, value) => MapEntry(
                    key,
                    {
                      'fillLevel':
                          double.tryParse(value['fillLevel'].toString()) ?? 0.0,
                      'latitude':
                          double.tryParse(value['latitude'].toString()) ?? 0.0,
                      'longitude':
                          double.tryParse(value['longitude'].toString()) ?? 0.0,
                      'lastUpdatedTime': value['lastUpdatedTime'] ?? 0,
                    },
                  ));
            });
            _updateMarkers();
          }
        }
      });
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateMarkers() {
    final markers = <String, Marker>{};

    binsData.forEach((binName, binInfo) {
      markers[binName] = Marker(
        markerId: MarkerId(binName),
        position: LatLng(binInfo['latitude'], binInfo['longitude']),
        infoWindow: InfoWindow(
          title: binName,
          snippet: 'Fill Level: ${binInfo['fillLevel']}%',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerColor(binInfo['fillLevel']),
        ),
      );
    });

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  double _getMarkerColor(double fillLevel) {
    if (fillLevel < 25) return BitmapDescriptor.hueGreen;
    if (fillLevel < 75) return BitmapDescriptor.hueYellow;
    return BitmapDescriptor.hueRed;
  }

  Future<void> _refreshData() async {
    await _fetchBinData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: const Text(
          "Campus Bins",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: "Refresh Data",
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(DefaultSize),
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1.5),
                      ),
                      child: GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target:
                              LatLng(31.781765, 76.997215), // Center of campus
                          zoom: 16,
                        ),
                        markers: _markers.values.toSet(),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: binsData.keys.length,
                      itemBuilder: (context, index) {
                        final binName = binsData.keys.elementAt(index);
                        final binInfo = binsData[binName];
                        return InformativeBinDisplay(
                          binName: binName,
                          fillLevel: binInfo['fillLevel'].toString(),
                          height: binInfo['height'].toString(),
                          lastUpdatedTime:
                              binInfo['lastUpdatedTime'].toString(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class InformativeBinDisplay extends StatelessWidget {
  const InformativeBinDisplay({
    super.key,
    required this.binName,
    required this.fillLevel,
    required this.lastUpdatedTime,
    required this.height,
  });

  final String binName;
  final String? fillLevel;
  final String? lastUpdatedTime;
  final String? height;

  IconData _getEmoji(double level) {
    if (level < 25) return Icons.sentiment_very_satisfied;
    if (level < 75) return Icons.sentiment_neutral;
    return Icons.sentiment_very_dissatisfied;
  }

  Color _getEmojiColor(double level) {
    if (level < 25) return Colors.green;
    if (level < 75) return Colors.yellow;
    return Colors.red;
  }

  String _getSizeCategory(double height) {
    if (height < 30) return 'Small';
    if (height < 70) return 'Medium';
    return 'Large';
  }

  String getTimeAgo(num? lastUpdatedSeconds) {
    if (lastUpdatedSeconds == null || lastUpdatedSeconds <= 0) return "N/A";
    final lastUpdatedMillis = lastUpdatedSeconds * 1000;
    final currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    final int timeDifferenceMillis =
        currentTimeMillis - lastUpdatedMillis.toInt();
    final timeDifferenceSeconds = timeDifferenceMillis ~/ 1000;

    if (timeDifferenceSeconds < 60) {
      return "$timeDifferenceSeconds seconds ago";
    } else if (timeDifferenceSeconds < 3600) {
      return "${timeDifferenceSeconds ~/ 60} minutes ago";
    } else if (timeDifferenceSeconds < 86400) {
      return "${timeDifferenceSeconds ~/ 3600} hours ago";
    } else {
      return "${timeDifferenceSeconds ~/ 86400} days ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    final double fill = double.tryParse(fillLevel ?? "0.0") ?? 0.0;
    final double h = double.tryParse(height ?? "0.0") ?? 0.0;
    final String lastUpdatedText =
        getTimeAgo(double.tryParse(lastUpdatedTime ?? '0')?.toInt() ?? 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(binName, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(width: 20),
                Icon(_getEmoji(fill), color: _getEmojiColor(fill)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8),
                Text('Last Updated: $lastUpdatedText'),
                const Spacer(),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: PrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _getSizeCategory(h),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: fill / 100,
                    backgroundColor: Colors.grey.shade300,
                    color: _getEmojiColor(fill),
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
