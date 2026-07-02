class LoanPlanListModel {
  bool? status;
  List<LoanPlanListData>? data;
  Meta? meta;

  LoanPlanListModel({this.status, this.data, this.meta});

  factory LoanPlanListModel.fromJson(Map<String, dynamic> json) {
    var dataList = <LoanPlanListData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(LoanPlanListData.fromJson(v));
      });
    }
    return LoanPlanListModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }
}

class LoanPlanListData {
  String? planName;
  String? loanId;
  String? status;
  bool? isCancellable;
  String? createdAt;

  LoanPlanListData({
    this.planName,
    this.loanId,
    this.status,
    this.isCancellable,
    this.createdAt,
  });

  factory LoanPlanListData.fromJson(Map<String, dynamic> json) {
    bool toBool(dynamic v) => v == true || v == 1 || v == "1" || v?.toString().toLowerCase() == "true";
    return LoanPlanListData(
      planName: json['plan_name']?.toString(),
      loanId: json['loan_id']?.toString(),
      status: json['status']?.toString(),
      isCancellable: toBool(json['is_cancellable']),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class Meta {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Meta({this.currentPage, this.lastPage, this.perPage, this.total});

  factory Meta.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return Meta(
      currentPage: toInt(json['current_page']),
      lastPage: toInt(json['last_page']),
      perPage: toInt(json['per_page']),
      total: toInt(json['total']),
    );
  }
}
