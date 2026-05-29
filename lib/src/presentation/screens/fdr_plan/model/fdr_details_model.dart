class FdrDetailsModel {
  bool? status;
  FdrDetailsData? data;

  FdrDetailsModel({this.status, this.data});

  factory FdrDetailsModel.fromJson(Map<String, dynamic> json) {
    return FdrDetailsModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: json['data'] != null ? FdrDetailsData.fromJson(json['data']) : null,
    );
  }
}

class FdrDetailsData {
  int? id;
  String? fdrId;
  String? fdrName;
  String? status;
  String? amount;
  String? profit;
  String? profitPeriod;
  String? totalReturns;
  String? givenReturns;
  String? totalProfit;
  String? nextReceiveDate;
  String? totalProfitAmount;
  bool? isIncrease;
  String? minIncreaseAmount;
  String? maxIncreaseAmount;
  bool? isDecrease;
  String? minDecreaseAmount;
  String? maxDecreaseAmount;

  FdrDetailsData({
    this.id,
    this.fdrId,
    this.fdrName,
    this.status,
    this.amount,
    this.profit,
    this.profitPeriod,
    this.totalReturns,
    this.givenReturns,
    this.totalProfit,
    this.nextReceiveDate,
    this.totalProfitAmount,
    this.isIncrease,
    this.minIncreaseAmount,
    this.maxIncreaseAmount,
    this.isDecrease,
    this.minDecreaseAmount,
    this.maxDecreaseAmount,
  });

  factory FdrDetailsData.fromJson(Map<String, dynamic> json) {
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

    return FdrDetailsData(
      id: toInt(json["id"]),
      fdrId: json['fdr_id']?.toString(),
      fdrName: json['fdr_name']?.toString(),
      status: json['status']?.toString(),
      amount: json['amount']?.toString(),
      profit: json['profit']?.toString(),
      profitPeriod: json['profit_period']?.toString(),
      totalReturns: json['total_returns']?.toString(),
      givenReturns: json['given_returns']?.toString(),
      totalProfit: json['total_profit']?.toString(),
      nextReceiveDate: json['next_receive_date']?.toString(),
      totalProfitAmount: json['total_profit_amount']?.toString(),
      isIncrease: toBool(json['is_increase']),
      minIncreaseAmount: json['min_increase_amount']?.toString(),
      maxIncreaseAmount: json['max_increase_amount']?.toString(),
      isDecrease: toBool(json['is_decrease']),
      minDecreaseAmount: json['min_decrease_amount']?.toString(),
      maxDecreaseAmount: json['max_decrease_amount']?.toString(),
    );
  }
}
