class OpenJob {
  final String obId;
  final String bookId;
  final String dId;
  final String obStatus;
  final String obCreatedAt;
  final String obUpdatedAt;
  final String bTypeId;
  final String cId;
  final String pickup;
  final String stops;
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
  final String bookerCommission;
  final String bookingStatus;
  final String bidStatus;
  final String bidDate;
  final String bidTime;
  final String bidNote;
  final String paymentType;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String bookAddDate;
  final String bTypeName;
  final String bAddedDate;
  final String cName;
  final String cEmail;
  final String cPhone;
  final String cPassword;
  final String cAddress;
  final String cGender;
  final String cLanguage;
  final String cPic;
  final String others;
  final String cNi;
  final String status;
  final String companyName;
  final String commissionType;
  final String percentage;
  final String fixed;
  final String accountStatus;
  final String accountType;
  final String loginToken;
  final String regDate;
  final String vName;
  final String vSeat;
  final String vLuggage;
  final String vAirbags;
  final String vWchair;
  final String vBabyseat;
  final String vPricing;
  final String vImg;
  final String dateAdded;
  final String dName;
  final String dEmail;
  final String dPhone;
  final String dPassword;
  final String dAddress;
  final String dPostCode;
  final String dPic;
  final String dGender;
  final String dLanguage;
  final String licenceAuthority;
  final String latitude;
  final String longitude;
  final String signupType;
  final String driverRegDate;

  OpenJob({
    required this.obId,
    required this.bookId,
    required this.dId,
    required this.obStatus,
    required this.obCreatedAt,
    required this.obUpdatedAt,
    required this.bTypeId,
    required this.cId,
    required this.pickup,
    required this.stops,
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
    required this.bookerCommission,
    required this.bookingStatus,
    required this.bidStatus,
    required this.bidDate,
    required this.bidTime,
    required this.bidNote,
    required this.paymentType,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.bookAddDate,
    required this.bTypeName,
    required this.bAddedDate,
    required this.cName,
    required this.cEmail,
    required this.cPhone,
    required this.cPassword,
    required this.cAddress,
    required this.cGender,
    required this.cLanguage,
    required this.cPic,
    required this.others,
    required this.cNi,
    required this.status,
    required this.companyName,
    required this.commissionType,
    required this.percentage,
    required this.fixed,
    required this.accountStatus,
    required this.accountType,
    required this.loginToken,
    required this.regDate,
    required this.vName,
    required this.vSeat,
    required this.vLuggage,
    required this.vAirbags,
    required this.vWchair,
    required this.vBabyseat,
    required this.vPricing,
    required this.vImg,
    required this.dateAdded,
    required this.dName,
    required this.dEmail,
    required this.dPhone,
    required this.dPassword,
    required this.dAddress,
    required this.dPostCode,
    required this.dPic,
    required this.dGender,
    required this.dLanguage,
    required this.licenceAuthority,
    required this.latitude,
    required this.longitude,
    required this.signupType,
    required this.driverRegDate,
  });

  factory OpenJob.fromJson(Map<String, dynamic> json) {
    return OpenJob(
      obId: json['ob_id'] ?? '',
      bookId: json['book_id'] ?? '',
      dId: json['d_id'] ?? '',
      obStatus: json['ob_status'] ?? '',
      obCreatedAt: json['ob_created_at'] ?? '',
      obUpdatedAt: json['ob_updated_at'] ?? '',
      bTypeId: json['b_type_id'] ?? '',
      cId: json['c_id'] ?? '',
      pickup: json['pickup'] ?? '',
      stops: json['stops'] ?? '',
      destination: json['destination'] ?? '',
      address: json['address'] ?? '',
      postalCode: json['postal_code'] ?? '',
      passenger: json['passenger'] ?? '',
      pickDate: json['pick_date'] ?? '',
      pickTime: json['pick_time'] ?? '',
      journeyType: json['journey_type'] ?? '',
      vId: json['v_id'] ?? '',
      luggage: json['luggage'] ?? '',
      childSeat: json['child_seat'] ?? '',
      flightNumber: json['flight_number'] ?? '',
      delayTime: json['delay_time'] ?? '',
      note: json['note'] ?? '',
      journeyFare: json['journey_fare'] ?? '',
      journeyDistance: json['journey_distance'] ?? '',
      bookingFee: json['booking_fee'] ?? '',
      carParking: json['car_parking'] ?? '',
      waiting: json['waiting'] ?? '',
      tolls: json['tolls'] ?? '',
      extra: json['extra'] ?? '',
      bookerCommission: json['booker_commission'] ?? '',
      bookingStatus: json['booking_status'] ?? '',
      bidStatus: json['bid_status'] ?? '',
      bidDate: json['bid_date'] ?? '',
      bidTime: json['bid_time'] ?? '',
      bidNote: json['bid_note'] ?? '',
      paymentType: json['payment_type'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      bookAddDate: json['book_add_date'] ?? '',
      bTypeName: json['b_type_name'] ?? '',
      bAddedDate: json['b_added_date'] ?? '',
      cName: json['c_name'] ?? '',
      cEmail: json['c_email'] ?? '',
      cPhone: json['c_phone'] ?? '',
      cPassword: json['c_password'] ?? '',
      cAddress: json['c_address'] ?? '',
      cGender: json['c_gender'] ?? '',
      cLanguage: json['c_language'] ?? '',
      cPic: json['c_pic'] ?? '',
      others: json['others'] ?? '',
      cNi: json['c_ni'] ?? '',
      status: json['status'] ?? '',
      companyName: json['company_name'] ?? '',
      commissionType: json['commission_type'] ?? '',
      percentage: json['percentage'] ?? '',
      fixed: json['fixed'] ?? '',
      accountStatus: json['acount_status'] ?? '',
      accountType: json['account_type'] ?? '',
      loginToken: json['login_token'] ?? '',
      regDate: json['reg_date'] ?? '',
      vName: json['v_name'] ?? '',
      vSeat: json['v_seat'] ?? '',
      vLuggage: json['v_luggage'] ?? '',
      vAirbags: json['v_airbags'] ?? '',
      vWchair: json['v_wchair'] ?? '',
      vBabyseat: json['v_babyseat'] ?? '',
      vPricing: json['v_pricing'] ?? '',
      vImg: json['v_img'] ?? '',
      dateAdded: json['date_added'] ?? '',
      dName: json['d_name'] ?? '',
      dEmail: json['d_email'] ?? '',
      dPhone: json['d_phone'] ?? '',
      dPassword: json['d_password'] ?? '',
      dAddress: json['d_address'] ?? '',
      dPostCode: json['d_post_code'] ?? '',
      dPic: json['d_pic'] ?? '',
      dGender: json['d_gender'] ?? '',
      dLanguage: json['d_language'] ?? '',
      licenceAuthority: json['licence_authority'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      signupType: json['signup_type'] ?? '',
      driverRegDate: json['driver_reg_date'] ?? '',
    );
  }
}
