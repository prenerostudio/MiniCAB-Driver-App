class BidItem {
  final String bookId;
  final String bTypeId;
  final String cId;
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
  final String journeyFare;
  final String journeyDistance;
  final String bookingFee;
  final String carParking;
  final String waiting;
  final String tolls;
  final String extra;
  final String bookingStatus;
  final String bidStatus;
  final String bidNote;
  final String bookAddDate;
  final String cName;
  final String cEmail;
  final String cPhone;

  BidItem({
    required this.bookId,
    required this.bTypeId,
    required this.cId,
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
    required this.journeyFare,
    required this.journeyDistance,
    required this.bookingFee,
    required this.carParking,
    required this.waiting,
    required this.tolls,
    required this.extra,
    required this.bookingStatus,
    required this.bidStatus,
    required this.bidNote,
    required this.bookAddDate,
    required this.cName,
    required this.cEmail,
    required this.cPhone,
  });

  factory BidItem.fromJson(Map<String, dynamic> json) {
    return BidItem(
      bookId: json['book_id'],
      bTypeId: json['b_type_id'],
      cId: json['c_id'],
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
      journeyFare: json['journey_fare'],
      journeyDistance: json['journey_distance'],
      bookingFee: json['booking_fee'],
      carParking: json['car_parking'],
      waiting: json['waiting'],
      tolls: json['tolls'],
      extra: json['extra'],
      bookingStatus: json['booking_status'],
      bidStatus: json['bid_status'],
      bidNote: json['bid_note'],
      bookAddDate: json['book_add_date'],
      cName: json['c_name'],
      cEmail: json['c_email'],
      cPhone: json['c_phone'],
    );
  }
}
