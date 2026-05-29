class FdrPlanModel {
  bool? status;
  List<FdrPlanData>? data;

  FdrPlanModel({this.status, this.data});

  factory FdrPlanModel.fromJson(Map<String, dynamic> json) {
    var dataList = <FdrPlanData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(FdrPlanData.fromJson(v));
      });
    }
    return FdrPlanModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class FdrPlanData {
  int? id;
  String? name;
  String? minimumAmount;
  String? maximumAmount;
  String? profitRate;
  String? profitIntervel;
  String? maturityFee;
  String? locked;
  String? compounding;
  int? canCancel;
  String? cancelIn;
  String? cancelFee;
  int? isIncrease;
  String? increaseLimit;
  String? incrementCharge;
  String? minIncreaseAmount;
  String? maxIncreaseAmount;
  int? isDecrease;
  String? decreaseLimit;
  String? decrementCharge;
  String? minDecreaseAmount;
  String? maxDecreaseAmount;
  String? badge;

  FdrPlanData({
    this.id,
    this.name,
    this.minimumAmount,
    this.maximumAmount,
    this.profitRate,
    this.profitIntervel,
    this.maturityFee,
    this.locked,
    this.compounding,
    this.canCancel,
    this.cancelIn,
    this.cancelFee,
    this.isIncrease,
    this.increaseLimit,
    this.incrementCharge,
    this.minIncreaseAmount,
    this.maxIncreaseAmount,
    this.isDecrease,
    this.decreaseLimit,
    this.decrementCharge,
    this.minDecreaseAmount,
    this.maxDecreaseAmount,
    this.badge,
  });

  factory FdrPlanData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return FdrPlanData(
      id: toInt(json["id"]),
      name: json['name']?.toString(),
      minimumAmount: json['minimum_amount']?.toString(),
      maximumAmount: json['maximum_amount']?.toString(),
      profitRate: json['profit_rate']?.toString(),
      profitIntervel: json['profit_intervel']?.toString(),
      maturityFee: json['maturity_fee']?.toString(),
      locked: json['locked']?.toString(),
      compounding: json['compounding']?.toString(),
      canCancel: toInt(json['can_cancel']),
      cancelIn: json['cancel_in']?.toString(),
      cancelFee: json['cancel_fee']?.toString(),
      isIncrease: toInt(json['is_increase']),
      increaseLimit: json['increase_limit']?.toString(),
      incrementCharge: json['increment_charge']?.toString(),
      minIncreaseAmount: json['min_increase_amount']?.toString(),
      maxIncreaseAmount: json['max_increase_amount']?.toString(),
      isDecrease: toInt(json['is_decrease']),
      decreaseLimit: json['decrease_limit']?.toString(),
      decrementCharge: json['decrement_charge']?.toString(),
      minDecreaseAmount: json['min_decrease_amount']?.toString(),
      maxDecreaseAmount: json['max_decrease_amount']?.toString(),
      badge: json['badge']?.toString(),
    );
  }
}
