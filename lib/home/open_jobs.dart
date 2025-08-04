import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:new_minicab_driver/Model/open_job_details.dart';
import 'package:new_minicab_driver/flutter_flow/flutter_flow_theme.dart';

import 'package:shared_preferences/shared_preferences.dart';

class OpenJobsSection extends StatefulWidget {
  const OpenJobsSection({Key? key}) : super(key: key);

  @override
  State<OpenJobsSection> createState() => _OpenJobsSectionState();
}

class _OpenJobsSectionState extends State<OpenJobsSection> {
  String baseUrl = 'https://minicaboffice.com/api/driver/open-bookings.php';

  Future<List<OpenJob>> fetchJobs() async {
    final response = await http.get(Uri.parse('$baseUrl'));
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    // debugPrint('the response is ${jsonResponse['data']}');
    if (response.statusCode == 200) {
      // Access the "data" field
      final List<dynamic> jobList = jsonResponse['data'];
      return jobList.map((json) => OpenJob.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future selectJob(
    String openId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? dId = prefs.getString('d_id');
      var fields = {
        'd_id': dId.toString(),
        'ob_id': openId.toString(),
      };
      var uri =
          Uri.parse('https://minicaboffice.com/api/driver/select-booking.php');

      var response = await http.post(
        uri,
        body: fields,
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        Fluttertoast.showToast(
          msg: jsonData['message'],
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {});
      } else {
        print('Failed to accept job. Status Code: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Open Jobs"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Open"),
              Tab(text: "My Jobs"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<OpenJob>>(
              future: fetchJobs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No jobs available'));
                }

                final jobs = snapshot.data!;

                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text("Date: ${job.pickDate}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('From: ${job.pickup}'),
                              Text('To: ${job.destination}'),
                              Text('Fare: ${job.journeyFare}'),
                              // Text('Fare: ${job.accountType}'),
                            ],
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary),
                            child: TextButton(
                                onPressed: () {
                                  if (job.obStatus == 'Open') {
                                    selectJob(job.obId);
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: 'Job has been taken already',
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                  print('open id is ${job.obId}');
                                },
                                child: job.obStatus == 'Open'
                                    ? Text(
                                        'Select',
                                        style: TextStyle(color: Colors.white
                                            // color: FlutterFlowTheme.of(context)
                                            //     .primaryBackground,
                                            ),
                                      )
                                    : Text(
                                        'Selected',
                                        style: TextStyle(color: Colors.white
                                            // color: FlutterFlowTheme.of(context)
                                            //     .primaryBackground,
                                            ),
                                      )),
                          ),
                          onTap: () {
                            // Handle item tap
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            FutureBuilder<List<OpenJob>>(
              future: fetchJobs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No jobs available'));
                }

                final jobs = snapshot.data!;

                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];

                    if (job.obStatus == 'Selected') {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(job.pickup),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('From: ${job.pickup}'),
                                    Text('To: ${job.destination}'),
                                    Text('Fare: ${job.journeyFare}'),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primary),
                                    child: TextButton(
                                        onPressed: () {
                                          selectJob(job.obId);
                                          // if (job.dId.isEmpty) {

                                          // } else {
                                          //   Fluttertoast.showToast(
                                          //     msg: 'Job has been taken already',
                                          //     textColor: Colors.white,
                                          //     fontSize: 16.0,
                                          //   );
                                          // }
                                          print('open id is ${job.obId}');
                                        },
                                        child: Text(
                                          'DESELECT',
                                          style: TextStyle(color: Colors.white
                                              // color: FlutterFlowTheme.of(context)
                                              //     .primaryBackground,
                                              ),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primary),
                                    child: TextButton(
                                        onPressed: () {
                                          // selectJob(job.obId);
                                          assignJob(job.bookId, job.cId,
                                              job.dId, job.journeyFare);
                                          print('open id is ${job.bookId}');
                                          print('open id is ${job.cId}');
                                          print('open id is ${job.dId}');
                                          print(
                                              'open id is ${job.journeyFare}');
                                        },
                                        child: Text(
                                          'Assign Me',
                                          style: TextStyle(color: Colors.white
                                              // color: FlutterFlowTheme.of(context)
                                              //     .primaryBackground,
                                              ),
                                        )),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String assignMe = 'https://minicaboffice.com/api/driver/assign-job.php';

  Future assignJob(
    String bookId,
    String cId,
    String dId,
    String journyFare,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? dId = prefs.getString('d_id');
      var fields = {
        'book_id': bookId.toString(),
        'c_id': cId.toString(),
        'd_id': dId.toString(),
        'journey_fare': dId.toString(),
      };
      var uri = Uri.parse(assignMe);

      var response = await http.post(
        uri,
        body: fields,
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        Fluttertoast.showToast(
          msg: jsonData['message'],
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {});
      } else {
        print('Failed to accept job. Status Code: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }

}
