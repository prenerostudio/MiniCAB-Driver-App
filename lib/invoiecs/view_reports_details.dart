import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class WeekDetailScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? weekData;

  WeekDetailScreen({required this.weekData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Week Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              await _requestPermission(); // Request permission before saving PDF
              final filePath = await _generatePdf();
              if (filePath != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('PDF saved successfully at $filePath')),
                );
              }
            },
          ),
        ],
      ),
      body: weekData == null || weekData!.isEmpty
          ? Center(child: Text('No data available'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                dataRowHeight: 100,
                columns: [
                  DataColumn(
                      label: Text('Inv ID', style: TextStyle(fontSize: 14))),
                  DataColumn(label: Text('Job Details')),
                  DataColumn(label: Text('Driver Name')),
                  DataColumn(label: Text('Customer Name')),
                  DataColumn(label: Text('Job Fare')),
                  DataColumn(label: Text('Driver Commission')),
                ],
                rows: weekData!.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data['invoice_id'] ?? '')),
                    DataCell(Text(
                        '${data['pickup']}\n ---> \n${data['destination']}')),
                    DataCell(Text(data['d_name'] ?? '')),
                    DataCell(Text(data['c_name'] ?? '')),
                    DataCell(Text(data['journey_fare'] ?? '')),
                    DataCell(Text(data['driver_commission'] ?? '')),
                  ]);
                }).toList(),
              ),
            ),
    );
  }

  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (status.isGranted) {
      print('Permission already granted');
      return;
    } else if (status.isDenied || status.isRestricted) {
      // Request permission
      status = await Permission.photos.request();
      if (status.isGranted) {
        print('Permission granted');
      } else {
        print('Permission denied');
      }
    } else if (status.isPermanentlyDenied) {
      print('Permission permanently denied. Please enable it from settings.');
      // You might want to guide the user to open app settings to grant permission manually
      openAppSettings();
    }
  }

  Future<String?> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: [
              'Invoice ID',
              'Job Details',
              'Driver Name',
              'Customer Name',
              'Job Fare',
              'Driver Commission'
            ],
            data: weekData!.map((data) {
              return [
                data['invoice_id'],
                data['pickup'] + ' ---> ' + data['destination'],
                data['d_name'],
                data['c_name'],
                data['journey_fare'],
                data['driver_commission']
              ];
            }).toList(),
          );
        },
      ),
    );

    try {
      final directory = await getExternalStorageDirectory();
      final customDir = Directory("${directory!.path}/MyCustomFolder/PDFs");

      // Create the directory if it doesn't exist
      if (!(await customDir.exists())) {
        await customDir.create(recursive: true);
      }

      final file = File("${customDir.path}/week_details.pdf");
      await file.writeAsBytes(await pdf.save());
      print('PDF saved to: ${file.path}');
      return file.path;
    } catch (e) {
      print('Error saving PDF: $e');
      return null;
    }
  }
}
