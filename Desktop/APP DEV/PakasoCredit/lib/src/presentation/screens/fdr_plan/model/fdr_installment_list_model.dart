class FdrInstallmentListModel {
  bool? status;
  List<FdrInstallmentListData>? data;

  FdrInstallmentListModel({this.status, this.data});

  FdrInstallmentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FdrInstallmentListData>[];
      json['data'].forEach((v) {
        data!.add(FdrInstallmentListData.fromJson(v));
      });
    }
  }
}

class FdrInstallmentListData {
  String? returnDate;
  String? interestAmount;
  String? paidAmount;

  FdrInstallmentListData({
    this.returnDate,
    this.interestAmount,
    this.paidAmount,
  });

  FdrInstallmentListData.fromJson(Map<String, dynamic> json) {
    returnDate = json['return_date'];
    interestAmount = json['interest_amount'];
    paidAmount = json['paid_amount'];
  }
}
