class BranchesModel {
  bool? status;
  List<BranchesData>? data;

  BranchesModel({this.status, this.data});

  factory BranchesModel.fromJson(Map<String, dynamic> json) {
    var list = <BranchesData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        list.add(BranchesData.fromJson(v));
      });
    }
    return BranchesModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      data: list,
    );
  }
}

class BranchesData {
  int? id;
  String? name;
  String? code;
  String? routingNumber;
  String? swiftCode;
  String? phone;
  String? mobile;
  String? email;
  String? fax;
  String? address;
  String? mapLocation;
  int? status;
  String? createdAt;
  String? updatedAt;

  BranchesData({
    this.id,
    this.name,
    this.code,
    this.routingNumber,
    this.swiftCode,
    this.phone,
    this.mobile,
    this.email,
    this.fax,
    this.address,
    this.mapLocation,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BranchesData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) => (v is int) ? v : int.tryParse(v?.toString() ?? "");
    return BranchesData(
      id: toInt(json['id']),
      name: json['name']?.toString(),
      code: json['code']?.toString(),
      routingNumber: json['routing_number']?.toString(),
      swiftCode: json['swift_code']?.toString(),
      phone: json['phone']?.toString(),
      mobile: json['mobile']?.toString(),
      email: json['email']?.toString(),
      fax: json['fax']?.toString(),
      address: json['address']?.toString(),
      mapLocation: json['map_location']?.toString(),
      status: toInt(json['status']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
