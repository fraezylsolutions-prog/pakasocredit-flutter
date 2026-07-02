import 'package:pakaso_credit/src/common/controller/branches_controller.dart';
import 'package:pakaso_credit/src/common/controller/country_controller.dart';
import 'package:pakaso_credit/src/common/controller/currency_symbol_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/common/services/translation_service.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TokenService>(TokenService());
    Get.put<SettingsService>(SettingsService());
    Get.put<NetworkService>(NetworkService());
    Get.put<CurrencySymbolController>(CurrencySymbolController());
    Get.put<CountryController>(CountryController());
    Get.put<BranchesController>(BranchesController());
    Get.put<TranslationService>(TranslationService());
  }
}
