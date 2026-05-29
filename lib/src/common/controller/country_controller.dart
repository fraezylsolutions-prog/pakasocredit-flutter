import 'package:pakaso_credit/src/common/model/country_model.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:get/get.dart';

class CountryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<CountryData> countryList = <CountryData>[].obs;

  Future<void> loadCountries() async {
    isLoading.value = true;
    await fetchCountries();
    isLoading.value = false;
  }

  Future<void> fetchCountries() async {
    try {
      final response = await Get.find<NetworkService>().globalGet(
        endpoint: ApiPath.countriesEndpoint,
      );
      if (response.status == Status.completed) {
        final CountryModel jsonResponse = CountryModel.fromJson(response.data!);
        countryList.clear();
        countryList.assignAll(jsonResponse.data!);
      }
    } finally {}
  }
}
