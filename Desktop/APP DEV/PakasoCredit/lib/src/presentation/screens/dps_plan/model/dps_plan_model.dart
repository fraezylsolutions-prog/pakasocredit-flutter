class DpsPlanModel {
  bool? status;
  List<DpsPlanData>? data;

  DpsPlanModel({this.status, this.data});

  factory DpsPlanModel.fromJson(Map<String, dynamic> json) {
    var dataList = <DpsPlanData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(DpsPlanData.fromJson(v));
      });
    }
    return DpsPlanModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class DpsPlanData {
  int? id;
  String? dpsName;
  int? perInstallment;
  String? installmentDays;
  String? totalInstallment;
  String? interestRate;
  String? totalDeposit;
  String? totalMatureAmount;
  String? maturityFee;
  String? cancelIn;
  String? cancelFee;
  int? isIncrease;
  String? increaseLimit;
  String? minIncreaseAmount;
  String? maxIncreaseAmount;
  String? increaseCharge;
  int? isDecrease;
  String? decreaseLimit;
  String? minDecreaseAmount;
  String? maxDecreaseAmount;
  String? decreaseCharge;
  String? badge;

  DpsPlanData({
    this.id,
    this.dpsName,
    this.perInstallment,
    this.installmentDays,
    this.totalInstallment,
    this.interestRate,
    this.totalDeposit,
    this.totalMatureAmount,
    this.maturityFee,
    this.cancelIn,
    this.cancelFee,
    this.isIncrease,
    this.increaseLimit,
    this.minIncreaseAmount,
    this.maxIncreaseAmount,
    this.increaseCharge,
    this.isDecrease,
    this.decreaseLimit,
    this.minDecreaseAmount,
    this.maxDecreaseAmount,
    this.decreaseCharge,
    this.badge,
  });

  factory DpsPlanData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return DpsPlanData(
      id: toInt(json["id"]),
      dpsName: json['dps_name']?.toString(),
      perInstallment: toInt(json['per_installment']),
      installmentDays: json['installment_days']?.toString(),
      totalInstallment: json['total_installment']?.toString(),
      interestRate: json['interest_rate']?.toString(),
      totalDeposit: json['total_deposit']?.toString(),
      totalMatureAmount: json['total_mature_amount']?.toString(),
      maturityFee: json['maturity_fee']?.toString(),
      cancelIn: json['cancel_in']?.toString(),
      cancelFee: json['cancel_fee']?.toString(),
      isIncrease: toInt(json['is_increase']),
      increaseLimit: json['increase_limit']?.toString(),
      minIncreaseAmount: json['min_increase_amount']?.toString(),
      maxIncreaseAmount: json['max_increase_amount']?.toString(),
      increaseCharge: json['increase_charge']?.toString(),
      isDecrease: toInt(json['is_decrease']),
      decreaseLimit: json['decrease_limit']?.toString(),
      minDecreaseAmount: json['min_decrease_amount']?.toString(),
      maxDecreaseAmount: json['max_decrease_amount']?.toString(),
      decreaseCharge: json['decrease_charge']?.toString(),
      badge: json['badge']?.toString(),
    );
  }
}
