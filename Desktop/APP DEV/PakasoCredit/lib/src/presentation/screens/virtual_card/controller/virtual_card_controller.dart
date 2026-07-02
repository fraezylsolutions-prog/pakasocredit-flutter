import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/model/user_model.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/model/virtual_card_details_model.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/model/virtual_cards_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class VirtualCardController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isCardLoading = false.obs;
  final RxBool isTopUpLoading = false.obs;
  final RxBool isCardTopUpLoading = false.obs;
  final RxString minCardTopUp = "".obs;
  final RxString maxCardTopUp = "".obs;
  final RxString cardTopUp = "".obs;
  final RxString cardCreation = "".obs;
  final RxString currencySymbol = "".obs;
  final RxString siteCurrency = "".obs;
  final RxList<VirtualCardsData> virtualCardList = <VirtualCardsData>[].obs;
  final Rx<VirtualCardDetailsModel> virtualCardDetailsModel =
      VirtualCardDetailsModel().obs;
  final Rx<UserModel> userModel = UserModel().obs;
  final amountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchVirtualCards();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final cardCreationValue = await SettingsService.getSettingValue(
      'card_creation',
    );
    cardCreation.value = cardCreationValue ?? "";
  }

  Future<void> fetchVirtualCards() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.virtualCardsEndpoint,
      );
      if (response.status == Status.completed) {
        final virtualCardModel = VirtualCardsModel.fromJson(response.data!);
        virtualCardList.clear();
        virtualCardList.assignAll(virtualCardModel.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchVirtualCardDetails({required String cardId}) async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.virtualCardsEndpoint}/$cardId",
      );
      if (response.status == Status.completed) {
        virtualCardDetailsModel.value = VirtualCardDetailsModel();
        virtualCardDetailsModel.value = VirtualCardDetailsModel.fromJson(
          response.data!,
        );
      } else {
        virtualCardDetailsModel.value = VirtualCardDetailsModel();
      }
    } finally {}
  }

  Future<void> cardUpdateStatus({required String cardId}) async {
    try {
      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.virtualCardsEndpoint}/update-status/$cardId",
        data: null,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchVirtualCardDetails(cardId: cardId);
      }
    } finally {}
  }

  Future<void> fetchUser() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.userEndpoint,
      );
      if (response.status == Status.completed) {
        userModel.value = UserModel();
        userModel.value = UserModel.fromJson(response.data!);
      } else {
        userModel.value = UserModel();
      }
    } finally {}
  }

  Future<void> loadCurrencySymbol() async {
    final currencySymbolValue = await SettingsService.getSettingValue(
      "currency_symbol",
    );
    currencySymbol.value = currencySymbolValue ?? "";
  }

  Future<void> loadMinCardTopUp() async {
    final minCardTopupValue = await SettingsService.getSettingValue(
      "min_card_topup",
    );
    minCardTopUp.value = minCardTopupValue ?? "";
  }

  Future<void> loadMaxCardTopUp() async {
    final maxCardTopupValue = await SettingsService.getSettingValue(
      "max_card_topup",
    );
    maxCardTopUp.value = maxCardTopupValue ?? "";
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> cardBalanceTopUp({required String cardId}) async {
    isCardTopUpLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "amount": amountController.text,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.virtualCardsEndpoint}/balance/topup/$cardId",
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        amountController.clear();
        Get.find<NavigationController>().popPage();
      }
    } finally {
      isCardTopUpLoading.value = false;
    }
  }
}
