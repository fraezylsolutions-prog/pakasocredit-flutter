class PortfolioModel {
  bool? status;
  List<PortfolioData>? data;

  PortfolioModel({this.status, this.data});

  PortfolioModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <PortfolioData>[];
      json['data'].forEach((v) {
        data!.add(PortfolioData.fromJson(v));
      });
    }
  }
}

class PortfolioData {
  String? name;
  String? icon;
  String? description;
  bool? isLocked;

  PortfolioData({this.name, this.icon, this.description, this.isLocked});

  PortfolioData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    description = json['description'];
    isLocked = json['is_locked'];
  }
}
