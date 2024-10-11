class BidItem {
  String? bookId;
  String? cId;
  String? pickup;
  String? destination;
  String? passenger;
  String? luggage;
  String? note;
  String? bookDate;
  String? bookTime;
  String? journeyfare;
  String? journeydistance;
  String? vId;
  String? bookingStatus;
  String? bidStatus;
  String? bidNote;
  String? bookAddDate;
  String? vName;
  String? vSeat;
  String? vBags;
  String? vWchair;
  String? vTrailer;
  String? vBooster;
  String? vBaby;
  String? vPricing;
  String? vImg;
  String? dateAdded;
  String? cName;
  String? cEmail;
  String? cPhone;
  String? cPassword;
  String? cAddress;
  String? cGender;
  String? cLanguage;
  String? cPic;
  String? postalCode;
  String? companyName;
  String? others;
  String? cNi;
  String? regDate;
  BidItem({
    this.bookId,
    this.bookDate,
    this.bookTime,
    this.pickup,
    this.destination,
    this.passenger,
    this.journeydistance,
    this.luggage,
    this.note,
    this.journeyfare,
    this.bookingStatus,
    this.vId,
    this.vName,
    this.vSeat,
    this.vBags,
    this.vWchair,
    this.vTrailer,
    this.vBooster,
    this.vBaby,
    this.vPricing,
    this.vImg,
    this.cId,
    this.cName,
    this.cEmail,
    this.cPhone,
    this.cPassword,
    this.cAddress,
    this.cGender,
    this.cLanguage,
    this.cPic,
    this.postalCode,
    this.companyName,
    this.others,
    this.cNi,
    this.regDate,
    this.bidStatus,
    this.bidNote,
    this.bookAddDate,
  });

  factory BidItem.fromJson(Map<String, dynamic> json) {
    return BidItem(
      bookId: json['book_id'],
      bookDate: json['pick_date'],
      bookTime: json['pick_time'],
      pickup: json['pickup'],
      destination: json['destination'],
      passenger: json['passenger'],
      journeydistance: json['journey_distance'],
      luggage: json['luggage'],
      note: json['note'],
      bookingStatus: json['booking_status'],
      vId: json['v_id'],
      vName: json['v_name'],
      journeyfare: json['journey_fare'],
      vSeat: json['v_seat'],
      vBags: json['v_bags'],
      vWchair: json['v_wchair'],
      vTrailer: json['v_trailer'],
      vBooster: json['v_booster'],
      vBaby: json['v_baby'],
      vPricing: json['v_pricing'],
      vImg: json['v_img'],
      cId: json['c_id'],
      cName: json['c_name'],
      cEmail: json['c_email'],
      cPhone: json['c_phone'],
      cPassword: json['c_password'],
      cAddress: json['c_address'],
      cGender: json['c_gender'],
      cLanguage: json['c_language'],
      cPic: json['c_pic'],
      postalCode: json['postal_code'],
      companyName: json['company_name'],
      others: json['others'],
      cNi: json['c_ni'],
      regDate: json['reg_date'],
      bidStatus: json['bid_status'],
      bidNote: json['bid_note'],
      bookAddDate: json['book_add_date'],
    );
  }
}
