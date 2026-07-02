import 'dart:convert';
import 'dart:io';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/controller/payment_service.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/model/deposit_methods_model.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/view/sub_sections/deposit_pending.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/model/wallets_model.dart';
import 'package:pakaso_credit/src/presentation/widgets/web_view/web_view_screen.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DepositController extends GetxController {
  final TokenService tokenService = Get.find<TokenService>();
  final RxBool isLoading = false.obs;
  final RxBool isManualDepositLoading = false.obs;
  final RxString wallet = "".obs;
  final RxString walletId = "".obs;
  final RxString gateway = "".obs;
  final RxString gatewayCode = "".obs;
  final RxString currencyCode = "".obs;
  final RxString copyCurrencyCode = "".obs;
  final RxString gatewayCurrencyCode = "".obs;
  final RxString paymentType = "".obs;
  final RxString gatewayCharge = "".obs;
  final RxString minimumDeposit = "".obs;
  final RxString maximumDeposit = "".obs;
  final RxString amount = "".obs;
  final RxString chargeType = "".obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble chargeAmount = 0.0.obs;
  final RxDouble payAmount = 0.0.obs;
  final RxString paymentDetails = "".obs;
  final RxString gatewayFieldOptions = "".obs;
  final RxString gatewayLogo = "".obs;
  final RxString isMultipleCurrency = "".obs;
  final RxDouble isGatewayRate = 0.0.obs;
  final RxString siteCurrency = "".obs;
  final gatewayController = TextEditingController();
  final walletController = TextEditingController();
  final amountController = TextEditingController();
  final trxNumberController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final RxMap<String, File?> selectedImages = <String, File?>{}.obs;
  final RxMap<String, dynamic> formData = <String, dynamic>{}.obs;
  final RxList<WalletsData> walletsList = <WalletsData>[].obs;
  final RxList<DepositMethodsData> depositMethodsList =
      <DepositMethodsData>[].obs;
  final PaymentService _paymentService = PaymentService();
  final RxBool paymentSuccess = false.obs;

  Future<void> fetchMultipleCurrencyBool() async {
    final multipleCurrencyValue = await SettingsService.getSettingValue(
      "multiple_currency",
    );
    isMultipleCurrency.value = multipleCurrencyValue ?? "";
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> fetchWallets() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.walletsEndpoint,
      );
      if (response.status == Status.completed) {
        final walletsModel = WalletsModel.fromJson(response.data!);
        walletsList.clear();
        walletsList.assignAll(walletsModel.data!);
        if (walletsList.isNotEmpty) {
          wallet.value = walletsList.first.name ?? "";
          walletController.text = walletsList.first.name ?? "";
          currencyCode.value = walletsList.first.code ?? "";
          walletId.value = walletsList.first.id.toString();
          currencyCode.value == "USD" ? copyCurrencyCode.value = "USD" : "";
          await fetchDepositMethods();
        }
      }
    } finally {}
  }

  Future<void> fetchDepositMethods() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint:
            isMultipleCurrency.value == "0"
                ? ApiPath.depositEndpoint
                : "${ApiPath.depositEndpoint}?currency=$currencyCode",
      );
      if (response.status == Status.completed) {
        final depositMethodsModel = DepositMethodsModel.fromJson(
          response.data!,
        );
        depositMethodsList.clear();
        depositMethodsList.assignAll(depositMethodsModel.data!);
      }
    } finally {}
  }

  Future<void> submitDepositManual() async {
    isManualDepositLoading.value = true;
    bool isValid = true;

    try {
      final Map<String, dynamic> parsedFields = jsonDecode(
        gatewayFieldOptions.value,
      );

      parsedFields.forEach((key, field) {
        if (field['validation'] == 'required') {
          final fieldName = field['name'];
          if ((field['type'] == 'text' || field['type'] == 'textarea') &&
              (formData[fieldName] == null ||
                  formData[fieldName].toString().isEmpty)) {
            isValid = false;
            Fluttertoast.showToast(
              msg: "$fieldName is required",
              backgroundColor: AppColors.error,
            );
          } else if (field['type'] == 'file' &&
              !selectedImages.containsKey(fieldName)) {
            isValid = false;
            Fluttertoast.showToast(
              msg: "$fieldName is required",
              backgroundColor: AppColors.error,
            );
          }
        }
      });

      if (!isValid) {
        return;
      }

      if (amountController.text.isNotEmpty) {
        final int enteredAmount = int.tryParse(amountController.text) ?? 0;
        final int minAmount =
            int.tryParse(minimumDeposit.value.toString()) ?? 0;
        final num maxAmount =
            num.tryParse(maximumDeposit.value.toString()) ?? double.infinity;

        if (enteredAmount >= minAmount && enteredAmount <= maxAmount) {
          final formDataPayload = dio.FormData.fromMap({
            'gateway_code': gatewayCode.value,
            'amount': amountController.text,
            'wallet_type': walletId.value == "0" ? "default" : walletId.value,
          });

          formData.forEach((key, value) {
            final fieldKey = 'manual_data[$key]';

            if (value is File) {
              formDataPayload.files.add(
                MapEntry(
                  fieldKey,
                  dio.MultipartFile.fromFileSync(
                    value.path,
                    filename: value.path.split('/').last,
                  ),
                ),
              );
            } else if (value != null) {
              formDataPayload.fields.add(MapEntry(fieldKey, value.toString()));
            }
          });

          final response = await dio.Dio().post(
            "${ApiPath.baseUrl}${ApiPath.depositEndpoint}",
            data: formDataPayload,
            options: dio.Options(
              headers: {
                'Accept': 'application/json',
                'Authorization': 'Bearer ${tokenService.accessToken.value}',
              },
            ),
          );

          if (response.statusCode == 200) {
            Fluttertoast.showToast(
              msg: "Deposit submitted successfully",
              backgroundColor: AppColors.success,
            );
            formData.clear();
            selectedImages.clear();
            clearFields();
            Get.find<NavigationController>().pushPage(
              DepositPending(
                amount: response.data["data"]["amount"] ?? "N/A",
                transaction: response.data["data"]["tnx"] ?? "N/A",
              ),
            );
          } else {
            Fluttertoast.showToast(
              msg: "Failed to submit deposit: ${response.statusMessage}",
              backgroundColor: AppColors.error,
            );
          }
        } else {
          if (enteredAmount < minAmount) {
            Fluttertoast.showToast(
              msg: "Minimum amount is $minAmount",
              backgroundColor: AppColors.error,
            );
          } else if (enteredAmount > maxAmount) {
            Fluttertoast.showToast(
              msg: "Maximum amount is $maxAmount",
              backgroundColor: AppColors.error,
            );
          }
        }
      } else {
        Fluttertoast.showToast(
          msg: "Amount field is required",
          backgroundColor: AppColors.error,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Select Gateway",
        backgroundColor: AppColors.error,
      );
    } finally {
      isManualDepositLoading.value = false;
    }
  }

  Future<void> submitDepositAuto() async {
    isLoading.value = true;
    try {
      if (amountController.text.isNotEmpty) {
        final int enteredAmount = int.tryParse(amountController.text) ?? 0;
        final int minAmount =
            int.tryParse(minimumDeposit.value.toString()) ?? 0;
        final num maxAmount =
            num.tryParse(maximumDeposit.value.toString()) ?? double.infinity;

        if (enteredAmount >= minAmount && enteredAmount <= maxAmount) {
          final result = await _paymentService.makeDeposit(
            gatewayCode: gatewayCode.value,
            amount: amountController.text,
            walletType: walletId.value == "0" ? "default" : walletId.value,
          );

          if (result['success'] == true) {
            final String url = result['redirect_url'];
            clearFields();
            final paymentResult = await Get.to<Map<String, dynamic>>(
              () => WebViewScreen(url: url),
              fullscreenDialog: false,
            );

            if (paymentResult != null && paymentResult['success'] == true) {
              paymentSuccess.value = true;
              clearFields();
              await fetchWallets();
            } else {
              paymentSuccess.value = false;
            }
          }
        } else {
          if (enteredAmount < minAmount) {
            Fluttertoast.showToast(
              msg: "Minimum amount is $minAmount",
              backgroundColor: AppColors.error,
            );
          } else if (enteredAmount > maxAmount) {
            Fluttertoast.showToast(
              msg: "Maximum amount is $maxAmount",
              backgroundColor: AppColors.error,
            );
          }
        }
      } else {
        Fluttertoast.showToast(
          msg: "Amount field is required",
          backgroundColor: AppColors.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onAmountChange() {
    final amountText = amountController.text;
    final amountValue = double.tryParse(amountText) ?? 0;
    amount.value = amountValue.toStringAsFixed(2);
    final charge =
        chargeType.value == 'percentage'
            ? calculatePercentage(
              amountValue,
              double.tryParse(gatewayCharge.value) ?? 0,
            )
            : double.tryParse(gatewayCharge.value) ?? 0;
    chargeAmount.value = charge;
    totalAmount.value = amountValue + charge;
    payAmount.value = totalAmount * isGatewayRate.value;
  }

  double calculatePercentage(double amount, double percentage) {
    return amount * (percentage / 100);
  }

  void clearFields() {
    gateway.value = "";
    gatewayCharge.value = "";
    paymentDetails.value = "";
    gatewayLogo.value = "";
    gatewayFieldOptions.value = "";
    copyCurrencyCode.value = "";
    gatewayCurrencyCode.value = "";
    isGatewayRate.value = 0.0;
    chargeType.value = "";
    minimumDeposit.value = "";
    maximumDeposit.value = "";
    paymentType.value = "";
    gatewayCode.value = "";
    gatewayController.clear();
    amountController.clear();
    depositMethodsList.clear();
  }

  void setFormData(String fieldName, dynamic value) {
    formData[fieldName] = value;
  }

  Future<void> pickImage(String fieldName, ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedImage != null) {
        selectedImages[fieldName] = File(pickedImage.path);
        formData[fieldName] = File(pickedImage.path);
        Get.back();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to pick image",
        backgroundColor: AppColors.error,
      );
    }
  }

  void setSelectedWallet(WalletsData selectedWallet) {
    wallet.value = selectedWallet.name ?? "";
    walletController.text = selectedWallet.name ?? "";
    currencyCode.value = selectedWallet.code ?? "";
    walletId.value = selectedWallet.id.toString();

    if (currencyCode.value == "USD") {
      copyCurrencyCode.value = "USD";
    }

    fetchDepositMethods();
  }
}
