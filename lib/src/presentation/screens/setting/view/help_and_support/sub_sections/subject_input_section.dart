import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/helo_and_support/ticket_history_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectInputSection extends StatelessWidget {
  const SubjectInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ticketHistoryController = Get.find<TicketHistoryController>();

    return CommonTextInputField(
      controller: ticketHistoryController.subjectController,
      hintText: "help_and_support.subject_input_section.label".trns(),
      keyboardType: TextInputType.text,
    );
  }
}
