
class Zone {
  final String zoneId;
  final String startingPoint;
  final String endPoint;
  final String distance;
  final String fare;
  final DateTime zoneDate;

  Zone({
    required this.zoneId,
    required this.startingPoint,
    required this.endPoint,
    required this.distance,
    required this.fare,
    required this.zoneDate,
  });

  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      zoneId: json['zone_id'].toString(),
      startingPoint: json['starting_point'],
      endPoint: json['end_point'],
      distance: json['distance'],
      fare: json['fare'],
      zoneDate: DateTime.parse(json['zone_date']),
    );
  }
}
