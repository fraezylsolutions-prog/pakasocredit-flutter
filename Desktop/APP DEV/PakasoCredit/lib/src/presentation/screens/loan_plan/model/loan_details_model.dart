class LoanDetailsModel {
  bool? status;
  LoanDetailsData? data;

  LoanDetailsModel({this.status, this.data});

  factory LoanDetailsModel.fromJson(Map<String, dynamic> json) {
    return LoanDetailsModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: json['data'] != null ? LoanDetailsData.fromJson(json['data']) : null,
    );
  }
}

class LoanDetailsData {
  String? planName;
  String? loanId;
  String? status;
  String? amount;
  String? perInstallment;
  String? installmentInterval;
  String? totalInstallment;
  int? givenInstallment;
  String? nextInstallment;
  String? defermentDays;
  String? defermentCharge;
  String? totalPayableAmount;

  LoanDetailsData({
    this.planName,
    this.loanId,
    this.status,
    this.amount,
    this.perInstallment,
    this.installmentInterval,
    this.totalInstallment,
    this.givenInstallment,
    this.nextInstallment,
    this.defermentDays,
    this.defermentCharge,
    this.totalPayableAmount,
  });

  factory LoanDetailsData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return LoanDetailsData(
      planName: json['plan_name']?.toString(),
      loanId: json['loan_id']?.toString(),
      status: json['status']?.toString(),
      amount: json['amount']?.toString(),
      perInstallment: json['per_installment']?.toString(),
      installmentInterval: json['installment_interval']?.toString(),
      totalInstallment: json['total_installment']?.toString(),
      givenInstallment: toInt(json['given_installment']),
      nextInstallment: json['next_installment']?.toString(),
      defermentDays: json['deferment_days']?.toString(),
      defermentCharge: json['deferment_charge']?.toString(),
      totalPayableAmount: json['total_payable_amount']?.toString(),
    );
  }
}
