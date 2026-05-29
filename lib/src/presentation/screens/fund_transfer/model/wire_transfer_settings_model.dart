class WireTransferSettingsModel {
  bool? status;
  WireTransferSettingsData? data;

  WireTransferSettingsModel({this.status, this.data});

  WireTransferSettingsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data =
        json['data'] != null
            ? WireTransferSettingsData.fromJson(json['data'])
            : null;
  }
}

class WireTransferSettingsData {
  int? id;
  String? minimumTransfer;
  String? maximumTransfer;
  int? charge;
  String? chargeType;
  String? dailyLimitMaximumAmount;
  int? dailyLimitMaximumCount;
  String? monthlyLimitMaximumAmount;
  int? monthlyLimitMaximumCount;
  String? instructions;
  String? fieldOptions;
  String? createdAt;
  String? updatedAt;

  WireTransferSettingsData({
    this.id,
    this.minimumTransfer,
    this.maximumTransfer,
    this.charge,
    this.chargeType,
    this.dailyLimitMaximumAmount,
    this.dailyLimitMaximumCount,
    this.monthlyLimitMaximumAmount,
    this.monthlyLimitMaximumCount,
    this.instructions,
    this.fieldOptions,
    this.createdAt,
    this.updatedAt,
  });

  WireTransferSettingsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    minimumTransfer = json['minimum_transfer'];
    maximumTransfer = json['maximum_transfer'];
    charge = json['charge'];
    chargeType = json['charge_type'];
    dailyLimitMaximumAmount = json['daily_limit_maximum_amount'];
    dailyLimitMaximumCount = json['daily_limit_maximum_count'];
    monthlyLimitMaximumAmount = json['monthly_limit_maximum_amount'];
    monthlyLimitMaximumCount = json['monthly_limit_maximum_count'];
    instructions = json['instructions'];
    fieldOptions = json['field_options'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
