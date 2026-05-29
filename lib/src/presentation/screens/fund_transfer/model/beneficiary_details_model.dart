class BeneficiaryDetailsModel {
  bool? status;
  BeneficiaryDetailsData? data;

  BeneficiaryDetailsModel({this.status, this.data});

  BeneficiaryDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data =
        json['data'] != null
            ? BeneficiaryDetailsData.fromJson(json['data'])
            : null;
  }
}

class BeneficiaryDetailsData {
  int? id;
  int? bankId;
  int? userId;
  String? accountNumber;
  String? accountName;
  String? branchName;
  String? nickName;
  String? createdAt;
  String? updatedAt;
  Bank? bank;

  BeneficiaryDetailsData({
    this.id,
    this.bankId,
    this.userId,
    this.accountNumber,
    this.accountName,
    this.branchName,
    this.nickName,
    this.createdAt,
    this.updatedAt,
    this.bank,
  });

  BeneficiaryDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankId = json['bank_id'];
    userId = json['user_id'];
    accountNumber = json['account_number'];
    accountName = json['account_name'];
    branchName = json['branch_name'];
    nickName = json['nick_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bank = json['bank'] != null ? Bank.fromJson(json['bank']) : null;
  }
}

class Bank {
  int? id;
  String? logo;
  String? name;
  String? code;
  String? processingTime;
  String? processingType;
  String? charge;
  String? chargeType;
  String? minimumTransfer;
  String? maximumTransfer;
  String? dailyLimitMaximumAmount;
  int? dailyLimitMaximumCount;
  String? monthlyLimitMaximumAmount;
  int? monthlyLimitMaximumCount;
  String? fieldOptions;
  String? details;
  int? status;
  String? createdAt;
  String? updatedAt;

  Bank({
    this.id,
    this.logo,
    this.name,
    this.code,
    this.processingTime,
    this.processingType,
    this.charge,
    this.chargeType,
    this.minimumTransfer,
    this.maximumTransfer,
    this.dailyLimitMaximumAmount,
    this.dailyLimitMaximumCount,
    this.monthlyLimitMaximumAmount,
    this.monthlyLimitMaximumCount,
    this.fieldOptions,
    this.details,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    name = json['name'];
    code = json['code'];
    processingTime = json['processing_time'];
    processingType = json['processing_type'];
    charge = json['charge']?.toString();
    chargeType = json['charge_type'];
    minimumTransfer = json['minimum_transfer']?.toString();
    maximumTransfer = json['maximum_transfer']?.toString();
    dailyLimitMaximumAmount = json['daily_limit_maximum_amount']?.toString();
    dailyLimitMaximumCount = json['daily_limit_maximum_count'];
    monthlyLimitMaximumAmount =
        json['monthly_limit_maximum_amount']?.toString();
    monthlyLimitMaximumCount = json['monthly_limit_maximum_count'];
    fieldOptions = json['field_options'];
    details = json['details'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
