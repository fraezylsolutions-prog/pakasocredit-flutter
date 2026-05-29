class DpsDetailsModel {
  bool? status;
  DpsDetailsData? data;

  DpsDetailsModel({this.status, this.data});

  factory DpsDetailsModel.fromJson(Map<String, dynamic> json) {
    return DpsDetailsModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: json['data'] != null ? DpsDetailsData.fromJson(json['data']) : null,
    );
  }
}

class DpsDetailsData {
  int? id;
  String? planName;
  String? dpsId;
  String? status;
  int? interestRate;
  String? perInstallment;
  int? installmentInterval;
  int? totalInstallment;
  int? givenInstallment;
  String? nextInstallment;
  int? defermentDays;
  String? defermentCharge;
  String? profitAmount;
  String? totalMatureAmount;
  bool? isIncrease;
  String? minIncreaseAmount;
  String? maxIncreaseAmount;
  bool? isDecrease;
  String? minDecreaseAmount;
  String? maxDecreaseAmount;

  DpsDetailsData({
    this.id,
    this.planName,
    this.dpsId,
    this.status,
    this.interestRate,
    this.perInstallment,
    this.installmentInterval,
    this.totalInstallment,
    this.givenInstallment,
    this.nextInstallment,
    this.defermentDays,
    this.defermentCharge,
    this.profitAmount,
    this.totalMatureAmount,
    this.isIncrease,
    this.minIncreaseAmount,
    this.maxIncreaseAmount,
    this.isDecrease,
    this.minDecreaseAmount,
    this.maxDecreaseAmount,
  });

  factory DpsDetailsData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    bool toBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return v == 1;
      final str = v.toString().toLowerCase();
      return str == "1" || str == "true" || str == "yes";
    }

    return DpsDetailsData(
      id: toInt(json['id']),
      planName: json['plan_name']?.toString(),
      dpsId: json['dps_id']?.toString(),
      status: json['status']?.toString(),
      interestRate: toInt(json['interest_rate']),
      perInstallment: json['per_installment']?.toString(),
      installmentInterval: toInt(json['installment_interval']),
      totalInstallment: toInt(json['total_installment']),
      givenInstallment: toInt(json['given_installment']),
      nextInstallment: json['next_installment']?.toString(),
      defermentDays: toInt(json['deferment_days']),
      defermentCharge: json['deferment_charge']?.toString(),
      profitAmount: json['profit_amount']?.toString(),
      totalMatureAmount: json['total_mature_amount']?.toString(),
      isIncrease: toBool(json['is_increase']),
      minIncreaseAmount: json['min_increase_amount']?.toString(),
      maxIncreaseAmount: json['max_increase_amount']?.toString(),
      isDecrease: toBool(json['is_decrease']),
      minDecreaseAmount: json['min_decrease_amount']?.toString(),
      maxDecreaseAmount: json['max_decrease_amount']?.toString(),
    );
  }
}
