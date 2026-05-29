import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/currency_symbol_controller.dart';
import 'package:pakaso_credit/src/utils/helpers/language_storage.dart';
import 'package:get/get.dart';

class SplashController {
  final currencyController = Get.find<CurrencySymbolController>();

  Future<void> nextToMoveScreen() async {
    await currencyController.loadCurrencySymbol();
    final isLoggedIn = await LanguageStorage.getLoggedInState();

    Future.delayed(const Duration(seconds: 2), () {
      if (isLoggedIn != null && isLoggedIn.isNotEmpty) {
        Get.offNamed(BaseRoute.signIn);
      } else {
        Get.offNamed(BaseRoute.welcome);
      }
    });
  }
}
