
export '../jobshistory/jobshistory_widget.dart';

class Booked {
  String? jobId;
  String? bookId;
  String? cId;
  String? dId;
  String? fare;
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

  Booked({
    this.jobId,
    this.bookId,
    this.cId,
    this.dId,
    this.fare,
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
    this.pickup,
    this.destination,
    this.passenger,
    this.luggage,
    this.bookDate,
    this.bookTime,
    this.journeyType,
    this.vId,
    this.bookingStatus,
  });

  factory Booked.fromJson(Map<String, dynamic> json) {
    return Booked(
      jobId: json['job_id'],
      bookId: json['book_id'],
      cId: json['c_id'],
      dId: json['d_id'],
      fare: json['fare'],
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
    );
  }
}
