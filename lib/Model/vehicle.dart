class vehicie {
  List<Data>? data;
  bool? status;

  vehicie({this.data, this.status});

  vehicie.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
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

  Data(
      {this.vId,
        this.vName,
        this.vSeat,
        this.vBags,
        this.vWchair,
        this.vTrailer,
        this.vBooster,
        this.vBaby,
        this.vPricing,
        this.vImg,
        this.dateAdded});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['v_id'] = this.vId;
    data['v_name'] = this.vName;
    data['v_seat'] = this.vSeat;
    data['v_bags'] = this.vBags;
    data['v_wchair'] = this.vWchair;
    data['v_trailer'] = this.vTrailer;
    data['v_booster'] = this.vBooster;
    data['v_baby'] = this.vBaby;
    data['v_pricing'] = this.vPricing;
    data['v_img'] = this.vImg;
    data['date_added'] = this.dateAdded;
    return data;
  }
}
