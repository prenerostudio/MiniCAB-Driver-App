import 'dart:isolate';

import 'package:system_alert_window/system_alert_window.dart';

import '../Data/overlay.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'zones_model.dart';
export 'zones_model.dart';
import 'package:http/http.dart' as http;
import '../Model/Zone.dart';
import 'dart:convert';

class ZonesWidget extends StatefulWidget {
  const ZonesWidget({Key? key}) : super(key: key);

  @override
  _ZonesWidgetState createState() => _ZonesWidgetState();
}

class _ZonesWidgetState extends State<ZonesWidget> {
  late ZonesModel _model;
  ScrollController controller = ScrollController();
  List<Zone> zones = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    // _initPlatformState();

    _model = createModel(context, () => ZonesModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }
  String _platformVersion = 'Unknown';
  bool _isShowingWindow = false;
  bool _isUpdatedWindow = false;
  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
  static const String _mainAppPort = 'MainApp';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? latestMessageFromOverlay;

  // Future<void> _initPlatformState() async {
  //   await SystemAlertWindow.enableLogs(true);
  //   String? platformVersion;
  //   try {
  //     platformVersion = await SystemAlertWindow.platformVersion;
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }
  //   if (!mounted) return;
  //   if (platformVersion != null) {
  //     setState(() {
  //       _platformVersion = platformVersion!;
  //     });
  //   }
  // }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }

  // void _showOverlayWindow() async {
  //   if (!_isShowingWindow) {
  //     await SystemAlertWindow.sendMessageToOverlay('show system window');
  //     SystemAlertWindow.showSystemWindow(
  //       height: 200,
  //       width: MediaQuery.of(context).size.width.floor(),
  //       gravity: SystemWindowGravity.CENTER,
  //       prefMode: prefMode,
  //     );
  //     setState(() {
  //       _isShowingWindow = true;
  //     });
  //   } else if (!_isUpdatedWindow) {
  //     await SystemAlertWindow.sendMessageToOverlay('update system window');
  //     SystemAlertWindow.updateSystemWindow(
  //       height: 200,
  //       width: MediaQuery.of(context).size.width.floor(),
  //       gravity: SystemWindowGravity.CENTER,
  //       prefMode: prefMode,
  //       isDisableClicks: true,
  //     );
  //     setState(() {
  //       _isUpdatedWindow = true;
  //     });
  //   } else {
  //     SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
  //     setState(() {
  //       _isShowingWindow = false;
  //       _isUpdatedWindow = false;
  //     });
  //     await SystemAlertWindow.sendMessageToOverlay('close system window');
  //   }
  // }


  Future<List<Zone>> getZonesData() async {
    final Uri url = Uri.parse('https://minicaboffice.com/api/driver/zones.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((item) => Zone.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
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
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 60,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 30,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
            title: Text(
              'Zones',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).primary,
                fontSize: 22,
              ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2,
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Padding(
              padding:
              EdgeInsetsDirectional.fromSTEB(12, 0, 12,50),
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      16, 16, 16, 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<List<Zone>>(
                          future: getZonesData(), // Use the function to fetch data
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.3, // 30% padding from the top
                                  ),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(
                                            context)
                                            .primary),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return  Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.3, // 30% padding from the top
                                  ),
                                  child:  Text('No Zones available.'),
                                ),
                              );
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.3, // 30% padding from the top
                                  ),
                                  child:  Text('No Zones available.'),
                                ),
                              );
                            } else {
                              final data = snapshot.data;

                              return ListView.builder(
                                controller: controller,
                                itemCount: data!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  final zoneItem = data[index];
                                  return  InkWell(
                                    onTap: (){
                                      print('start');

                                      // _initPlatformState();
                                      // _showOverlayWindow();
                                      print('end');

                                    },
                                    child: Padding(
                                      padding:
                                      EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 5),
                                      child: Container(
                                        width: MediaQuery.sizeOf(context)
                                            .width,
                                        decoration: BoxDecoration(
                                          color:
                                          FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                          BorderRadius.circular(0),
                                        ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Wrap(
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min, // Set this to MainAxisSize.min
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_circle_up,
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .primary,
                                                        size:
                                                        18.0, // Decrease the icon size
                                                      ),
                                                      Flexible(
                                                        // Wrap the Text widget with Flexible
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              10.0,
                                                              10.0,
                                                              0.0,
                                                              20.0),
                                                          child: Text(
                                                            '${zoneItem.startingPoint}',

                                                            style: FlutterFlowTheme.of(
                                                                context)
                                                                .labelMedium
                                                                .override(
                                                              fontFamily:
                                                              'Readex Pro',
                                                              color: FlutterFlowTheme.of(
                                                                  context)
                                                                  .secondaryText,
                                                              fontSize:
                                                              15.0,
                                                            ),
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis, // Handle text overflow with ellipsis
                                                            maxLines:
                                                            3, // Limit to a maximum of 2 lines
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Wrap(
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min, // Set this to MainAxisSize.min
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .arrow_circle_down,
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .primary,
                                                        size:
                                                        18.0, // Decrease the icon size
                                                      ),
                                                      Flexible(
                                                        // Wrap the Text widget with Flexible
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              10.0,
                                                              10.0,
                                                              0.0,
                                                              20.0),
                                                          child: Text(
                                                            '${zoneItem.endPoint}',

                                                            style: FlutterFlowTheme.of(
                                                                context)
                                                                .labelMedium
                                                                .override(
                                                              fontFamily:
                                                              'Readex Pro',
                                                              color: FlutterFlowTheme.of(
                                                                  context)
                                                                  .secondaryText,
                                                              fontSize:
                                                              15.0,
                                                            ),
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis, // Handle text overflow with ellipsis
                                                            maxLines:
                                                            3, // Limit to a maximum of 2 lines
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    0, 4, 0, 12),
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Distance',
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .titleLarge
                                                          .override(
                                                        fontFamily:
                                                        'Outfit',
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(0,
                                                          5, 0, 0),
                                                      child: Expanded(
                                                        child: Text(
                                                          '${zoneItem.distance}km',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            fontSize:  MediaQuery.sizeOf(context).width * 0.03,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsetsDirectional
                                                    .fromSTEB(
                                                    10, 10, 10, 10),
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Fare',
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .titleLarge
                                                          .override(
                                                        fontFamily:
                                                        'Outfit',
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      '£${zoneItem.fare}',
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium
                                                          .override(
                                                        fontFamily:
                                                        'Readex Pro',
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                thickness: 1,
                                                color: Color(0xCCC3C2C2),
                                              ),
                                            ],
                                          ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

                ],
              ),
            ),
          ),
        ),
    );

  }
}
