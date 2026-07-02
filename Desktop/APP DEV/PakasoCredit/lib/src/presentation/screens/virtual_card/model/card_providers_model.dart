class CardProvidersModel {
  bool? status;
  List<CardProvidersData>? data;

  CardProvidersModel({this.status, this.data});

  CardProvidersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CardProvidersData>[];
      json['data'].forEach((v) {
        data!.add(CardProvidersData.fromJson(v));
      });
    }
  }
}

class CardProvidersData {
  int? id;
  String? name;

  CardProvidersData({this.id, this.name});

  CardProvidersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
