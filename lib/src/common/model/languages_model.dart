class LanguagesModel {
  bool? status;
  List<LanguagesData>? languagesList;

  LanguagesModel({this.status, this.languagesList});

  factory LanguagesModel.fromJson(Map<String, dynamic> json) {
    var list = <LanguagesData>[];
    if (json['data'] != null) {
      json['data'].forEach((v) => list.add(LanguagesData.fromJson(v)));
    }
    return LanguagesModel(
      status: json['status'] == true || json['status'] == 1 || json['status'] == "true",
      languagesList: list,
    );
  }
}

class LanguagesData {
  int? id;
  String? name;
  String? locale;
  int? isDefault;

  LanguagesData({this.id, this.name, this.locale, this.isDefault});

  factory LanguagesData.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) => (v is int) ? v : int.tryParse(v?.toString() ?? "");
    return LanguagesData(
      id: toInt(json['id']),
      name: json['name']?.toString(),
      locale: json['locale']?.toString(),
      isDefault: toInt(json['is_default']),
    );
  }
}
