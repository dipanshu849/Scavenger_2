import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scavenger_2/src/common_widgets/buttons/button_loading_widget.dart';
import 'package:timeline_tile/timeline_tile.dart'; // For timeline
import 'dart:io';

import 'package:scavenger_2/src/constants/sizes.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({Key? key}) : super(key: key);

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  String? _complaintDescription;
  File? _imageFile;
  bool _isLoading = false;

  // Dummy data for timeline status updates
  final List<Map<String, String>> _complaintTimeline = [
    {'status': 'Submitted', 'date': '2024-11-01', 'time': '10:00 AM'},
    {'status': 'Received', 'date': '2024-11-02', 'time': '11:00 AM'},
    {'status': 'In Progress', 'date': '2024-11-05', 'time': '02:30 PM'},
    {'status': 'Resolved', 'date': '2024-11-10', 'time': '03:15 PM'},
  ];

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulate a delay for submission
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Complaint submitted successfully!')),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complain',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DefaultSize),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedCategory,
                    onChanged: (newValue) =>
                        setState(() => _selectedCategory = newValue),
                    items: [
                      'Garbage Collection',
                      'Fine',
                      'Bin Overflow',
                      'Other'
                    ]
                        .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                        .toList(),
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  ),
                  const SizedBox(height: 16.0),

                  // Complaint Description
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Complaint Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    onChanged: (value) => _complaintDescription = value,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a description'
                        : null,
                  ),
                  const SizedBox(height: 16.0),

                  // Optional Image Upload
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12)),
                  ),
                  if (_imageFile != null) ...[
                    const SizedBox(height: 16.0),
                    Image.file(
                      _imageFile!,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ],
                  const SizedBox(height: 24.0),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitComplaint,
                      child: _isLoading
                          ? const ButtonLoadingWidget()
                          : const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 40.0),

                  // Timeline Section
                  const Text('Complaint Status',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _complaintTimeline.length,
                    itemBuilder: (context, index) {
                      final item = _complaintTimeline[index];
                      return TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        indicatorStyle: IndicatorStyle(
                          width: 30,
                          iconStyle: IconStyle(iconData: Icons.check),
                          color: index == _complaintTimeline.length - 1
                              ? Colors.green
                              : Colors.blue,
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['status']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text('${item['date']} at ${item['time']}'),
                            ],
                          ),
                        ),
                        isFirst: index == 0,
                        isLast: index == _complaintTimeline.length - 1,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
