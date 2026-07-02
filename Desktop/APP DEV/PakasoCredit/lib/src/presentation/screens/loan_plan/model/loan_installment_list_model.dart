class LoanInstallmentListModel {
  bool? status;
  List<LoanInstallmentListData>? data;

  LoanInstallmentListModel({this.status, this.data});

  factory LoanInstallmentListModel.fromJson(Map<String, dynamic> json) {
    var dataList = <LoanInstallmentListData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(LoanInstallmentListData.fromJson(v));
      });
    }
    return LoanInstallmentListModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class LoanInstallmentListData {
  int? id;
  String? installmentDate;
  String? givenDate;
  String? deferment;
  String? paidAmount;
  String? charge;
  String? finalAmount;

  LoanInstallmentListData({
    this.id,
    this.installmentDate,
    this.givenDate,
    this.deferment,
    this.paidAmount,
    this.charge,
    this.finalAmount,
  });

  factory LoanInstallmentListData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return LoanInstallmentListData(
      id: toInt(json["id"]),
      installmentDate: json['installment_date']?.toString(),
      givenDate: json['given_date']?.toString(),
      deferment: json['deferment']?.toString(),
      paidAmount: json['paid_amount']?.toString(),
      charge: json['charge']?.toString(),
      finalAmount: json['final_amount']?.toString(),
    );
  }
}
