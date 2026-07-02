import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/image_picker/image_picker_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/model/user_model.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProfileSettingsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isProfileUpdateLoading = false.obs;
  final RxString gender = "".obs;
  final RxString dateOfBirth = "".obs;
  final RxString avatar = "".obs;
  final Rx<UserModel> userModel = UserModel().obs;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final genderController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final joiningDateController = TextEditingController();
  final addressController = TextEditingController();
  final ImagePickerController imagePickerController = Get.put(
    ImagePickerController(),
  );
  final TokenService tokenService = Get.find<TokenService>();

  Future<void> fetchUser() async {
    isLoading.value = true;
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitUpdateProfile() async {
    isProfileUpdateLoading.value = true;
    try {
      final dioInstance = dio.Dio();
      final imageFile = imagePickerController.selectedImage.value;

      final formData = dio.FormData.fromMap({
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'username': userNameController.text,
        'gender': genderController.text,
        if (dateOfBirth.value.isNotEmpty) 'date_of_birth': dateOfBirth.value,
        'phone': phoneController.text,
        'city': cityController.text,
        'zip_code': zipController.text,
        'address': addressController.text,
        if (imageFile != null)
          'avatar': await dio.MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });
      final response = await dioInstance.post(
        "${ApiPath.baseUrl}${ApiPath.profileSettingsEndpoint}/profile",
        data: formData,
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
        Get.find<NavigationController>().popPage();
        await Get.find<HomeController>().fetchUser();
        await Get.find<HomeController>().fetchDashboard();
      }
    } on dio.DioException catch (e) {
      Fluttertoast.showToast(
        msg: e.response!.data["message"],
        backgroundColor: AppColors.error,
      );
    } finally {
      isProfileUpdateLoading.value = false;
    }
  }
}
