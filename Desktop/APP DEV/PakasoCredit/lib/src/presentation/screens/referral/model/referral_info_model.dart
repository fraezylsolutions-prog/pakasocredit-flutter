class ReferralInfoModel {
  bool? status;
  ReferralInfoData? data;

  ReferralInfoModel({this.status, this.data});

  ReferralInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data =
        json['data'] != null ? ReferralInfoData.fromJson(json['data']) : null;
  }
}

class ReferralInfoData {
  String? text;
  String? link;
  String? joinedText;
  bool? isShownReferralRules;
  List<Rules>? rules;

  ReferralInfoData({
    this.text,
    this.link,
    this.joinedText,
    this.isShownReferralRules,
    this.rules,
  });

  ReferralInfoData.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    link = json['link'];
    joinedText = json['joined_text'];
    isShownReferralRules = json['is_shown_referral_rules'];
    if (json['rules'] != null) {
      rules = <Rules>[];
      json['rules'].forEach((v) {
        rules!.add(Rules.fromJson(v));
      });
    }
  }
}

class Rules {
  String? icon;
  String? rule;

  Rules({this.icon, this.rule});

  Rules.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    rule = json['rule'];
  }
}
