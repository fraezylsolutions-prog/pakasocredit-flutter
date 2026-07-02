import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/image_picker/multiple_image_picker_controller.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/model/help_and_support/ticket_message_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ReplayTicketController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isTicketActionLoading = false.obs;
  final RxBool isReplayTicketLoading = false.obs;
  final MultipleImagePickerController multipleImagePickerController = Get.put(
    MultipleImagePickerController(),
  );
  final TokenService tokenService = Get.find<TokenService>();
  final messageController = TextEditingController();
  final Rx<TicketMessageModel> ticketMessageModel = TicketMessageModel().obs;

  Future<void> fetchTicketMessage({required String ticketUid}) async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.ticketEndpoint}/$ticketUid",
      );
      if (response.status == Status.completed) {
        ticketMessageModel.value = TicketMessageModel();
        ticketMessageModel.value = TicketMessageModel.fromJson(response.data!);
      } else {
        ticketMessageModel.value = TicketMessageModel();
      }
    } finally {}
  }

  Future<void> submitReplayTicket({required String ticketUid}) async {
    isReplayTicketLoading.value = true;
    try {
      final dioInstance = dio.Dio();
      dio.Response response;

      if (multipleImagePickerController.attachedImages.isEmpty) {
        response = await dioInstance.post(
          "${ApiPath.baseUrl}${ApiPath.ticketEndpoint}/reply/$ticketUid",
          data: {'message': messageController.text},
          options: dio.Options(
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${tokenService.accessToken.value}',
            },
          ),
        );
      } else {
        final formData = dio.FormData();

        formData.fields.add(MapEntry('message', messageController.text));

        multipleImagePickerController.attachedImages.forEach((key, file) {
          formData.files.add(
            MapEntry(
              'attachments[]',
              dio.MultipartFile.fromFileSync(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          );
        });

        response = await dioInstance.post(
          "${ApiPath.baseUrl}${ApiPath.ticketEndpoint}/reply/$ticketUid",
          data: formData,
          options: dio.Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${tokenService.accessToken.value}',
            },
          ),
        );
      }
      isReplayTicketLoading.value = false;

      if (response.statusCode == 200) {
        final resData = response.data;
        Fluttertoast.showToast(
          msg: resData["message"],
          backgroundColor: AppColors.success,
        );
        clearForm();
        await fetchTicketMessage(ticketUid: ticketUid);
      } else {}
    } finally {}
  }

  Future<void> submitTicketAction({required String ticketUid}) async {
    isTicketActionLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.ticketEndpoint}/action/$ticketUid",
        data: null,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchTicketMessage(ticketUid: ticketUid);
      }
    } finally {
      isTicketActionLoading.value = false;
    }
  }

  void clearForm() {
    messageController.clear();
    multipleImagePickerController.attachedImages.clear();
  }
}
