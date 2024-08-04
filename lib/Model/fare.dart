class FareData {
  final String fareId;
  final String jobId;
  final String driverId;
  final String journeyFare;
  final String carParking;
  final String waiting;
  final String tolls;
  final String extras;
  final String fareStatus;
  final String applyDate;

  FareData({
    required this.fareId,
    required this.jobId,
    required this.driverId,
    required this.journeyFare,
    required this.carParking,
    required this.waiting,
    required this.tolls,
    required this.extras,
    required this.fareStatus,
    required this.applyDate,
  });

  factory FareData.fromJson(Map<String, dynamic> json) {
    return FareData(
      fareId: json['fare_id'],
      jobId: json['job_id'],
      driverId: json['d_id'],
      journeyFare: json['journey_fare'],
      carParking: json['car_parking'],
      waiting: json['waiting'],
      tolls: json['tolls'],
      extras: json['extras'],
      fareStatus: json['fare_status'],
      applyDate: json['apply_date'],
    );
  }
}
