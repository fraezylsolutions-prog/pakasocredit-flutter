import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/onboarding/model/onboarding_model.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxInt currentPage = 0.obs;
  final Rx<OnboardingModel> onboardingModel = OnboardingModel().obs;

  Future<void> fetchOnboarding() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().globalGet(
        endpoint: ApiPath.getOnboardingEndpoint,
      );
      if (response.status == Status.completed) {
        onboardingModel.value = OnboardingModel();
        onboardingModel.value = OnboardingModel.fromJson(response.data!);
      } else {
        onboardingModel.value = OnboardingModel();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
