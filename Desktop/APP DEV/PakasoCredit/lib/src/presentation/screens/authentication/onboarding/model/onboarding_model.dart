class OnboardingModel {
  bool? status;
  List<String>? data;

  OnboardingModel({this.status, this.data});

  OnboardingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'].cast<String>();
  }
}
