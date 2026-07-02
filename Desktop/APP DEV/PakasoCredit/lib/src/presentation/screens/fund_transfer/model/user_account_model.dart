class UserAccountModel {
  bool? status;
  UserAccountData? data;

  UserAccountModel({this.status, this.data});

  UserAccountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UserAccountData.fromJson(json['data']) : null;
  }
}

class UserAccountData {
  String? name;
  String? branchName;

  UserAccountData({this.name, this.branchName});

  UserAccountData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    branchName = json['branch_name'];
  }
}
