import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/model/pay_bill_service_model.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/bill_payment_history/bill_payment_history.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DataBundleController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSubmitLoading = false.obs;
  final RxString country = "".obs;
  final RxString serviceId = "".obs;
  final RxString siteCurrency = "".obs;
  final RxString serviceCurrency = "".obs;
  final RxDouble serviceRate = 0.0.obs;
  final RxDouble serviceAmount = 0.0.obs;
  final RxDouble serviceCharge = 0.0.obs;
  final RxString serviceChargeType = "".obs;
  final RxDouble payableAmount = 0.0.obs;
  final countryController = TextEditingController();
  final amountController = TextEditingController();
  final serviceController = TextEditingController();
  final RxList<PayBillServiceData> payBillServiceList =
      <PayBillServiceData>[].obs;
  final Rx<PayBillServiceData?> selectedService = Rx<PayBillServiceData?>(null);
  final RxMap<String, TextEditingController> dynamicFieldControllers =
      <String, TextEditingController>{}.obs;
  final RxString chargeText = "".obs;
  final RxString amountText = "".obs;
  final RxString rateText = "".obs;

  Future<void> fetchPayBillServices() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint:
            "${ApiPath.payBillEndpoint}/services/${countryController.text}/data-bundle",
      );
      if (response.status == Status.completed) {
        final payBillServiceModel = PayBillServiceModel.fromJson(
          response.data!,
        );
        payBillServiceList.clear();
        payBillServiceList.assignAll(payBillServiceModel.data!);
        serviceId.value = "";
        serviceController.clear();
        selectedService.value = null;
      }
    } finally {}
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> submitPayBill() async {
    isSubmitLoading.value = true;
    try {
      for (final entry in dynamicFieldControllers.entries) {
        if (entry.value.text.trim().isEmpty) {
          Fluttertoast.showToast(
            msg: "${entry.key} is required",
            backgroundColor: AppColors.error,
          );
          return;
        }
      }
      final Map<String, dynamic> requestBody = {
        "service_id": serviceId.value,
        "amount": amountText.value,
        "data": [
          dynamicFieldControllers.map(
            (key, controller) => MapEntry(key, controller.text),
          ),
        ],
      };
      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.payBillEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        resetFields();
        Get.find<NavigationController>().pushPage(BillPaymentHistory());
      }
    } finally {
      isSubmitLoading.value = false;
    }
  }

  PayBillServiceData? getServiceById(int id) {
    try {
      return payBillServiceList.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  void setupDynamicFields(List<String>? fields) {
    dynamicFieldControllers.forEach((key, controller) => controller.dispose());
    dynamicFieldControllers.clear();
    if (fields != null) {
      for (var field in fields) {
        dynamicFieldControllers[field] = TextEditingController();
      }
    }
  }

  void calculatePaymentDetails() {
    final amount = double.tryParse(amountController.text) ?? 0.0;

    double charge;
    if (serviceChargeType.value == 'fixed') {
      charge = serviceCharge.value.toDouble();
    } else {
      charge = (amount / 100) * (serviceCharge.value.toDouble());
    }
    final payable =
        serviceRate.value > 0 ? ((amount / serviceRate.value) + charge) : 0.0;
    payableAmount.value = payable;
    chargeText.value = '${charge.toStringAsFixed(2)} $siteCurrency';
    rateText.value =
        '1 $siteCurrency = ${serviceRate.value.toInt()} ${serviceCurrency.value}';
  }

  @override
  void onClose() {
    dynamicFieldControllers.forEach((key, controller) => controller.dispose());
    super.onClose();
  }

  void clearFields() {
    country.value = "";
    serviceId.value = "";
    serviceCurrency.value = "";
    serviceRate.value = 0.0;
    serviceAmount.value = 0.0;
    serviceCharge.value = 0.0;
    serviceChargeType.value = "";
    payableAmount.value = 0.0;
    countryController.clear();
    amountController.clear();
    serviceController.clear();
    payBillServiceList.clear();
    selectedService.value = null;
    dynamicFieldControllers.forEach((key, controller) => controller.dispose());
    dynamicFieldControllers.clear();
    chargeText.value = "";
    amountText.value = "";
    rateText.value = "";
    siteCurrency.value = "";
  }

  void resetFields() {
    country.value = "";
    serviceId.value = "";
    serviceCurrency.value = "";
    serviceRate.value = 0.0;
    serviceAmount.value = 0.0;
    serviceCharge.value = 0.0;
    serviceChargeType.value = "";
    payableAmount.value = 0.0;
    countryController.clear();
    amountController.clear();
    serviceController.clear();
    selectedService.value = null;
    dynamicFieldControllers.forEach((key, controller) => controller.dispose());
    dynamicFieldControllers.clear();
    chargeText.value = "";
    amountText.value = "";
    rateText.value = "";
    siteCurrency.value = "";
  }
}
