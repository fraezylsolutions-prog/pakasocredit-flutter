class RewardModel {
  bool? status;
  RewardData? data;

  RewardModel({this.status, this.data});

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: json['data'] != null ? RewardData.fromJson(json['data']) : null,
    );
  }
}

class RewardData {
  int? points;
  bool? isPortfolio;
  String? portfolio;
  String? portfolioIcon;
  String? text;
  List<Earnings>? earnings;
  List<Redeems>? redeems;

  RewardData({this.points, this.isPortfolio, this.portfolio, this.portfolioIcon, this.text, this.earnings, this.redeems});

  factory RewardData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) => (v is int) ? v : int.tryParse(v?.toString() ?? "");
    bool toBool(dynamic v) => v == true || v == 1 || v == "1" || v?.toString().toLowerCase() == "true";

    var earningsList = <Earnings>[];
    if (json['earnings'] != null) {
      json['earnings'].forEach((v) {
        earningsList.add(Earnings.fromJson(v));
      });
    }
    var redeemsList = <Redeems>[];
    if (json['redeems'] != null) {
      json['redeems'].forEach((v) {
        redeemsList.add(Redeems.fromJson(v));
      });
    }

    return RewardData(
      points: toInt(json['points']),
      isPortfolio: toBool(json['is_portfolio']),
      portfolio: json['portfolio']?.toString(),
      portfolioIcon: json['portfolio_icon']?.toString(),
      text: json['text']?.toString(),
      earnings: earningsList,
      redeems: redeemsList,
    );
  }
}

class Earnings {
  String? portfolio;
  String? amountOfTransactions;
  String? point;

  Earnings({this.portfolio, this.amountOfTransactions, this.point});

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      portfolio: json['portfolio']?.toString(),
      amountOfTransactions: json['amount_of_transactions']?.toString(),
      point: json['point']?.toString(),
    );
  }
}

class Redeems {
  String? portfolio;
  String? point;
  String? amount;

  Redeems({this.portfolio, this.point, this.amount});

  factory Redeems.fromJson(Map<String, dynamic> json) {
    return Redeems(
      portfolio: json['portfolio']?.toString(),
      point: json['point']?.toString(),
      amount: json['amount']?.toString(),
    );
  }
}
