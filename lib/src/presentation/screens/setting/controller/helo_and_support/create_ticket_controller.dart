import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/image_picker/multiple_image_picker_controller.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/helo_and_support/ticket_history_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateTicketController extends GetxController {
  final isCreateTicketLoading = false.obs;
  final MultipleImagePickerController multipleImagePickerController = Get.put(
    MultipleImagePickerController(),
  );
  final TokenService tokenService = Get.find<TokenService>();
  final RxString precedence = "".obs;
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final precedenceController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    addAttachment();
  }

  final attachments = <int>[].obs;
  int _nextId = 0;

  void addAttachment() {
    attachments.add(_nextId++);
  }

  void removeAttachment(int id) {
    attachments.remove(id);
  }

  Future<void> createNewTicket() async {
    isCreateTicketLoading.value = true;
    try {
      final dioInstance = dio.Dio();
      final formDataPayload = dio.FormData.fromMap({
        'title': subjectController.text,
        'priority': precedenceController.text,
        'message': messageController.text,
      });

      multipleImagePickerController.attachedImages.forEach((key, value) {
        formDataPayload.files.add(
          MapEntry(
            'attachments[]',
            dio.MultipartFile.fromFileSync(
              value.path,
              filename: value.path.split('/').last,
            ),
          ),
        );
      });

      final response = await dioInstance.post(
        "${ApiPath.baseUrl}${ApiPath.ticketEndpoint}",
        data: formDataPayload,
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenService.accessToken.value}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          Fluttertoast.showToast(
            msg:
                responseData["message"] is String
                    ? responseData["message"]
                    : "Ticket created successfully",
            backgroundColor: AppColors.success,
          );
          clearForm();
          Get.back();
          Get.find<TicketHistoryController>().fetchTickets();
        } else {
          throw Exception("Invalid response format");
        }
      }
    } finally {
      isCreateTicketLoading.value = false;
    }
  }

  void clearForm() {
    subjectController.clear();
    messageController.clear();
    precedenceController.clear();
    precedence.value = "";
    multipleImagePickerController.attachedImages.clear();
    attachments.clear();
    _nextId = 0;
    addAttachment();
  }

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    precedenceController.dispose();
    super.onClose();
  }
}
