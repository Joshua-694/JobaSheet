import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobasheet/src/common_widgets/classes.dart';
import 'package:jobasheet/src/constants/image_string.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class InspectionForm extends StatefulWidget {
  @override
  _InspectionFormState createState() => _InspectionFormState();
}

class _InspectionFormState extends State<InspectionForm> {
  final _formKey = GlobalKey<FormState>();
  final _activityController = TextEditingController();
  final _observationsController = TextEditingController();
  String? _imagePath;
  List<InspectionRecord> _inspections = [];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Building Inspection Form')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _activityController,
                decoration: InputDecoration(labelText: 'Activity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the activity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _observationsController,
                decoration: InputDecoration(labelText: 'Observations'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your observations';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _imagePath == null
                  ? Text('No image selected.')
                  : Image.file(File(_imagePath!)),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Capture Image'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _imagePath != null) {
                    _addInspection(InspectionRecord(
                      activity: _activityController.text,
                      observations: _observationsController.text,
                      imagePath: _imagePath!,
                      dateTime: DateTime.now(), // Add current date and time
                    ));
                  }
                },
                child: Text('Add Inspection'),
              ),
              SizedBox(height: 20),
              _inspections.isEmpty
                  ? Text('No inspections yet.')
                  : ElevatedButton(
                      onPressed: _generateAndOpenPdf,
                      child: Text('Generate and View PDF'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _addInspection(InspectionRecord inspection) {
    setState(() {
      _inspections.add(inspection);
      _activityController.clear();
      _observationsController.clear();
      _imagePath = null;
    });
  }

  Future<void> _generateAndOpenPdf() async {
    final pdf = pw.Document();
    final Uint8List logoImageBytes = await getImageBytes(DrawerImage);

    for (var inspection in _inspections) {
      final Uint8List inspectionImageBytes =
          await File(inspection.imagePath).readAsBytes();

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Column(
                      children: [
                        pw.Image(pw.MemoryImage(logoImageBytes),
                            width: 60, height: 40),
                        pw.Text('Jobasheet Inspection Report',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                          'Inspection Date and Time: ${_formatDateTime(inspection.dateTime)}',
                          textAlign: pw.TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Text('Activity: ${inspection.activity}'),
                pw.SizedBox(height: 10),
                pw.Text('Observations: ${inspection.observations}'),
                pw.SizedBox(height: 10),
                pw.Image(pw.MemoryImage(inspectionImageBytes),
                    width: 200, height: 200),
              ],
            );
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/JobasheetInspectionReport.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open the generated PDF immediately after generating
    await OpenFile.open(file.path);
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  Future<Uint8List> getImageBytes(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    return data.buffer.asUint8List();
  }
}
