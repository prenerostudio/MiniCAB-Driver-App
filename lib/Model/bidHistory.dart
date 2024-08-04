

class Bid {
  String? bidId;
  String? bookId;
  String? dId;
  String? bidAmount;
  String? bidDate;
  String? cId;
  String? pickup;
  String? destination;
  String? passenger;
  String? luggage;
  String? note;
  String? bookDate;
  String? bookTime;
  String? journeyType;
  String? vId;
  String? bookingStatus;
  String? bidStatus;
  String? bidNote;
  String? bookAddDate;
  String? dName;
  String? dEmail;
  String? dPhone;
  String? cName;
  String? cEmail;
  String? cPhone;
  String? vName;
  String? vPricing;
  String? vImg;

  Bid({
    this.bidId,
    this.bookId,
    this.dId,
    this.bidAmount,
    this.bidDate,
    this.cId,
    this.pickup,
    this.destination,
    this.passenger,
    this.luggage,
    this.note,
    this.bookDate,
    this.bookTime,
    this.journeyType,
    this.vId,
    this.bookingStatus,
    this.bidStatus,
    this.bidNote,
    this.bookAddDate,
    this.dName,
    this.dEmail,
    this.dPhone,
    this.cName,
    this.cEmail,
    this.cPhone,
    this.vName,
    this.vPricing,
    this.vImg,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      bidId: json['bid_id'],
      bookId: json['book_id'],
      dId: json['d_id'],
      bidAmount: json['bid_amount'],
      bidDate: json['bid_date'],
      cId: json['c_id'],
      pickup: json['pickup'],
      destination: json['destination'],
      passenger: json['passenger'],
      luggage: json['luggage'],
      note: json['note'],
      bookDate: json['pick_date'],
      bookTime: json['pick_time'],
      journeyType: json['journey_type'],
      vId: json['v_id'],
      bookingStatus: json['booking_status'],
      bidStatus: json['bid_status'],
      bidNote: json['bid_note'],
      bookAddDate: json['book_add_date'],
      dName: json['d_name'],
      dEmail: json['d_email'],
      dPhone: json['d_phone'],
      cName: json['c_name'],
      cEmail: json['c_email'],
      cPhone: json['c_phone'],
      vName: json['v_name'],
      vPricing: json['v_pricing'],
      vImg: json['v_img'],
    );
  }
}


