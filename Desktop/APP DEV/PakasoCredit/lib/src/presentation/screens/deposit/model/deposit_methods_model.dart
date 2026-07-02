class DepositMethodsModel {
  bool? status;
  List<DepositMethodsData>? data;

  DepositMethodsModel({this.status, this.data});

  factory DepositMethodsModel.fromJson(Map<String, dynamic> json) {
    var dataList = <DepositMethodsData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(DepositMethodsData.fromJson(v));
      });
    }
    return DepositMethodsModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class DepositMethodsData {
  int? id;
  int? gatewayId;
  String? logo;
  String? name;
  String? type;
  String? gatewayCode;
  int? charge;
  String? chargeType;
  int? minimumDeposit;
  int? maximumDeposit;
  double? rate;
  String? currency;
  String? currencySymbol;
  String? fieldOptions;
  String? paymentDetails;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? gatewayLogo;

  DepositMethodsData({
    this.id,
    this.gatewayId,
    this.logo,
    this.name,
    this.type,
    this.gatewayCode,
    this.charge,
    this.chargeType,
    this.minimumDeposit,
    this.maximumDeposit,
    this.rate,
    this.currency,
    this.currencySymbol,
    this.fieldOptions,
    this.paymentDetails,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.gatewayLogo,
  });

  factory DepositMethodsData.fromJson(Map<String, dynamic> json) {
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

    return DepositMethodsData(
      id: toInt(json['id']),
      gatewayId: toInt(json['gateway_id']),
      logo: json['logo']?.toString(),
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      gatewayCode: json['gateway_code']?.toString(),
      charge: toInt(json['charge']),
      chargeType: json['charge_type']?.toString(),
      minimumDeposit: toInt(json['minimum_deposit']),
      maximumDeposit: toInt(json['maximum_deposit']),
      rate: toDouble(json['rate']),
      currency: json['currency']?.toString(),
      currencySymbol: json['currency_symbol']?.toString(),
      fieldOptions: json['field_options']?.toString(),
      paymentDetails: json['payment_details']?.toString(),
      status: toInt(json['status']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      gatewayLogo: json['gateway_logo']?.toString(),
    );
  }
}
