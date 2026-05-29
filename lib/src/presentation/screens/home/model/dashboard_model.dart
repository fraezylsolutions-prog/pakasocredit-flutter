import 'package:pakaso_credit/src/presentation/screens/wallet/model/wallets_model.dart';

class DashboardModel {
  bool? status;
  DashboardData? data;

  DashboardModel({this.status, this.data});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      status: json['status'] == true || json['status'] == 1 || json['status'].toString() == "true",
      data: json['data'] != null ? DashboardData.fromJson(json['data']) : null,
    );
  }
}

class DashboardData {
  String? greeting;
  String? userName;
  String? earnText;
  List<WalletsData>? wallets;
  DpsData? dpsData;
  FdrData? fdrData;
  LoanData? loanData;
  Statistics? statistics;
  List<Transactions>? transactions;

  DashboardData({
    this.greeting,
    this.userName,
    this.earnText,
    this.wallets,
    this.dpsData,
    this.fdrData,
    this.loanData,
    this.statistics,
    this.transactions,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    var walletList = <WalletsData>[];
    if (json['wallets'] != null && json['wallets'] is List) {
      json['wallets'].forEach((v) => walletList.add(WalletsData.fromJson(v)));
    }

    var transactionList = <Transactions>[];
    if (json['transactions'] != null && json['transactions'] is List) {
      json['transactions'].forEach((v) => transactionList.add(Transactions.fromJson(v)));
    }

    return DashboardData(
      greeting: json['greeting']?.toString(),
      userName: json['user_name']?.toString(),
      earnText: json['earn_text']?.toString(),
      wallets: walletList,
      dpsData: json['dps_data'] != null ? DpsData.fromJson(json['dps_data']) : null,
      fdrData: json['fdr_data'] != null ? FdrData.fromJson(json['fdr_data']) : null,
      loanData: json['loan_data'] != null ? LoanData.fromJson(json['loan_data']) : null,
      statistics: json['statistics'] != null ? Statistics.fromJson(json['statistics']) : null,
      transactions: transactionList,
    );
  }
}

class DpsData {
  String? totalRunningDpsAmount;
  List<Summary>? runningDpsSummary;

  DpsData({this.totalRunningDpsAmount, this.runningDpsSummary});

  factory DpsData.fromJson(Map<String, dynamic> json) {
    var summaryList = <Summary>[];
    if (json['running_dps_summary'] != null && json['running_dps_summary'] is List) {
      json['running_dps_summary'].forEach((v) => summaryList.add(Summary.fromJson(v)));
    }
    return DpsData(
      totalRunningDpsAmount: json['total_running_dps_amount']?.toString(),
      runningDpsSummary: summaryList,
    );
  }
}

class FdrData {
  String? totalRunningFdrAmount;
  List<Summary>? runningFdrSummary;

  FdrData({this.totalRunningFdrAmount, this.runningFdrSummary});

  factory FdrData.fromJson(Map<String, dynamic> json) {
    var summaryList = <Summary>[];
    if (json['running_fdr_summary'] != null && json['running_fdr_summary'] is List) {
      json['running_fdr_summary'].forEach((v) => summaryList.add(Summary.fromJson(v)));
    }
    return FdrData(
      totalRunningFdrAmount: json['total_running_fdr_amount']?.toString(),
      runningFdrSummary: summaryList,
    );
  }
}

class LoanData {
  String? totalRunningLoanAmount;
  List<Summary>? runningLoanSummary;

  LoanData({this.totalRunningLoanAmount, this.runningLoanSummary});

  factory LoanData.fromJson(Map<String, dynamic> json) {
    var summaryList = <Summary>[];
    if (json['running_loan_summary'] != null && json['running_loan_summary'] is List) {
      json['running_loan_summary'].forEach((v) => summaryList.add(Summary.fromJson(v)));
    }
    return LoanData(
      totalRunningLoanAmount: json['total_running_loan_amount']?.toString(),
      runningLoanSummary: summaryList,
    );
  }
}

class Summary {
  String? name;
  String? endDate;

  Summary({this.name, this.endDate});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      name: json['name']?.toString(),
      endDate: json['end_date']?.toString(),
    );
  }
}

class Statistics {
  int? totalTransactions;
  String? totalDeposit;
  String? totalTransfer;
  int? totalPayBill;
  String? totalReferralProfit;

  Statistics({
    this.totalTransactions,
    this.totalDeposit,
    this.totalTransfer,
    this.totalPayBill,
    this.totalReferralProfit,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
       if (v == null) return null;
       if (v is int) return v;
       return int.tryParse(v.toString());
    }
    return Statistics(
      totalTransactions: toInt(json['total_transactions']),
      totalDeposit: json['total_deposit']?.toString(),
      totalTransfer: json['total_transfer']?.toString(),
      totalPayBill: toInt(json['total_pay_bill']),
      totalReferralProfit: json['total_referral_profit']?.toString(),
    );
  }
}

class Transactions {
  String? description;
  String? tnx;
  bool? isPlus;
  String? type;
  String? amount;
  String? charge;
  String? finalAmount;
  String? status;
  String? method;
  String? createdAt;

  Transactions({
    this.description,
    this.tnx,
    this.isPlus,
    this.type,
    this.amount,
    this.charge,
    this.finalAmount,
    this.status,
    this.method,
    this.createdAt,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    bool toBool(dynamic v) => v == true || v == 1 || v == "1" || v?.toString().toLowerCase() == "true";
    return Transactions(
      description: json['description']?.toString(),
      tnx: json['tnx']?.toString(),
      isPlus: toBool(json['is_plus']),
      type: json['type']?.toString(),
      amount: json['amount']?.toString(),
      charge: json['charge']?.toString(),
      finalAmount: json['final_amount']?.toString(),
      status: json['status']?.toString(),
      method: json['method']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
