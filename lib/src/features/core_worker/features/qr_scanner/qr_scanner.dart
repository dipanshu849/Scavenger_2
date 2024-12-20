import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scavenger_2/src/features/core/model/user_model.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  String? qrCode;
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _cameraController,
              onDetect: (barcode) {
                if (barcode.barcodes.isNotEmpty &&
                    barcode.barcodes.first.rawValue != null) {
                  setState(() {
                    qrCode = barcode.barcodes.first.rawValue!;
                  });
                  _cameraController.stop();
                  _onDetect(qrCode!); // Process scanned QR code
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              qrCode != null ? 'Scan result: $qrCode' : 'Scan a QR code',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                qrCode = null;
              });
              _cameraController.start();
            },
            child: const Padding(
                padding: EdgeInsets.all(8), child: Text('Scan Again')),
          ),
        ],
      ),
    );
  }

  void _onDetect(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    if (userDoc.exists) {
      final user = UserModel.fromSnapshot(userDoc);

      if (user.pickupStatus) {
        // If already picked up, show the timestamp
        if (mounted) {
          final pickedUpDate = user.pickupTimestamp != null
              ? user.pickupTimestamp!.toDate().toString()
              : "unknown date";
          _showSnackBar(
            context,
            'Waste was already picked up on $pickedUpDate.',
          );
        }
        // Ask to add a fine, regardless of pickup status
        _askForFine(uid);
      } else {
        // Mark the user as picked up and update the timestamp
        final timestamp = Timestamp.now();
        await FirebaseFirestore.instance.collection('Users').doc(uid).update({
          'PickupStatus': true,
          'PickupTimestamp': timestamp,
        });

        if (mounted) {
          _showSnackBar(
            context,
            'Waste marked as picked up for ${user.fullName}.',
          );
          _askForFine(uid); // Ask if the worker wants to add a fine
        }
      }
    } else {
      if (mounted) {
        _showSnackBar(context, 'User not found.');
      }
    }
  }

  // void _askForFine(String uid) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Add Fine?'),
  //         content: const Text('Do you want to add a fine for this user?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //               _showFineDialog(uid); // Show fine dialog if they agree
  //             },
  //             child: const Text('Yes'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Close the dialog
  //             },
  //             child: const Text('No'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _askForFine(String uid) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Fine',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Do you want to add a fine for this user?',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                      _showFineDialog(uid); // Show detailed fine dialog
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Fine'),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showFineDialog(String uid) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       String reason = '';
  //       return AlertDialog(
  //         title: const Text('Add Fine'),
  //         content: TextField(
  //           onChanged: (value) => reason = value,
  //           decoration: const InputDecoration(labelText: 'Reason for fine'),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               _addFine(
  //                   uid, reason, 'photo_url_here'); // Add actual photo URL here
  //             },
  //             child: const Text('Add Fine'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _showFineDialog(String uid) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      builder: (context) {
        String reason = '';
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Fine Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter the reason for the fine:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                onChanged: (value) => reason = value,
                maxLength: 100,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Reason',
                  hintText: 'Enter the reason here...',
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addFine(uid, reason, 'photo_url_here');
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Submit Fine'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addFine(String uid, String reason, String photoUrl) async {
    final currentTimestamp = Timestamp.now();

    final fineData = {
      'reason': reason,
      'photoUrl': photoUrl,
      'timestamp': currentTimestamp,
    };

    await FirebaseFirestore.instance.collection('Users').doc(uid).update({
      'Fines': FieldValue.arrayUnion([fineData]),
      'FineAdded': true, // Mark that a fine has been added
    });

    if (mounted) {
      _showSnackBar(context, 'Fine added for user.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
