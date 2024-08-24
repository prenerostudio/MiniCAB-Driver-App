class Invoice {
  String? invoiceId;
  String? jobId;
  String? cId;
  String? dId;
  String? journeyFare;
  String? carParking;
  String? waiting;
  String? tolls;
  String? extra;
  String? totalPay;
  String? driverCommission;
  String? invoiceStatus;
  String? invoiceDate;
  String? bookId;
  String? dName;
  String? dEmail;
  String? dPhone;
  String? dPassword;
  String? dAddress;
  String? dPostCode;
  String? dPic;
  String? dGender;
  String? dLanguage;
  String? licenceAuthority;
  String? latitude;
  String? longitude;
  String? status;
  String? acountStatus;
  String? driverRegDate;
  String? bTypeId;
  String? pickup;
  String? stops;
  String? destination;
  String? address;
  String? postalCode;
  String? passenger;
  String? pickDate;
  String? pickTime;
  String? journeyType;
  String? vId;
  String? luggage;
  String? childSeat;
  String? flightNumber;
  String? delayTime;
  String? note;
  String? journeyDistance;
  String? bookingFee;
  String? bookerCommission;
  String? bookingStatus;
  String? bidStatus;
  String? bidTime;
  String? bidNote;
  String? paymentType;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? bookAddDate;
  String? bTypeName;
  String? bAddedDate;
  String? cName;
  String? cEmail;
  String? cPhone;
  String? cPassword;
  String? cAddress;
  String? cGender;
  String? cLanguage;
  String? cPic;
  String? others;
  String? cNi;
  String? companyName;
  String? commissionType;
  String? percentage;
  String? fixed;
  String? accountType;
  String? regDate;

  Invoice(
      {this.invoiceId,
      this.jobId,
      this.cId,
      this.dId,
      this.journeyFare,
      this.carParking,
      this.waiting,
      this.tolls,
      this.extra,
      this.totalPay,
      this.driverCommission,
      this.invoiceStatus,
      this.invoiceDate,
      this.bookId,
      this.dName,
      this.dEmail,
      this.dPhone,
      this.dPassword,
      this.dAddress,
      this.dPostCode,
      this.dPic,
      this.dGender,
      this.dLanguage,
      this.licenceAuthority,
      this.latitude,
      this.longitude,
      this.status,
      this.acountStatus,
      this.driverRegDate,
      this.bTypeId,
      this.pickup,
      this.stops,
      this.destination,
      this.address,
      this.postalCode,
      this.passenger,
      this.pickDate,
      this.pickTime,
      this.journeyType,
      this.vId,
      this.luggage,
      this.childSeat,
      this.flightNumber,
      this.delayTime,
      this.note,
      this.journeyDistance,
      this.bookingFee,
      this.bookerCommission,
      this.bookingStatus,
      this.bidStatus,
      this.bidTime,
      this.bidNote,
      this.paymentType,
      this.customerName,
      this.customerEmail,
      this.customerPhone,
      this.bookAddDate,
      this.bTypeName,
      this.bAddedDate,
      this.cName,
      this.cEmail,
      this.cPhone,
      this.cPassword,
      this.cAddress,
      this.cGender,
      this.cLanguage,
      this.cPic,
      this.others,
      this.cNi,
      this.companyName,
      this.commissionType,
      this.percentage,
      this.fixed,
      this.accountType,
      this.regDate});

  Invoice.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoice_id']?.toString();
    jobId = json['job_id']?.toString();
    cId = json['c_id']?.toString();
    dId = json['d_id']?.toString();
    journeyFare = json['journey_fare']?.toString();
    carParking = json['car_parking']?.toString();
    waiting = json['waiting']?.toString();
    tolls = json['tolls']?.toString();
    extra = json['extra']?.toString();
    totalPay = json['total_pay']?.toString();
    driverCommission = json['driver_commission']?.toString();
    invoiceStatus = json['invoice_status']?.toString();
    invoiceDate = json['invoice_date']?.toString();
    bookId = json['book_id']?.toString();
    dName = json['d_name'];
    dEmail = json['d_email'];
    dPhone = json['d_phone'].toString();
    dPassword = json['d_password'].toString();
    dAddress = json['d_address'].toString();
    dPostCode = json['d_post_code'].toString();
    dPic = json['d_pic'];
    dGender = json['d_gender'].toString();
    dLanguage = json['d_language'].toString();
    licenceAuthority = json['licence_authority'].toString();
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    status = json['status'].toString();
    acountStatus = json['acount_status'].toString();
    driverRegDate = json['driver_reg_date'].toString();
    bTypeId = json['b_type_id']?.toString();
    pickup = json['pickup'].toString();
    stops = json['stops'].toString();
    destination = json['destination'].toString();
    address = json['address'].toString();
    postalCode = json['postal_code'].toString();
    passenger = json['passenger'].toString();
    pickDate = json['pick_date'].toString();
    pickTime = json['pick_time'].toString();
    journeyType = json['journey_type'].toString();
    vId = json['v_id']?.toString();
    luggage = json['luggage'].toString();
    childSeat = json['child_seat'].toString();
    flightNumber = json['flight_number'].toString();
    delayTime = json['delay_time'].toString();
    note = json['note'].toString();
    journeyDistance = json['journey_distance']?.toString();
    bookingFee = json['booking_fee']?.toString();
    bookerCommission = json['booker_commission']?.toString();
    bookingStatus = json['booking_status'].toString();
    bidStatus = json['bid_status'].toString();
    bidTime = json['bid_time'].toString();
    bidNote = json['bid_note'].toString();
    paymentType = json['payment_type'].toString();
    customerName = json['customer_name'].toString();
    customerEmail = json['customer_email'].toString();
    customerPhone = json['customer_phone'].toString();
    bookAddDate = json['book_add_date'].toString();
    bTypeName = json['b_type_name'].toString();
    bAddedDate = json['b_added_date'].toString();
    cName = json['c_name'].toString();
    cEmail = json['c_email'].toString();
    cPhone = json['c_phone'].toString();
    cPassword = json['c_password'].toString();
    cAddress = json['c_address'].toString();
    cGender = json['c_gender'].toString();
    cLanguage = json['c_language'].toString();
    cPic = json['c_pic'].toString();
    others = json['others'].toString();
    cNi = json['c_ni'].toString();
    companyName = json['company_name'].toString();
    commissionType = json['commission_type'].toString();
    percentage = json['percentage']?.toString();
    fixed = json['fixed']?.toString();
    accountType = json['account_type'].toString();
    regDate = json['reg_date'].toString();
  }
}
