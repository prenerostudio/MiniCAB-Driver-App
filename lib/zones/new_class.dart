import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:shared_preferences/shared_preferences.dart';

class TimerApp extends StatefulWidget {
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  DateTime? startTime;
  DateTime? endTime;
  Timer? _timer;
  int counter = 0;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  // Parse time from strings to DateTime
  DateTime _parseTime(String date, String time) {
    String dateTimeString = "$date $time";
    return DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTimeString);
  }

  // Load saved state from SharedPreferences
  Future<void> _loadSavedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? startTimeString = prefs.getString('startTime');
    String? endTimeString = prefs.getString('endTime');

    if (startTimeString != null && endTimeString != null) {
      startTime = DateTime.parse(startTimeString);
      endTime = DateTime.parse(endTimeString);

      DateTime now = DateTime.now();
      if (now.isBefore(endTime!)) {
        if (now.isAfter(startTime!)) {
          // Timer should be running, calculate how long the counter should be
          Duration elapsed = now.difference(startTime!);
          counter = elapsed.inSeconds;
          _startCounter();
        } else {
          // Wait for the startTime
          _startCounter();
        }
      } else {
        // Timer has already finished, no action needed
        await prefs.clear();
      }
    } else {
      // Initialize fresh times if there's no saved state
      String dateString = "2024-10-11"; // Change date accordingly
      startTime = _parseTime(dateString, "21:10:00"); // hh:mm:ss
      endTime = _parseTime(dateString, "21:11:00"); // hh:mm:ss
    }
  }

  void _startCounter() async {
    if (startTime == null || endTime == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save startTime, endTime to SharedPreferences
    await prefs.setString('startTime', startTime!.toIso8601String());
    await prefs.setString('endTime', endTime!.toIso8601String());

    DateTime now = DateTime.now();

    // If the current time is after start time, calculate the delay
    if (now.isAfter(startTime!)) {
      setState(() {
        isRunning = true;
      });
      Duration remainingTime = endTime!.difference(now);

      // Start counting up from the already elapsed time
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        setState(() {
          counter++;
        });

        // Save the counter value to SharedPreferences
        await prefs.setInt('counter', counter);

        // If current time reaches endTime, stop the counter
        if (DateTime.now().isAfter(endTime!)) {
          _stopCounter();
        }
      });

      Future.delayed(remainingTime, () {
        _stopCounter();
      });
    } else {
      // If current time is before start time, wait until start time
      Duration initialDelay = startTime!.difference(now);
      Future.delayed(initialDelay, () {
        setState(() {
          isRunning = true;
        });
        _startCounter(); // Recursive call to start when start time is reached
      });
    }
  }

  void _stopCounter() async {
    _timer?.cancel();
    // setState(() {
    //   isRunning = false;
    // });

    if (mounted) {
      setState(() {
        isRunning = false;
      });
    }
    // Clear the saved state when the timer stops
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('startTime');
    await prefs.remove('endTime');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timer App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRunning)
              Text('Counter: $counter', style: TextStyle(fontSize: 40)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRunning ? null : _startCounter,
              child: Text('Start Counter'),
            ),
          ],
        ),
      ),
    );
  }
}
