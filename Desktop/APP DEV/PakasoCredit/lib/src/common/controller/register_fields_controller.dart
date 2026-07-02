import 'package:pakaso_credit/src/common/model/register_fields_model.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:get/get.dart';

class RegisterFieldsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxMap<String, String> registerFields = <String, String>{}.obs;

  Future<void> loadRegisterFields() async {
    isLoading.value = true;
    await fetchRegisterFields();
    isLoading.value = false;
  }

  Future<void> fetchRegisterFields() async {
    try {
      final response = await Get.find<NetworkService>().globalGet(
        endpoint: ApiPath.getRegisterFieldsEndpoint,
      );
      if (response.status == Status.completed) {
        final RegisterFieldsModel jsonResponse = RegisterFieldsModel.fromJson(
          response.data!,
        );
        registerFields.clear();
        for (var field in jsonResponse.data!) {
          registerFields[field.key!] = field.value!;
        }
      }
    } finally {}
  }
}
