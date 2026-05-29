import 'package:pakaso_credit/src/common/model/languages_model.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/utils/helpers/language_storage.dart';
import 'package:get/get.dart';

class LanguagesController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString locale = "".obs;
  final RxList<LanguagesData> languagesList = <LanguagesData>[].obs;

  Future<void> loadLanguages() async {
    isLoading.value = true;
    await fetchLanguages();
    isLoading.value = false;
  }

  Future<void> fetchLanguages() async {
    try {
      final response = await Get.find<NetworkService>().globalGet(
        endpoint: ApiPath.languagesEndpoint,
      );
      if (response.status == Status.completed) {
        final LanguagesModel jsonResponse = LanguagesModel.fromJson(
          response.data!,
        );
        languagesList.clear();
        languagesList.assignAll(jsonResponse.languagesList!);
      }
    } finally {}
  }

  Future<void> changeLanguage(String selectedLocale) async {
    await LanguageStorage.saveLocale(selectedLocale);
  }
}
