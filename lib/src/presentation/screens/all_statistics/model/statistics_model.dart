class StatisticsModel {
  bool? status;
  StatisticsData? data;

  StatisticsModel({this.status, this.data});

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: json['data'] != null ? StatisticsData.fromJson(json['data']) : null,
    );
  }
}

class StatisticsData {
  int? allTransactions;
  String? totalDeposit;
  String? totalWithdraw;
  String? totalTransfer;
  String? totalDps;
  String? totalFdr;
  String? totalLoan;
  String? totalBill;
  String? totalReferralProfit;
  int? totalReferral;
  String? depositBonus;
  int? portfolioAchieved;
  int? totalTickets;
  int? points;

  StatisticsData({
    this.allTransactions,
    this.totalDeposit,
    this.totalWithdraw,
    this.totalTransfer,
    this.totalDps,
    this.totalFdr,
    this.totalLoan,
    this.totalBill,
    this.totalReferralProfit,
    this.totalReferral,
    this.depositBonus,
    this.portfolioAchieved,
    this.totalTickets,
    this.points,
  });

  factory StatisticsData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return StatisticsData(
      allTransactions: toInt(json['all_transactions']),
      totalDeposit: json['total_deposit']?.toString(),
      totalWithdraw: json['total_withdraw']?.toString(),
      totalTransfer: json['total_transfer']?.toString(),
      totalDps: json['total_dps']?.toString(),
      totalFdr: json['total_fdr']?.toString(),
      totalLoan: json['total_loan']?.toString(),
      totalBill: json['total_bill']?.toString(),
      totalReferralProfit: json['total_referral_profit']?.toString(),
      totalReferral: toInt(json['total_referral']),
      depositBonus: json['deposit_bonus']?.toString(),
      portfolioAchieved: toInt(json['portfolio_achieved']),
      totalTickets: toInt(json['total_tickets']),
      points: toInt(json['points']),
    );
  }
}
