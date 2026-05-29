class FdrPlanListModel {
  bool? status;
  List<FdrPlanListData>? data;
  Meta? meta;

  FdrPlanListModel({this.status, this.data, this.meta});

  factory FdrPlanListModel.fromJson(Map<String, dynamic> json) {
    var dataList = <FdrPlanListData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(FdrPlanListData.fromJson(v));
      });
    }
    return FdrPlanListModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }
}

class FdrPlanListData {
  String? fdrName;
  String? fdrId;
  String? status;
  bool? isCancellable;
  String? createdAt;

  FdrPlanListData({
    this.fdrName,
    this.fdrId,
    this.status,
    this.isCancellable,
    this.createdAt,
  });

  factory FdrPlanListData.fromJson(Map<String, dynamic> json) {
    return FdrPlanListData(
      fdrName: json['fdr_name']?.toString(),
      fdrId: json['fdr_id']?.toString(),
      status: json['status']?.toString(),
      isCancellable: json['is_cancellable'] == true || json['is_cancellable'] == 1 || json['is_cancellable'] == "1",
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
