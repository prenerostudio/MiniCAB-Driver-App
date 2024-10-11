import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mini_cab/Acount%20Statements/accountStatementDetails.dart';
import 'package:mini_cab/Model/invoivce.dart';
import 'package:mini_cab/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/invoiceDetails.dart';
import '/components/filter_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'acount_statements_model.dart';
export 'acount_statements_model.dart';

class AcountStatementsWidget extends StatefulWidget {
  const AcountStatementsWidget({super.key});

  @override
  State<AcountStatementsWidget> createState() => _AcountStatementsWidgetState();
}

class _AcountStatementsWidgetState extends State<AcountStatementsWidget>
    with TickerProviderStateMixin {
  late AcountStatementsModel _model;

  ScrollController controller = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String total = '00.00';
  @override
  void initState() {
    super.initState();
    totalearning();
    _model = createModel(context, () => AcountStatementsModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> totalearning() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://www.minicaboffice.com/api/driver/total-earnings-last-week.php'),
    );
    request.fields.addAll({
      'd_id': dId.toString(),
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      total = jsonResponse['total_amount'] ?? '0.00';
      print(total);
      setState(() {
        total = total;
      });
      print('weakly earning: $total');
    } else {
      print('Failed to fetch data: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> fetchInvoiceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://www.minicaboffice.com/api/driver/earning-last-job.php'));
    request.fields.addAll({'d_id': dId.toString()});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);
    } else {
      throw Exception('Failed to load invoice data');
    }
  }

  // Future<Invoice> lastJob() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? dId = prefs.getString('d_id');

  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse(
  //         'https://www.minicaboffice.com/api/driver/earning-last-job.php'),
  //   );
  //   request.fields.addAll({'d_id': dId.toString()});

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     String responseBody = await response.stream.bytesToString();
  //     Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

  //     // Access the correct key in the JSON response
  //     if (jsonResponse.containsKey('data') && jsonResponse['data'] != null) {
  //       return Invoice.fromJson(jsonResponse['data']);
  //     } else {
  //       return jsonResponse['message'];
  //     }
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
  Future<List<Invoice>> lastJob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    final uri = Uri.parse(
        'https://www.minicaboffice.com/api/driver/earning-last-job.php');
    final response = await http.post(uri, body: {'d_id': dId.toString()});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'] ?? [];
      print('st the response is ${jsonResponse['data']}');
      if (data is List) {
        List<Invoice> paymentData =
            data.map((item) => Invoice.fromJson(item)).cast<Invoice>().toList();
        print(paymentData);
        return paymentData;
      } else {
        print('Invalid data format received.');
        return [];
      }
    } else {
      print('Error: ${response.reasonPhrase}');
      return [];
    }
  }

  Future<List<Invoice>> todayJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    final uri =
        Uri.parse('https://www.minicaboffice.com/api/driver/earning-today.php');
    final response = await http.post(uri, body: {'d_id': dId.toString()});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'] ?? [];
      if (data is List) {
        List<Invoice> paymentData =
            data.map((item) => Invoice.fromJson(item)).cast<Invoice>().toList();
        print(paymentData);
        return paymentData;
      } else {
        print('Invalid data format received.');
        return [];
      }
    } else {
      print('Error: ${response.reasonPhrase}');
      return [];
    }
  }

  Future<List<Invoice>> lastWeekJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    final uri = Uri.parse(
        'https://www.minicaboffice.com/api/driver/earning-last-week.php');
    final response = await http.post(uri, body: {'d_id': dId.toString()});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'] ?? [];
      if (data is List) {
        List<Invoice> paymentData =
            data.map((item) => Invoice.fromJson(item)).cast<Invoice>().toList();
        print(paymentData);
        return paymentData;
      } else {
        print('Invalid data format received.');
        return [];
      }
    } else {
      print('Error: ${response.reasonPhrase}');
      return [];
    }
  }

  Future<void> generateAndSavePdf(String start, String end) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('https://www.minicaboffice.com/api/driver/report.php'));
      request.fields.addAll({
        'd_id': dId.toString(),
        'start_date': start,
        'end_date': end,
      });
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final jsonResponse = await response.stream.bytesToString();
        List<dynamic> data = jsonDecode(jsonResponse)['data'];
        int totalCommission =
            jsonDecode(jsonResponse)['total_Commission_amount'];

        final pdf = pw.Document();
        pdf.addPage(
          pw.Page(
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Table.fromTextArray(
                    cellAlignment: pw.Alignment.center,
                    cellPadding: pw.EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 3.0), // Adjust as needed
                    headerDecoration: pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    headers: [
                      'Job ID',
                      'Total Pay',
                      'Pick Time',
                      'Pick Date',
                      'pickup - destination',
                      'Total Pay Amount'
                    ],
                    data: data.map<List<String>>((item) {
                      return [
                        item['job_id'].toString(),
                        item['total_pay'].toString(),
                        item['pick_time'].toString(),
                        item['pick_date'].toString(),
                        '${item['pickup']} -\n ${item['destination']}',
                        item['total_pay_amount'].toString()
                      ];
                    }).toList(),
                    tableWidth: pw.TableWidth.max,
                    cellHeight: 40.0,
                  ),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                  pw.Text('Total Commission Amount: $totalCommission'),
                ],
              );
            },
          ),
        );

        final directory = await getExternalStorageDirectory();
        final pdfPath = '${directory!.path}/invoice.pdf';
        final file = File(pdfPath);
        await file.writeAsBytes(await pdf.save());
        OpenFile.open(file.path);
        print('PDF saved to: $pdfPath');
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  DateTime? lastBackPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          // if (lastBackPressed == null ||
          //     DateTime.now().difference(lastBackPressed!) >
          //         Duration(seconds: 2)) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Press again to exit')),
          //   );
          //   lastBackPressed = DateTime.now();
          //   return true;
          // } else {
          //   SystemNavigator.pop();
          //   return true;
          // }
          return true;
        },
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NavBarPage(initialPage: 'Dashboard')));
              },
            ),
            title: Text(
              'Account Statement',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Open Sans',
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 22,
                    letterSpacing: 0,
                  ),
            ),
            centerTitle: true,
            elevation: 2,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Earning',
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Open Sans',
                            ),
                      ),
                      Text(
                        '£ ${total}',
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Open Sans',
                              fontSize: 25,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // FFButtonWidget(
                      //   onPressed: () async {
                      //     context.pushNamed('PDFInvoice');
                      //   },
                      //   text: 'Export To PDF',
                      //   options: FFButtonOptions(
                      //     height: 40,
                      //     padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      //     iconPadding:
                      //         EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      //     color: FlutterFlowTheme.of(context).primaryBackground,
                      //     textStyle:
                      //         FlutterFlowTheme.of(context).titleSmall.override(
                      //               fontFamily: 'Open Sans',
                      //               color: FlutterFlowTheme.of(context).primary,
                      //               letterSpacing: 0,
                      //             ),
                      //     elevation: 3,
                      //     borderSide: BorderSide(
                      //       color: FlutterFlowTheme.of(context).primary,
                      //       width: 1,
                      //     ),
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment(0, 0),
                        child: TabBar(
                          labelColor: FlutterFlowTheme.of(context).primary,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          labelStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Open Sans',
                                    letterSpacing: 0,
                                  ),
                          unselectedLabelStyle: TextStyle(),
                          indicatorColor: FlutterFlowTheme.of(context).primary,
                          padding: EdgeInsets.all(4),
                          tabs: [
                            Tab(
                              text: 'Last job',
                            ),
                            Tab(
                              text: 'Today jobs',
                            ),
                            Tab(
                              text: 'Weekly jobs',
                            ),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [
                              () async {},
                              () async {},
                              () async {},
                            ][i]();
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          children: [
                            //tab 1
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: FutureBuilder<List<Invoice>>(
                                future: lastJob(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Invoice>> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Display a loading indicator while waiting for data
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2, // 30% padding from the top
                                        ),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  FlutterFlowTheme.of(context)
                                                      .primary),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2, // 30% padding from the top
                                        ),
                                        child: Text('No Data Found'),
                                      ),
                                    );
                                  } else if (snapshot.hasData) {
                                    final data = snapshot.data!;
                                    if (data.isEmpty) {
                                      // Display "No data available" when the list is empty
                                      return Center(
                                        child: Text('No data available'),
                                      );
                                    }
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 15, 0, 0),
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final invoice = data[index];
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 10, 0, 10),
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 3,
                                              child: InkWell(
                                                onTap: () {
                                                  print('object');
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => AccountStatementDetails(
                                                              totalFee:
                                                                  invoice.totalPay ??
                                                                      '0',
                                                              jounreryFare: invoice
                                                                  .journeyFare!,
                                                              parking: invoice
                                                                  .carParking!,
                                                              tolls: invoice
                                                                  .tolls!,
                                                              did: invoice.dId!,
                                                              waiting: invoice
                                                                  .waiting!,
                                                              time: invoice
                                                                  .pickTime!,
                                                              jobid: invoice
                                                                  .jobId!,
                                                              pickupDate: invoice
                                                                  .pickDate!,
                                                              pickUplocation:
                                                                  invoice
                                                                      .pickup!,
                                                              dropOflocation:
                                                                  invoice
                                                                      .destination!,
                                                              pickupTime: invoice
                                                                  .pickTime!,
                                                              extra: invoice
                                                                  .extra!)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        7,
                                                                        10,
                                                                        7,
                                                                        5),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      'Booking ID ',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${invoice.bookId}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .timer_sharp,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      '${invoice.pickTime}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Outfit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .date_range,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      '${invoice.pickDate}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Outfit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_circle_up,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        '${invoice.pickup}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_circle_down,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        '${invoice.destination}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .payment,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Total fare : ${invoice.totalPay}',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 20),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // Padding(
                                                              //   padding:
                                                              //       EdgeInsetsDirectional
                                                              //           .fromSTEB(
                                                              //               0,
                                                              //               20,
                                                              //               0,
                                                              //               20),
                                                              //   child:
                                                              //       FFButtonWidget(
                                                              //     onPressed:
                                                              //         () async {
                                                              //       context
                                                              //           .pushNamed(
                                                              //         'AccountDetails',
                                                              //         queryParameters:
                                                              //             {
                                                              //           'Id':
                                                              //               serializeParam(
                                                              //             '${invoice.invoiceId}',
                                                              //             ParamType
                                                              //                 .String,
                                                              //           ),
                                                              //         }.withoutNulls,
                                                              //       );
                                                              //     },
                                                              //     text: 'View',
                                                              //     icon: Icon(
                                                              //       Icons
                                                              //           .remove_red_eye_outlined,
                                                              //       size: 15,
                                                              //     ),
                                                              //     options:
                                                              //         FFButtonOptions(
                                                              //       width: MediaQuery.sizeOf(
                                                              //                   context)
                                                              //               .width *
                                                              //           0.8,
                                                              //       height: 40,
                                                              //       padding: EdgeInsetsDirectional
                                                              //           .fromSTEB(
                                                              //               24,
                                                              //               0,
                                                              //               24,
                                                              //               0),
                                                              //       iconPadding:
                                                              //           EdgeInsetsDirectional
                                                              //               .fromSTEB(
                                                              //                   0,
                                                              //                   0,
                                                              //                   0,
                                                              //                   0),
                                                              //       color: FlutterFlowTheme.of(
                                                              //               context)
                                                              //           .primary,
                                                              //       textStyle: FlutterFlowTheme.of(
                                                              //               context)
                                                              //           .titleSmall
                                                              //           .override(
                                                              //             fontFamily:
                                                              //                 'Readex Pro',
                                                              //             color: Colors
                                                              //                 .white,
                                                              //           ),
                                                              //       elevation: 3,
                                                              //       borderSide:
                                                              //           BorderSide(
                                                              //         color: Colors
                                                              //             .transparent,
                                                              //         width: 1,
                                                              //       ),
                                                              //       borderRadius:
                                                              //           BorderRadius
                                                              //               .circular(
                                                              //                   8),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return Center(
                                        child: Text('No data available'));
                                  }
                                },
                              ),
                            ),
                            //tab 2
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: FutureBuilder<List<Invoice>>(
                                future: todayJobs(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Invoice>> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Display a loading indicator while waiting for data
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2, // 30% padding from the top
                                        ),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  FlutterFlowTheme.of(context)
                                                      .primary),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2, // 30% padding from the top
                                        ),
                                        child: Text('No Data Found'),
                                      ),
                                    );
                                  } else {
                                    final invoiceData = snapshot.data;
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 15, 0, 0),
                                      child: ListView.builder(
                                        controller: controller,
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: invoiceData!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final invoice = invoiceData[index];
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 10, 0, 10),
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 3,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => AccountStatementDetails(
                                                              totalFee:
                                                                  invoice.totalPay ??
                                                                      '0',
                                                              jounreryFare: invoice
                                                                  .journeyFare!,
                                                              parking: invoice
                                                                  .carParking!,
                                                              tolls: invoice
                                                                  .tolls!,
                                                              did: invoice.dId!,
                                                              waiting: invoice
                                                                  .waiting!,
                                                              time: invoice
                                                                  .pickTime!,
                                                              jobid: invoice
                                                                  .jobId!,
                                                              pickupDate: invoice
                                                                  .pickDate!,
                                                              pickUplocation:
                                                                  invoice
                                                                      .pickup!,
                                                              dropOflocation:
                                                                  invoice
                                                                      .destination!,
                                                              pickupTime: invoice
                                                                  .pickTime!,
                                                              extra: invoice
                                                                  .extra!)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    // onTap: () async {
                                                    //   context.pushNamed(
                                                    //     'AccountDetails',
                                                    //     queryParameters: {
                                                    //       'Invoice ID  ': serializeParam(
                                                    //         '${invoice.invoiceId}',
                                                    //         ParamType.String,
                                                    //       ),
                                                    //     }.withoutNulls,
                                                    //   );
                                                    // },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          // Generated code for this Row Widget...
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        7,
                                                                        10,
                                                                        7,
                                                                        5),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      'Booking ID ',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${invoice.bookId}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // Generated code for this Row Widget...
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .timer_sharp,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      '${invoice.pickTime}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Outfit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                children: [
                                                                  // Text(
                                                                  //     'Fare: ${invoice.journeyFare.toString()}'),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .date_range,
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primary,
                                                                          size:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          '${invoice.pickDate}',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .labelMedium
                                                                              .override(
                                                                                fontFamily: 'Outfit',
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_circle_up,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        '${invoice.pickup}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_circle_down,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        '${invoice.destination}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .payment,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Total fare : ${invoice.totalPay}',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 20),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // Padding(
                                                              //   padding:
                                                              //       EdgeInsetsDirectional
                                                              //           .fromSTEB(
                                                              //               0,
                                                              //               20,
                                                              //               0,
                                                              //               20),
                                                              //   child:
                                                              //       FFButtonWidget(
                                                              //     onPressed:
                                                              //         () async {
                                                              //       context
                                                              //           .pushNamed(
                                                              //         'AccountDetails',
                                                              //         queryParameters:
                                                              //             {
                                                              //           'Id':
                                                              //               serializeParam(
                                                              //             '${invoice.invoiceId}',
                                                              //             ParamType
                                                              //                 .String,
                                                              //           ),
                                                              //         }.withoutNulls,
                                                              //       );
                                                              //     },
                                                              //     text: 'View',
                                                              //     icon: Icon(
                                                              //       Icons
                                                              //           .remove_red_eye_outlined,
                                                              //       size: 15,
                                                              //     ),
                                                              //     options:
                                                              //         FFButtonOptions(
                                                              //       width: MediaQuery.sizeOf(
                                                              //                   context)
                                                              //               .width *
                                                              //           0.8,
                                                              //       height: 40,
                                                              //       padding: EdgeInsetsDirectional
                                                              //           .fromSTEB(
                                                              //               24,
                                                              //               0,
                                                              //               24,
                                                              //               0),
                                                              //       iconPadding:
                                                              //           EdgeInsetsDirectional
                                                              //               .fromSTEB(
                                                              //                   0,
                                                              //                   0,
                                                              //                   0,
                                                              //                   0),
                                                              //       color: FlutterFlowTheme.of(
                                                              //               context)
                                                              //           .primary,
                                                              //       textStyle: FlutterFlowTheme.of(
                                                              //               context)
                                                              //           .titleSmall
                                                              //           .override(
                                                              //             fontFamily:
                                                              //                 'Readex Pro',
                                                              //             color: Colors
                                                              //                 .white,
                                                              //           ),
                                                              //       elevation: 3,
                                                              //       borderSide:
                                                              //           BorderSide(
                                                              //         color: Colors
                                                              //             .transparent,
                                                              //         width: 1,
                                                              //       ),
                                                              //       borderRadius:
                                                              //           BorderRadius
                                                              //               .circular(
                                                              //                   8),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            //tap 3
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: FutureBuilder<List<Invoice>>(
                                future: lastWeekJobs(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Invoice>> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2, // 30% padding from the top
                                        ),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  FlutterFlowTheme.of(context)
                                                      .primary),
                                        ),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2, // 30% padding from the top
                                        ),
                                        child: Text('No Data Found'),
                                      ),
                                    );
                                  } else {
                                    final invoiceData = snapshot.data;
                                    if (invoiceData!.isEmpty) {
                                      // Display "No data available" when the list is empty
                                      return Center(
                                        child: Text('No data available'),
                                      );
                                    }
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 15, 0, 0),
                                      child: ListView.builder(
                                        controller: controller,
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: invoiceData!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final invoice = invoiceData[index];
                                          return Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 10, 0, 10),
                                            child: Material(
                                              color: Colors.transparent,
                                              elevation: 3,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => AccountStatementDetails(
                                                              totalFee:
                                                                  invoice.totalPay ??
                                                                      '0',
                                                              jounreryFare: invoice
                                                                  .journeyFare!,
                                                              parking: invoice
                                                                  .carParking!,
                                                              tolls: invoice
                                                                  .tolls!,
                                                              did: invoice.dId!,
                                                              waiting: invoice
                                                                  .waiting!,
                                                              time: invoice
                                                                  .pickTime!,
                                                              jobid: invoice
                                                                  .jobId!,
                                                              pickupDate: invoice
                                                                  .pickDate!,
                                                              pickUplocation:
                                                                  invoice
                                                                      .pickup!,
                                                              dropOflocation:
                                                                  invoice
                                                                      .destination!,
                                                              pickupTime: invoice
                                                                  .pickTime!,
                                                              extra: invoice
                                                                  .extra!)));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                  ),
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    // onTap: () async {
                                                    //   context.pushNamed(
                                                    //     'AccountDetails',
                                                    //     queryParameters: {
                                                    //       'Invoice ID  ': serializeParam(
                                                    //         '${invoice.invoiceId}',
                                                    //         ParamType.String,
                                                    //       ),
                                                    //     }.withoutNulls,
                                                    //   );
                                                    // },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          // Generated code for this Row Widget...
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        7,
                                                                        10,
                                                                        7,
                                                                        5),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      'Booking ID ',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                    ),
                                                                    Text(
                                                                      '${invoice.bookId}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // Generated code for this Row Widget...
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .timer_sharp,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      '${invoice.pickTime}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Outfit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .date_range,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      size: 14,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      '${invoice.pickDate}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Outfit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_circle_up,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        '${invoice.pickup}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .arrow_circle_down,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        '${invoice.destination}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            15,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .payment,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                        size:
                                                                            24,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Total fare : ${invoice.totalPay}',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 20),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // Padding(
                                                              //   padding:
                                                              //       EdgeInsetsDirectional
                                                              //           .fromSTEB(
                                                              //               0,
                                                              //               20,
                                                              //               0,
                                                              //               20),
                                                              //   child:
                                                              //       FFButtonWidget(
                                                              //     onPressed:
                                                              //         () async {
                                                              //       context
                                                              //           .pushNamed(
                                                              //         'AccountDetails',
                                                              //         queryParameters:
                                                              //             {
                                                              //           'Id':
                                                              //               serializeParam(
                                                              //             '${invoice.invoiceId}',
                                                              //             ParamType
                                                              //                 .String,
                                                              //           ),
                                                              //         }.withoutNulls,
                                                              //       );
                                                              //     },
                                                              //     text: 'View',
                                                              //     icon: Icon(
                                                              //       Icons
                                                              //           .remove_red_eye_outlined,
                                                              //       size: 15,
                                                              //     ),
                                                              //     options:
                                                              //         FFButtonOptions(
                                                              //       width: MediaQuery.sizeOf(
                                                              //                   context)
                                                              //               .width *
                                                              //           0.8,
                                                              //       height: 40,
                                                              //       padding: EdgeInsetsDirectional
                                                              //           .fromSTEB(
                                                              //               24,
                                                              //               0,
                                                              //               24,
                                                              //               0),
                                                              //       iconPadding:
                                                              //           EdgeInsetsDirectional
                                                              //               .fromSTEB(
                                                              //                   0,
                                                              //                   0,
                                                              //                   0,
                                                              //                   0),
                                                              //       color: FlutterFlowTheme.of(
                                                              //               context)
                                                              //           .primary,
                                                              //       textStyle: FlutterFlowTheme.of(
                                                              //               context)
                                                              //           .titleSmall
                                                              //           .override(
                                                              //             fontFamily:
                                                              //                 'Readex Pro',
                                                              //             color: Colors
                                                              //                 .white,
                                                              //           ),
                                                              //       elevation: 3,
                                                              //       borderSide:
                                                              //           BorderSide(
                                                              //         color: Colors
                                                              //             .transparent,
                                                              //         width: 1,
                                                              //       ),
                                                              //       borderRadius:
                                                              //           BorderRadius
                                                              //               .circular(
                                                              //                   8),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
