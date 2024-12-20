import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeViewWidget extends StatelessWidget {
  final String userId;

  const QRCodeViewWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: userId,
        version: QrVersions.auto,
        size: 300.0,
        errorStateBuilder: (cxt, err) {
          return const Center(
            child: Text('Uh oh! Something went wrong...'),
          );
        },
      ),
    );
  }
}
