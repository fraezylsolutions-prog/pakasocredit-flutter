class LoanPlanModel {
  bool? status;
  List<LoanPlanData>? data;

  LoanPlanModel({this.status, this.data});

  factory LoanPlanModel.fromJson(Map<String, dynamic> json) {
    var dataList = <LoanPlanData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(LoanPlanData.fromJson(v));
      });
    }
    return LoanPlanModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class LoanPlanData {
  int? id;
  String? name;
  String? minimumAmount;
  String? maximumAmount;
  String? installmentRate;
  String? installmentIntervel;
  String? totalInstallment;
  String? loanFee;
  String? fields;
  String? instructions;
  PlanData? planData;

  LoanPlanData({
    this.id,
    this.name,
    this.minimumAmount,
    this.maximumAmount,
    this.installmentRate,
    this.installmentIntervel,
    this.totalInstallment,
    this.loanFee,
    this.fields,
    this.instructions,
    this.planData,
  });

  factory LoanPlanData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return LoanPlanData(
      id: toInt(json['id']),
      name: json['name']?.toString(),
      minimumAmount: json['minimum_amount']?.toString(),
      maximumAmount: json['maximum_amount']?.toString(),
      installmentRate: json['installment_rate']?.toString(),
      installmentIntervel: json['installment_intervel']?.toString(),
      totalInstallment: json['total_installment']?.toString(),
      loanFee: json['loan_fee']?.toString(),
      fields: json['fields']?.toString(),
      instructions: json['instructions']?.toString(),
      planData: json['plan_data'] != null ? PlanData.fromJson(json['plan_data']) : null,
    );
  }
}

class PlanData {
  int? interestRate;
  int? totalInstallment;
  int? loanFee;

  PlanData({this.interestRate, this.totalInstallment, this.loanFee});

  factory PlanData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return PlanData(
      interestRate: toInt(json['interest_rate']),
      totalInstallment: toInt(json['total_installment']),
      loanFee: toInt(json['loan_fee']),
    );
  }
}
