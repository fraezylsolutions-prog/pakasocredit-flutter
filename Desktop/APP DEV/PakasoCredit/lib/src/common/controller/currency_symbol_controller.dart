import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:get/get.dart';

class CurrencySymbolController extends GetxController {
  Future<void> loadCurrencySymbol() async {
    final currencySymbolValue = await SettingsService.getSettingValue(
      "currency_symbol",
    );
    await Get.find<SettingsService>().saveCurrencySymbol(
      currencySymbolValue.toString(),
    );
  }
}
