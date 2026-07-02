import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/model/bill_countries_model.dart';
import 'package:get/get.dart';

class PayBillController extends GetxController {
  final Rx<BillCountriesModel> billCountriesModel = BillCountriesModel().obs;

  Future<void> fetchBillCountries({required String type}) async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.billCountriesEndpoint}/$type",
      );
      if (response.status == Status.completed) {
        billCountriesModel.value = BillCountriesModel();
        billCountriesModel.value = BillCountriesModel.fromJson(response.data!);
      }
    } finally {}
  }
}
