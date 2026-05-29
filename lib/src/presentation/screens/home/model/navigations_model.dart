class NavigationsModel {
  bool? status;
  List<NavigationsData>? data;

  NavigationsModel({this.status, this.data});

  factory NavigationsModel.fromJson(Map<String, dynamic> json) {
    var dataList = <NavigationsData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        dataList.add(NavigationsData.fromJson(v));
      });
    }
    return NavigationsModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: dataList,
    );
  }
}

class NavigationsData {
  String? name;
  String? type;
  int? priority;

  NavigationsData({this.name, this.type, this.priority});

  factory NavigationsData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return NavigationsData(
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      priority: toInt(json['priority']),
    );
  }
}
