class Review {
  final String revId;
  final String jobId;
  final String driverId;
  final String customerId;
  final String reviewMessage;
  final String reviewDate;
  final String pickup;
  final String destination;
  final String journeyType;
  final String bookingTime;
  final String bookingDate;
  final String driverName;
  final String customerName;

  Review({
    required this.revId,
    required this.jobId,
    required this.driverId,
    required this.customerId,
    required this.reviewMessage,
    required this.reviewDate,
    required this.pickup,
    required this.destination,
    required this.journeyType,
    required this.bookingTime,
    required this.bookingDate,
    required this.driverName,
    required this.customerName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      revId: json['rev_id'],
      jobId: json['job_id'],
      driverId: json['d_id'],
      customerId: json['c_id'],
      reviewMessage: json['rev_msg'],
      reviewDate: json['rev_date'],
      pickup: json['pickup'],
      destination: json['destination'],
      journeyType: json['journey_type'],
      bookingTime: json['book_time'],
      bookingDate: json['book_date'],
      driverName: json['d_name'],
      customerName: json['c_name'],
    );
  }
}