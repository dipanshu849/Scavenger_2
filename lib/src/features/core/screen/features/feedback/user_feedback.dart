import 'dart:io';
import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';

void feedback(BuildContext context) {
  BetterFeedback.of(context).show(
    (UserFeedback feedback) async {
      try {
        final screenshotPath =
            await _writeScreenshotToStorage(feedback.screenshot);
        final email = Email(
          attachmentPaths: [screenshotPath],
          body: feedback.text,
          recipients: ['dipanshu849d@gmail.com'],
          subject: 'Issue Reporting',
        );

        await FlutterEmailSender.send(email);
      } catch (e) {
        // Handle errors here
        print("Error sending feedback: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send feedback: $e")),
        );
      }
    },
  );
}

Future<String> _writeScreenshotToStorage(Uint8List screenshot) async {
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/feedback.png';
  final file = File(filePath);

  await file.writeAsBytes(screenshot);

  return filePath;
}
