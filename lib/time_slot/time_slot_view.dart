import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
 
import 'package:mini_cab/time_slot/time_slot_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeSlotView extends StatefulWidget {
  const TimeSlotView({super.key});

  @override
  State<TimeSlotView> createState() => _TimeSlotViewState();
}

class _TimeSlotViewState extends State<TimeSlotView>
    with TickerProviderStateMixin {
  Future<List<TimeSlotModel>> getTimerSlots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? jobId = prefs.getString('jobId');

    final response = await http.post(
      Uri.parse(
          'https://www.minicaboffice.com/api/driver/fetch-time-slots.php'),
      // body: {'d_id': dId.toString(), 'job_id': jobId.toString()},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'] ?? [];
      // Map the JSON data to a list of TimeSlotModel objects
      return data.map((item) => TimeSlotModel.fromJson(item)).toList();
    } else {
      // Handle the error or throw an exception
      throw Exception('Failed to load time slots');
    }
  }

  Future<List<AcceptedTimeSlotModel>> acceptedTimeSlot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? jobId = prefs.getString('jobId');

    final response = await http.post(
      Uri.parse(
          'https://www.minicaboffice.com/api/driver/accepted-time-slot.php'),
      body: {'d_id': dId.toString()},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'] ?? [];
      // Map the JSON data to a list of TimeSlotModel objects
      return data.map((item) => AcceptedTimeSlotModel.fromJson(item)).toList();
    } else {
      // Handle the error or throw an exception
      throw Exception('Failed to load time slots');
    }
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent)),
          backgroundColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    child: const CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Please wait...',
                    style: TextStyle(fontFamily: 'Satoshi', fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future acceptTimeSlot(String atId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? jobId = prefs.getString('jobId');
    _showProgressDialog(context);
    final response = await http.post(
      Uri.parse(
          'https://www.minicaboffice.com/api/driver/accept-time-slot.php'),
      body: {'at_id': atId.toString(), 'd_id': dId.toString()},
    );
    Navigator.pop(context);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {});
      getTimerSlots();
      // Extract the message
      String message = jsonResponse['message'];
      print('the response message: $message');
      showToastMessage(message);
    } else {
      // Handle the error or throw an exception
      throw Exception('Failed to load time slots');
    }
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  List<TimeSlotModel>? timeSloteList;
  @override
  Widget build(BuildContext context) {
    var tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Time Slots'),
      ),
      body: Column(
        children: [
          TabBar(
              onTap: (value) {
                print(value);
                if (value == 1) {
                  acceptedTimeSlot();
                } else {
                  getTimerSlots();
                }
              },
              indicatorSize: TabBarIndicatorSize.tab,
              controller: tabController,
              labelColor: const Color.fromARGB(255, 37, 33, 243),
              tabs: [
                Tab(
                  text: 'All timeSlot',
                ),
                Tab(
                  text: 'Accepted timeSlot',
                )
              ]),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              FutureBuilder<List<TimeSlotModel>>(
                future: getTimerSlots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No time slots available'));
                  } else {
                    final timeSlots = snapshot.data!;
                    return ListView.builder(
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        final slot = timeSlots[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 12),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 3),
                              title: Text(
                                "Date : ${slot.date}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    'Start : ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '${slot.startTime}',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                  Text(
                                    '    End : ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${slot.endTime}",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  )
                                ],
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  acceptTimeSlot(slot.atId);
                                },
                                child: Container(
                                    width: 70,
                                    height: 40,
                                    decoration:
                                        BoxDecoration(color: Colors.blue),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Accept',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ))),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              FutureBuilder<List<AcceptedTimeSlotModel>>(
                future: acceptedTimeSlot(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No time slots available'));
                  } else {
                    final timeSlots = snapshot.data!;
                    return ListView.builder(
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        final slot = timeSlots[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 12),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 3),
                              title: Text(
                                "Date : ${slot.date}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    'Start : ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '${slot.startTime}',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                  Text(
                                    '    End : ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${slot.endTime}",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              )
            ]),
          )
        ],
      ),
    );
  }
}
