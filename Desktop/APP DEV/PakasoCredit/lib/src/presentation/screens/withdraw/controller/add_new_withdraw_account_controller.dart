import 'dart:convert';
import 'dart:io';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/controller/withdraw_account_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/model/withdraw_method_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddNewWithdrawAccountController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isAddAccountLoading = false.obs;
  final ImagePicker _picker = ImagePicker();
  final RxString gateway = "".obs;
  final RxString gatewayId = "".obs;
  final RxString gatewayFields = "".obs;
  final RxString methodCurrency = "".obs;
  final RxMap<String, dynamic> formData = <String, dynamic>{}.obs;
  final RxList<WithdrawMethodData> withdrawMethodList =
      <WithdrawMethodData>[].obs;
  final RxMap<String, File?> selectedImages = <String, File?>{}.obs;
  final TokenService tokenService = Get.find<TokenService>();
  final gatewayController = TextEditingController();
  final methodNameController = TextEditingController();
  final Map<String, TextEditingController> textControllers = {};

  Future<void> fetchAccounts() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.withdrawMethodsEndpoint,
      );
      if (response.status == Status.completed) {
        final withdrawMethodModel = WithdrawMethodModel.fromJson(
          response.data!,
        );
        withdrawMethodList.clear();
        withdrawMethodList.assignAll(withdrawMethodModel.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAddWithdrawAccount() async {
    isAddAccountLoading.value = true;
    try {
      final dioInstance = dio.Dio();
      final formDataToSend = dio.FormData();
      final parsedFields =
          jsonDecode(gatewayFields.value) as Map<String, dynamic>;

      formDataToSend.fields.add(
        MapEntry('method_name', methodNameController.text),
      );
      formDataToSend.fields.add(
        MapEntry('withdraw_method_id', gatewayId.value.toString()),
      );

      parsedFields.forEach((_, field) {
        final name = field['name'] as String;
        final type = field['type'] as String;
        final validation = field['validation'] as String;
        final value = formData[name];
        final file = selectedImages[name];

        if (type == "file") {
          if (file != null) {
            formDataToSend.files.add(
              MapEntry(
                'fields[$name][value]',
                dio.MultipartFile.fromFileSync(
                  file.path,
                  filename: file.path.split('/').last,
                ),
              ),
            );

            formDataToSend.fields.add(
              MapEntry('fields[$name][value]', 'file_uploaded'),
            );
          } else {
            formDataToSend.fields.add(MapEntry('fields[$name][value]', ''));
          }

          formDataToSend.fields.add(MapEntry('fields[$name][type]', type));
          formDataToSend.fields.add(
            MapEntry('fields[$name][validation]', validation),
          );
        } else {
          formDataToSend.fields.add(
            MapEntry('fields[$name][value]', value?.toString() ?? ''),
          );

          formDataToSend.fields.add(MapEntry('fields[$name][type]', type));
          formDataToSend.fields.add(
            MapEntry('fields[$name][validation]', validation),
          );
        }
      });

      final response = await dioInstance.post(
        "${ApiPath.baseUrl}${ApiPath.withdrawAccountEndpoint}",
        data: formDataToSend,
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenService.accessToken.value}',
          },
        ),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: response.data["message"],
          backgroundColor: AppColors.success,
        );
        clearData();
        Get.find<NavigationController>().popPage();
        await Get.find<WithdrawAccountController>().fetchAccounts();
      }
    } finally {
      isAddAccountLoading.value = false;
    }
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

  void setFormData(String fieldName, dynamic value) {
    formData[fieldName] = value;
  }

  void clearData() {
    gateway.value = "";
    gatewayId.value = "";
    gatewayFields.value = "";
    methodCurrency.value = "";
    formData.clear();
    withdrawMethodList.clear();
    selectedImages.clear();
    gatewayController.clear();
    methodNameController.clear();
    textControllers.clear();
  }
}
