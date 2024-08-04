
class TimeSlot {
  final String atId;
  final String dId;
  final String atDate;
  final String startTime;
  final String endTime;
  final String atStatus;
  final String addedTime;

  TimeSlot({
    required this.atId,
    required this.dId,
    required this.atDate,
    required this.startTime,
    required this.endTime,
    required this.atStatus,
    required this.addedTime,
  });

  // Factory constructor to create an instance from a JSON object
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      atId: json['at_id'],
      dId: json['d_id'],
      atDate: json['at_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      atStatus: json['at_status'],
      addedTime: json['added_time'],
    );
  }
}