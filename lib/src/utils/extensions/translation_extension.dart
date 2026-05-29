import 'package:pakaso_credit/src/common/services/translation_service.dart';

extension TranslationsExtension on String {
  String trns() => TranslationService().get(this);

  String trnsFormat(Map<String, dynamic> variables) =>
      TranslationService().format(this, variables);
}
