import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/portfolio/model/portfolio_model.dart';
import 'package:get/get.dart';

class PortfolioController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<PortfolioData> portfolioList = <PortfolioData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPortfolio();
  }

  Future<void> fetchPortfolio() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.portfolioEndpoint,
      );
      if (response.status == Status.completed) {
        final portfolioModel = PortfolioModel.fromJson(response.data!);
        portfolioList.clear();
        portfolioList.assignAll(portfolioModel.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
