import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/controller/virtual_card_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/model/card_holders_model.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/model/card_providers_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateNewCardController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isCreateNewCardLoading = false.obs;
  final RxBool selectedTab = true.obs;
  final RxString cardProvider = "".obs;
  final RxString cardHolderId = "".obs;
  final RxString cardHolderNameAndEmail = "".obs;
  final RxString country = "".obs;
  final RxString countryCode = "".obs;
  final cardProviderController = TextEditingController();
  final cardHolderController = TextEditingController();
  final countryController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final addressController = TextEditingController();
  final RxList<CardProvidersData> cardProvidersList = <CardProvidersData>[].obs;
  final RxList<CardHoldersData> cardHoldersList = <CardHoldersData>[].obs;

  Future<void> fetchCardProviders() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.cardProvidersEndpoint,
      );
      if (response.status == Status.completed) {
        final cardProvidersModel = CardProvidersModel.fromJson(response.data!);
        cardProvidersList.clear();
        cardProvidersList.assignAll(cardProvidersModel.data!);
      }
    } finally {}
  }

  Future<void> fetchCardHolders() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.cardHoldersEndpoint,
      );
      if (response.status == Status.completed) {
        final cardHoldersModel = CardHoldersModel.fromJson(response.data!);
        cardHoldersList.clear();
        cardHoldersList.assignAll(cardHoldersModel.data!);
      }
    } finally {}
  }

  Future<void> createNewCard() async {
    isCreateNewCardLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        'card_provider_name': cardProviderController.text,
        'type':
            selectedTab.value == true
                ? 'existing_one'
                : selectedTab.value == false
                ? "new_one"
                : null,
        if (selectedTab.value == true) 'cardholder_id': cardHolderId.value,
      };
      if (selectedTab.value == false) {
        requestBody.addAll({
          'name': nameController.text,
          'email': emailController.text,
          'phone_number': phoneController.text,
          'address': addressController.text,
          'city': cityController.text,
          'state': stateController.text,
          'postal_code': postalCodeController.text,
          'country': countryCode.value,
        });
      }

      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.virtualCardsEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        clearFields();
        Get.find<NavigationController>().popPage();
        await Get.find<VirtualCardController>().fetchVirtualCards();
      }
    } finally {
      isCreateNewCardLoading.value = false;
    }
  }

  bool validateFields() {
    if (cardProviderController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Card provider is required",
        backgroundColor: AppColors.error,
      );
      return false;
    }

    if (selectedTab.value == false) {
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          phoneController.text.isEmpty ||
          addressController.text.isEmpty ||
          cityController.text.isEmpty ||
          stateController.text.isEmpty ||
          postalCodeController.text.isEmpty ||
          countryController.text.isEmpty) {
        Fluttertoast.showToast(
          msg: "All fields are required for new card holders",
          backgroundColor: AppColors.error,
        );
        return false;
      }

      if (!GetUtils.isEmail(emailController.text)) {
        Fluttertoast.showToast(
          msg: "Please enter a valid email",
          backgroundColor: AppColors.error,
        );
        return false;
      }
    }

    return true;
  }

  void clearFields() {
    selectedTab.value = true;
    cardProvider.value = "";
    cardHolderId.value = "";
    cardHolderNameAndEmail.value = "";
    country.value = "";
    countryCode.value = "";
    cardProviderController.clear();
    cardHolderController.clear();
    countryController.clear();
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    cityController.clear();
    stateController.clear();
    postalCodeController.clear();
    addressController.clear();
    cardProvidersList.clear();
    cardHoldersList.clear();
  }
}
