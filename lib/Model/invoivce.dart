// class Invoice {
//   String? invoiceId;
//   String? jobId;
//   String? cId;
//   String? dId;
//   String? journeyFare;
//   String? carParking;
//   String? waiting;
//   String? tolls;
//   String? extra;
//   String? totalPay;
//   String? driverCommission;
//   String? invoiceStatus;
//   String? invoiceDate;
//   String? bookId;
//   String? dName;
//   String? dEmail;
//   String? dPhone;
//   String? dPassword;
//   String? dAddress;
//   String? dPostCode;
//   String? dPic;
//   String? dGender;
//   String? dLanguage;
//   String? licenceAuthority;
//   String? latitude;
//   String? longitude;
//   String? status;
//   String? acountStatus;
//   String? driverRegDate;
//   String? bTypeId;
//   String? pickup;
//   String? stops;
//   String? destination;
//   String? address;
//   String? postalCode;
//   String? passenger;
//   String? pickDate;
//   String? pickTime;
//   String? journeyType;
//   String? vId;
//   String? luggage;
//   String? childSeat;
//   String? flightNumber;
//   String? delayTime;
//   String? note;
//   String? journeyDistance;
//   String? bookingFee;
//   String? bookerCommission;
//   String? bookingStatus;
//   String? bidStatus;
//   String? bidTime;
//   String? bidNote;
//   String? paymentType;
//   String? customerName;
//   String? customerEmail;
//   String? customerPhone;
//   String? bookAddDate;
//   String? bTypeName;
//   String? bAddedDate;
//   String? cName;
//   String? cEmail;
//   String? cPhone;
//   String? cPassword;
//   String? cAddress;
//   String? cGender;
//   String? cLanguage;
//   String? cPic;
//   String? others;
//   String? cNi;
//   String? companyName;
//   String? commissionType;
//   String? percentage;
//   String? fixed;
//   String? accountType;
//   String? regDate;

//   Invoice({
//     this.invoiceId,
//     this.jobId,
//     this.cId,
//     this.dId,
//     this.journeyFare,
//     this.carParking,
//     this.waiting,
//     this.tolls,
//     this.extra,
//     this.totalPay,
//     this.driverCommission,
//     this.invoiceStatus,
//     this.invoiceDate,
//     this.bookId,
//     this.dName,
//     this.dEmail,
//     this.dPhone,
//     this.dPassword,
//     this.dAddress,
//     this.dPostCode,
//     this.dPic,
//     this.dGender,
//     this.dLanguage,
//     this.licenceAuthority,
//     this.latitude,
//     this.longitude,
//     this.status,
//     this.acountStatus,
//     this.driverRegDate,
//     this.bTypeId,
//     this.pickup,
//     this.stops,
//     this.destination,
//     this.address,
//     this.postalCode,
//     this.passenger,
//     this.pickDate,
//     this.pickTime,
//     this.journeyType,
//     this.vId,
//     this.luggage,
//     this.childSeat,
//     this.flightNumber,
//     this.delayTime,
//     this.note,
//     this.journeyDistance,
//     this.bookingFee,
//     this.bookerCommission,
//     this.bookingStatus,
//     this.bidStatus,
//     this.bidTime,
//     this.bidNote,
//     this.paymentType,
//     this.customerName,
//     this.customerEmail,
//     this.customerPhone,
//     this.bookAddDate,
//     this.bTypeName,
//     this.bAddedDate,
//     this.cName,
//     this.cEmail,
//     this.cPhone,
//     this.cPassword,
//     this.cAddress,
//     this.cGender,
//     this.cLanguage,
//     this.cPic,
//     this.others,
//     this.cNi,
//     this.companyName,
//     this.commissionType,
//     this.percentage,
//     this.fixed,
//     this.accountType,
//     this.regDate,
//   });

//   factory Invoice.fromJson(Map<String, dynamic> json) {
//     return Invoice(
//       invoiceId: json['invoice_id'],
//       jobId: json['job_id'],
//       cId: json['c_id'],
//       dId: json['d_id'],
//       journeyFare: json['journey_fare'],
//       carParking: json['car_parking'],
//       waiting: json['waiting'],
//       tolls: json['tolls'],
//       extra: json['extra'],
//       totalPay: json['total_pay'],
//       driverCommission: json['driver_commission'],
//       invoiceStatus: json['invoice_status'],
//       invoiceDate: json['invoice_date'],
//       bookId: json['book_id'],
//       dName: json['d_name'],
//       dEmail: json['d_email'],
//       dPhone: json['d_phone'],
//       dPassword: json['d_password'],
//       dAddress: json['d_address'],
//       dPostCode: json['d_post_code'],
//       dPic: json['d_pic'],
//       dGender: json['d_gender'],
//       dLanguage: json['d_language'],
//       licenceAuthority: json['licence_authority'],
//       latitude: json['latitude'],
//       longitude: json['longitude'],
//       status: json['status'],
//       acountStatus: json['acount_status'],
//       driverRegDate: json['driver_reg_date'],
//       bTypeId: json['b_type_id'],
//       pickup: json['pickup'],
//       stops: json['stops'],
//       destination: json['destination'],
//       address: json['address'],
//       postalCode: json['postal_code'],
//       passenger: json['passenger'],
//       pickDate: json['pick_date'],
//       pickTime: json['pick_time'],
//       journeyType: json['journey_type'],
//       vId: json['v_id'],
//       luggage: json['luggage'],
//       childSeat: json['child_seat'],
//       flightNumber: json['flight_number'],
//       delayTime: json['delay_time'],
//       note: json['note'],
//       journeyDistance: json['journey_distance'],
//       bookingFee: json['booking_fee'],
//       bookerCommission: json['booker_commission'],
//       bookingStatus: json['booking_status'],
//       bidStatus: json['bid_status'],
//       bidTime: json['bid_time'],
//       bidNote: json['bid_note'],
//       paymentType: json['payment_type'],
//       customerName: json['customer_name'],
//       customerEmail: json['customer_email'],
//       customerPhone: json['customer_phone'],
//       bookAddDate: json['book_add_date'],
//       bTypeName: json['b_type_name'],
//       bAddedDate: json['b_added_date'],
//       cName: json['c_name'],
//       cEmail: json['c_email'],
//       cPhone: json['c_phone'],
//       cPassword: json['c_password'],
//       cAddress: json['c_address'],
//       cGender: json['c_gender'],
//       cLanguage: json['c_language'],
//       cPic: json['c_pic'],
//       others: json['others'],
//       cNi: json['c_ni'],
//       companyName: json['company_name'],
//       commissionType: json['commission_type'],
//       percentage: json['percentage'],
//       fixed: json['fixed'],
//       accountType: json['account_type'],
//       regDate: json['reg_date'],
//     );
//   }
// }
