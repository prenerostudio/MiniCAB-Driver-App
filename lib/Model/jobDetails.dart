class Job {
  final String jobId;
  final String bookId;
  final String cId;
  final String dId;
  final String jobNote;
  final String journeyFare;
  final String bookingFee;
  final String carParking;
  final String waiting;
  final String tolls;
  final String extra;
  final String jobStatus;
  final String dateJobAdd;
  final String cName;
  final String cEmail;
  final String cPhone;
  final String cAddress;
  final String dName;
  final String dEmail;
  final String dPhone;
  final String bTypeId;
  final String pickup;
  final String destination;
  final String address;
  final String postalCode;
  final String passenger;
  final String pickDate;
  final String pickTime;
  final String journeyType;
  final String vId;
  final String luggage;
  final String childSeat;
  final String flightNumber;
  final String delayTime;
  final String note;
  final String journeyDistance;
  final String bookingStatus;
  final String bidStatus;
  final String bidNote;
  final String bookAddDate;

  Job({
    required this.jobId,
    required this.bookId,
    required this.cId,
    required this.dId,
    required this.jobNote,
    required this.journeyFare,
    required this.bookingFee,
    required this.carParking,
    required this.waiting,
    required this.tolls,
    required this.extra,
    required this.jobStatus,
    required this.dateJobAdd,
    required this.cName,
    required this.cEmail,
    required this.cPhone,
    required this.cAddress,
    required this.dName,
    required this.dEmail,
    required this.dPhone,
    required this.bTypeId,
    required this.pickup,
    required this.destination,
    required this.address,
    required this.postalCode,
    required this.passenger,
    required this.pickDate,
    required this.pickTime,
    required this.journeyType,
    required this.vId,
    required this.luggage,
    required this.childSeat,
    required this.flightNumber,
    required this.delayTime,
    required this.note,
    required this.journeyDistance,
    required this.bookingStatus,
    required this.bidStatus,
    required this.bidNote,
    required this.bookAddDate,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobId: json['job_id'],
      bookId: json['book_id'],
      cId: json['c_id'],
      dId: json['d_id'],
      jobNote: json['job_note'],
      journeyFare: json['journey_fare'],
      bookingFee: json['booking_fee'],
      carParking: json['car_parking'],
      waiting: json['waiting'],
      tolls: json['tolls'],
      extra: json['extra'],
      jobStatus: json['job_status'],
      dateJobAdd: json['date_job_add'],
      cName: json['c_name'],
      cEmail: json['c_email'],
      cPhone: json['c_phone'],
      cAddress: json['c_address'],
      dName: json['d_name'],
      dEmail: json['d_email'],
      dPhone: json['d_phone'],
      bTypeId: json['b_type_id'],
      pickup: json['pickup'],
      destination: json['destination'],
      address: json['address'],
      postalCode: json['postal_code'],
      passenger: json['passenger'],
      pickDate: json['pick_date'],
      pickTime: json['pick_time'],
      journeyType: json['journey_type'],
      vId: json['v_id'],
      luggage: json['luggage'],
      childSeat: json['child_seat'],
      flightNumber: json['flight_number'],
      delayTime: json['delay_time'],
      note: json['note'],
      journeyDistance: json['journey_distance'],
      bookingStatus: json['booking_status'],
      bidStatus: json['bid_status'],
      bidNote: json['bid_note'],
      bookAddDate: json['book_add_date'],
    );
  }
}
