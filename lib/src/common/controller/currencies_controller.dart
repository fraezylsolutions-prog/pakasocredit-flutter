import 'package:pakaso_credit/src/common/model/currencies_model.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:get/get.dart';

class CurrenciesController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<CurrenciesData> currenciesList = <CurrenciesData>[].obs;

  Future<void> loadCurrencies() async {
    isLoading.value = true;
    await fetchCurrencies();
    isLoading.value = false;
  }

  Future<void> fetchCurrencies() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.currenciesEndpoint,
      );
      if (response.status == Status.completed) {
        final currenciesModel = CurrenciesModel.fromJson(response.data!);
        currenciesList.clear();
        currenciesList.assignAll(currenciesModel.data!);
      }
    } finally {}
  }
}
