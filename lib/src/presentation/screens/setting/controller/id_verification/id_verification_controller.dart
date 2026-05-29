import 'dart:io';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/model/user_model.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/model/id_verification/kyc_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class IdVerificationController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final RxBool isLoading = false.obs;
  final RxBool iskycSubmitLoading = false.obs;
  final RxList<KycData> kycList = <KycData>[].obs;
  final RxMap<String, File?> selectedImages = <String, File?>{}.obs;
  final RxMap<String, dynamic> formData = <String, dynamic>{}.obs;
  final TokenService tokenService = Get.find<TokenService>();
  final Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await fetchUser();
    await fetchKyc();
    isLoading.value = false;
  }

  Future<void> fetchUser() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.userEndpoint,
      );
      if (response.status == Status.completed) {
        userModel.value = UserModel.fromJson(response.data!);
      }
    } finally {}
  }

  Future<void> fetchKyc() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.kycEndpoint,
      );
      if (response.status == Status.completed) {
        final kycModel = KycModel.fromJson(response.data!);
        kycList.clear();
        kycList.assignAll(kycModel.data!);
      }
    } finally {}
  }

  Future<void> submitKycForm(int kycId) async {
    iskycSubmitLoading.value = true;
    try {
      final dioInstance = dio.Dio();
      final formDataPayload = dio.FormData.fromMap({'kyc_id': kycId});
      formData.forEach((key, value) {
        String fieldKey = 'fields[$key]';

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

      final response = await dioInstance.post(
        "${ApiPath.baseUrl}${ApiPath.kycEndpoint}",
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
          msg: response.data["message"],
          backgroundColor: AppColors.success,
        );
        formData.clear();
        selectedImages.clear();
        Get.find<NavigationController>().popPage();
        await fetchKyc();
        await fetchUser();
      }
    } finally {
      iskycSubmitLoading.value = false;
    }
  }

  Future<void> pickImage(
    String fieldName,
    ImageSource source, {
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        preferredCameraDevice: preferredCameraDevice,
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

  Future<void> pickImageWithFrontCamera(String fieldName) async {
    await pickImage(
      fieldName,
      ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
  }

  void clearImage(String fieldName) {
    selectedImages.remove(fieldName);
    formData.remove(fieldName);
  }

  void setFormData(String fieldName, dynamic value) {
    formData[fieldName] = value;
  }
}
