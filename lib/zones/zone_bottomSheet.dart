import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'zones_model.dart';
export 'zones_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ZoneBottomsheet extends StatefulWidget {
  const ZoneBottomsheet({super.key});

  @override
  State<ZoneBottomsheet> createState() => _ZoneBottomsheetState();
}

class _ZoneBottomsheetState extends State<ZoneBottomsheet> {
  late ZonesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> zones = []; // Specify the type of the list

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZonesModel());
    getZonesData();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> getZonesData() async {
    try {
      final Uri url =
          Uri.parse('https://minicaboffice.com/api/driver/zones.php');
      final response = await http.get(url);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        var data = jsonResponse['data'];

        // Ensure to map the dynamic list to a list of strings
        setState(() {
          zones = List<String>.from(data
              .map((zone) => zone['zone_name'] as String)); // Corrected line
          print('Successfully fetched zones: $zones');
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! > 20) {
          // Close the BottomSheet on a downward swipe
          Navigator.pop(context);
        }
      },
      child: DraggableScrollableSheet(builder: (context, scrollController) {
        return Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Zone List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                zones.isEmpty
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Show loading indicator
                    : Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: zones.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: ListTile(
                                title:
                                    Text(zones[index]), // Display the zone name
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ));
      }),
    );
  }
}
