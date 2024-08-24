class TimeSlotModel {
  String date;
  String startTime;
  String endTime;
  String atStatus;
  String atId;

  TimeSlotModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.atStatus,
    required this.atId,
  });

  // Factory constructor to create a TimeSlotModel from JSON
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      date: json['at_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      atStatus: json['at_status'] as String,
      atId: json['at_id'] as String,
    );
  }
}

class AcceptedTimeSlotModel {
  String date;
  String startTime;
  String endTime;
  String atStatus;
  String atId;

  AcceptedTimeSlotModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.atStatus,
    required this.atId,
  });

  // Factory constructor to create a TimeSlotModel from JSON
  factory AcceptedTimeSlotModel.fromJson(Map<String, dynamic> json) {
    return AcceptedTimeSlotModel(
      date: json['at_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      atStatus: json['at_status'] as String,
      atId: json['at_id'] as String,
    );
  }
}
