class WithdrawMethodModel {
  bool? status;
  List<WithdrawMethodData>? data;

  WithdrawMethodModel({this.status, this.data});

  factory WithdrawMethodModel.fromJson(Map<String, dynamic> json) {
    var dataList = <WithdrawMethodData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(WithdrawMethodData.fromJson(v));
      });
    }
    return WithdrawMethodModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class WithdrawMethodData {
  int? id;
  String? icon;
  String? type;
  String? gatewayId;
  String? name;
  String? currency;
  double? rate;
  String? requiredTime;
  String? requiredTimeFormat;
  double? charge;
  String? chargeType;
  String? minWithdraw;
  String? maxWithdraw;
  String? fields;
  int? status;
  String? createdAt;
  String? updatedAt;

  WithdrawMethodData({
    this.id,
    this.icon,
    this.type,
    this.gatewayId,
    this.name,
    this.currency,
    this.rate,
    this.requiredTime,
    this.requiredTimeFormat,
    this.charge,
    this.chargeType,
    this.minWithdraw,
    this.maxWithdraw,
    this.fields,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory WithdrawMethodData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return WithdrawMethodData(
      id: toInt(json['id']),
      icon: json['icon']?.toString(),
      type: json['type']?.toString(),
      gatewayId: json['gateway_id']?.toString(),
      name: json['name']?.toString(),
      currency: json['currency']?.toString(),
      rate: toDouble(json['rate']),
      requiredTime: json['required_time']?.toString(),
      requiredTimeFormat: json['required_time_format']?.toString(),
      charge: toDouble(json['charge']),
      chargeType: json['charge_type']?.toString(),
      minWithdraw: json['min_withdraw']?.toString(),
      maxWithdraw: json['max_withdraw']?.toString(),
      fields: json['fields']?.toString(),
      status: toInt(json['status']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
