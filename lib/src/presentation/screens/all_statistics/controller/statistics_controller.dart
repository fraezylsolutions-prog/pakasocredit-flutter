import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/all_statistics/model/statistics_model.dart';
import 'package:get/get.dart';

class StatisticsController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<StatisticsModel> statisticsModel = StatisticsModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.statisticsEndpoint,
      );
      if (response.status == Status.completed) {
        statisticsModel.value = StatisticsModel.fromJson(response.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
