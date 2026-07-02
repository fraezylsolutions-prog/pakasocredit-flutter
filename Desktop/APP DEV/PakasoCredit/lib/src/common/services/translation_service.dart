import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:get/get.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();

  factory TranslationService() => _instance;

  TranslationService._internal();

  Map<String, dynamic> _translations = {};
  bool _isLoaded = false;

  Future<void> loadTranslations(String languageCode) async {
    final response = await Get.find<NetworkService>().globalGet(
      endpoint: ApiPath.translationEndpoint(languageCode: languageCode),
    );
    if (response.status == Status.completed) {
      _translations = response.data!["translations_keys"];
      _isLoaded = true;
    }
  }

  String get(String key) {
    if (!_isLoaded) return key;
    final parts = key.split('.');
    dynamic value = _translations;
    for (final part in parts) {
      if (value is Map && value.containsKey(part)) {
        value = value[part];
      } else {
        return key;
      }
    }
    return value is String ? value : key;
  }

  String format(String key, Map<String, dynamic> variables) {
    String text = get(key);
    variables.forEach((k, v) {
      text = text.replaceAll(':$k', v.toString());
    });
    return text;
  }
}
