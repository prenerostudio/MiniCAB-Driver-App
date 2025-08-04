export '../jobshistory/jobshistory_widget.dart';

class Booked {
  String? jobId;
  String? bookId;
  String? cId;
  String? dId;
  String? fare;
  String? extra;
  String? toll;
  String? waiting;
  String? note;
  String? status;
  String? dateAdded;
  String? cName;
  String? cEmail;
  String? cPhone;
  String? cAddress;
  String? dName;
  String? dEmail;
  String? dPhone;
  String? pickup;
  String? destination;
  String? passenger;
  String? luggage;
  String? bookDate;
  String? bookTime;
  String? journeyType;
  String? vId;
  String? bookingStatus;
  String? jobRoutes;

  String? jobAccptTime;

  String? jobStart;
  String? waytoPickup;
  String? arrivalTime;
  String? pobTime;
  String? dropOffTime;
  String? completetime;

  Booked({
    this.jobId,
    this.bookId,
    this.cId,
    this.dId,
    this.fare,
    this.extra,
    this.toll,
    this.waiting,
    this.note,
    this.status,
    this.dateAdded,
    this.cName,
    this.cEmail,
    this.cPhone,
    this.cAddress,
    this.dName,
    this.dEmail,
    this.dPhone,
    this.jobRoutes,
    this.pickup,
    this.destination,
    this.passenger,
    this.luggage,
    this.bookDate,
    this.bookTime,
    this.journeyType,
    this.vId,
    this.bookingStatus,
    this.jobAccptTime,
    this.jobStart,
    this.waytoPickup,
    this.arrivalTime,
    this.pobTime,
    this.dropOffTime,
    this.completetime,
  });

  factory Booked.fromJson(Map<String, dynamic> json) {
    return Booked(
      jobId: json['job_id'],
      bookId: json['book_id'],
      cId: json['c_id'],
      dId: json['d_id'],
      fare: json['journey_fare'],
      extra: json['extra'],
      toll: json['tolls'],
      waiting: json['waiting'],
      jobRoutes: json['driver_route'],
      note: json['note'],
      status: json['job_status'],
      dateAdded: json['date_added'],
      cName: json['c_name'],
      cEmail: json['c_email'],
      cPhone: json['c_phone'],
      cAddress: json['c_address'],
      dName: json['d_name'],
      dEmail: json['d_email'],
      dPhone: json['d_phone'],
      pickup: json['pickup'],
      destination: json['destination'],
      passenger: json['passenger'],
      luggage: json['luggage'],
      bookDate: json['pick_date'],
      bookTime: json['pick_time'],
      journeyType: json['journey_type'],
      vId: json['v_id'],
      bookingStatus: json['booking_status'],
      jobAccptTime: json['job_accepted_time'],
      jobStart: json['job_started_time'],
      waytoPickup: json['way_to_pickup_time'],
      arrivalTime: json['arrived_at_pickup_time'],
      pobTime: json['pob_time'],
      dropOffTime: json['dropoff_time'],
      completetime: json['job_completed_time'],
    );
  }
}
