class DpsPlanListModel {
  bool? status;
  List<DpsPlanListData>? data;
  Meta? meta;

  DpsPlanListModel({this.status, this.data, this.meta});

  factory DpsPlanListModel.fromJson(Map<String, dynamic> json) {
    var dataList = <DpsPlanListData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(DpsPlanListData.fromJson(v));
      });
    }
    return DpsPlanListModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }
}

class DpsPlanListData {
  String? dpsName;
  String? dpsId;
  String? status;
  bool? isCancellable;
  String? createdAt;

  DpsPlanListData({
    this.dpsName,
    this.dpsId,
    this.status,
    this.isCancellable,
    this.createdAt,
  });

  factory DpsPlanListData.fromJson(Map<String, dynamic> json) {
    return DpsPlanListData(
      dpsName: json['dps_name']?.toString(),
      dpsId: json['dps_id']?.toString(),
      status: json['status']?.toString(),
      isCancellable: json["is_cancellable"] == true || json["is_cancellable"] == 1 || json["is_cancellable"] == "1",
      createdAt: json["created_at"]?.toString(),
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
