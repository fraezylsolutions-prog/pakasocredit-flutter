class SettingsModel {
  final String name;
  final String value;

  SettingsModel({required this.name, required this.value});

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(name: json['name'], value: json['value']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'value': value};
}
