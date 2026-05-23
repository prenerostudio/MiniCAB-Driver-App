class vehicie {
  List<Data>? data;
  bool? status;

  vehicie({this.data, this.status});

  vehicie.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class Data {
  String? vId;
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

  Data({
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
    this.dateAdded,
  });

  Data.fromJson(Map<String, dynamic> json) {
    vId = json['v_id'];
    vName = json['v_name'];
    vSeat = json['v_seat'];
    vBags = json['v_bags'];
    vWchair = json['v_wchair'];
    vTrailer = json['v_trailer'];
    vBooster = json['v_booster'];
    vBaby = json['v_baby'];
    vPricing = json['v_pricing'];
    vImg = json['v_img'];
    dateAdded = json['date_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['v_id'] = vId;
    data['v_name'] = vName;
    data['v_seat'] = vSeat;
    data['v_bags'] = vBags;
    data['v_wchair'] = vWchair;
    data['v_trailer'] = vTrailer;
    data['v_booster'] = vBooster;
    data['v_baby'] = vBaby;
    data['v_pricing'] = vPricing;
    data['v_img'] = vImg;
    data['date_added'] = dateAdded;
    return data;
  }
}
