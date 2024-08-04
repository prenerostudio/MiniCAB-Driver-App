export '../myprofile/myprofile_widget.dart';

class Driver {
  String? dId;
  String? dName;
  String? dEmail;
  String? dPassword;
  String? dPhone;
  String? dAddress;
  String? dPic;
  String? dGender;
  String? dLanguage;
  String? vId;
  String? dLicence;
  String? dLicenceExp;
  String? pcoLicence;
  String? pcoExp;
  String? skypeAcount;
  String? dRemarks;
  String? latitude;
  String? longitude;
  String? status;
  String? regDate;

  Driver({
    this.dId,
    this.dName,
    this.dEmail,
    this.dPassword,
    this.dPhone,
    this.dAddress,
    this.dPic,
    this.dGender,
    this.dLanguage,
    this.vId,
    this.dLicence,
    this.dLicenceExp,
    this.pcoLicence,
    this.pcoExp,
    this.skypeAcount,
    this.dRemarks,
    this.latitude,
    this.longitude,
    this.status,
    this.regDate,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      dId: json['d_id'],
      dName: json['d_name'],
      dEmail: json['d_email'],
      dPassword: json['d_password'],
      dPhone: json['d_phone'],
      dAddress: json['d_address'],
      dPic: json['d_pic'],
      dGender: json['d_gender'],
      dLanguage: json['d_language'],
      vId: json['v_id'],
      dLicence: json['d_licence'],
      dLicenceExp: json['d_licence_exp'],
      pcoLicence: json['pco_licence'],
      pcoExp: json['pco_exp'],
      skypeAcount: json['skype_acount'],
      dRemarks: json['d_remarks'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: json['status'],
      regDate: json['reg_date'],
    );
  }
}
