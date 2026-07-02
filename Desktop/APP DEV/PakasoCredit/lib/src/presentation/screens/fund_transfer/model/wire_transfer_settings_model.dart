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
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    minimumTransfer = json['minimum_transfer']?.toString();
    maximumTransfer = json['maximum_transfer']?.toString();
    charge = json['charge'] is int ? json['charge'] : int.tryParse(json['charge']?.toString() ?? '');
    chargeType = json['charge_type']?.toString();
    dailyLimitMaximumAmount = json['daily_limit_maximum_amount']?.toString();
    dailyLimitMaximumCount = json['daily_limit_maximum_count'] is int ? json['daily_limit_maximum_count'] : int.tryParse(json['daily_limit_maximum_count']?.toString() ?? '');
    monthlyLimitMaximumAmount = json['monthly_limit_maximum_amount']?.toString();
    monthlyLimitMaximumCount = json['monthly_limit_maximum_count'] is int ? json['monthly_limit_maximum_count'] : int.tryParse(json['monthly_limit_maximum_count']?.toString() ?? '');
    instructions = json['instructions']?.toString();
    fieldOptions = json['field_options']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }
}
