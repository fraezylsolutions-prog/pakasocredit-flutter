import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/image_picker/image_picker_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/controller/withdraw_account_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EditWithdrawAccountController extends GetxController {
  final RxBool isLoading = false.obs;
  final methodNameController = TextEditingController();
  final Map<String, TextEditingController> textControllers = {};
  final RxMap<String, dynamic> dynamicFields = <String, dynamic>{}.obs;
  final ImagePickerController imagePickerController = Get.put(
    ImagePickerController(),
  );
  final TokenService tokenService = Get.find<TokenService>();

  void initializeFields(Map<String, dynamic> fields) {
    dynamicFields.value = fields;

    fields.forEach((key, value) {
      if (value["type"] == "text" || value["type"] == "textarea") {
        textControllers[key] = TextEditingController(text: value["value"]);
      }
    });
  }

  Future<void> submitEditWithdrawAccount({
    required String methodId,
    required Map<String, dynamic> dynamicFields,
  }) async {
    isLoading.value = true;

    try {
      final dioInstance = dio.Dio();
      final formDataToSend = dio.FormData();

      formDataToSend.fields.add(
        MapEntry('method_name', methodNameController.text),
      );
      formDataToSend.fields.add(MapEntry('_method', "PUT"));

      dynamicFields.forEach((name, field) {
        final type = field['type'] as String;
        final validation = field['validation'] as String;

        if (type == "file") {
          if (imagePickerController.selectedImage.value != null) {
            final file = imagePickerController.selectedImage.value!;
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
          } else if (field['value'] != null &&
              field['value'].toString().isNotEmpty) {
            formDataToSend.fields.add(
              MapEntry('fields[$name][value]', field['value'].toString()),
            );
          } else {
            formDataToSend.fields.add(MapEntry('fields[$name][value]', ''));
          }

          formDataToSend.fields.add(MapEntry('fields[$name][type]', type));
          formDataToSend.fields.add(
            MapEntry('fields[$name][validation]', validation),
          );
        } else {
          final controller = textControllers[name];
          final value = controller?.text ?? field['value']?.toString() ?? '';
          formDataToSend.fields.add(MapEntry('fields[$name][value]', value));
          formDataToSend.fields.add(MapEntry('fields[$name][type]', type));
          formDataToSend.fields.add(
            MapEntry('fields[$name][validation]', validation),
          );
        }
      });

      final response = await dioInstance.post(
        "${ApiPath.baseUrl}${ApiPath.withdrawAccountEndpoint}/$methodId",
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
        clearAllFields();
        imagePickerController.clearImage();
        Get.find<NavigationController>().popPage();
        await Get.find<WithdrawAccountController>().fetchAccounts();
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    methodNameController.dispose();
    textControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.onClose();
  }

  void clearAllFields() {
    methodNameController.clear();
    textControllers.forEach((key, controller) => controller.clear());
    dynamicFields.clear();
    imagePickerController.clearImage();
  }
}
