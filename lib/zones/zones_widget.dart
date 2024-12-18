import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'zones_model.dart';
export 'zones_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ZonesWidget extends StatefulWidget {
  const ZonesWidget({Key? key}) : super(key: key);

  @override
  _ZonesWidgetState createState() => _ZonesWidgetState();
}

class _ZonesWidgetState extends State<ZonesWidget> {
  late ZonesModel _model;
  ScrollController controller = ScrollController();

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
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 30),
            color: FlutterFlowTheme.of(context).primary,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Zones List',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primary,
                  fontSize: 22,
                ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: zones.isEmpty
            ? Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : ListView.builder(
                itemCount: zones.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: ListTile(
                      title: Text(zones[index]), // Display the zone name
                    ),
                  );
                },
              ),
      ),
    );
  }
}
