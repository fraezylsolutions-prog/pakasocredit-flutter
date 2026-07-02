import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/controller/create_new_card_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseCardProviderSection extends StatelessWidget {
  const ChooseCardProviderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateNewCardController createNewCardController =
        Get.find<CreateNewCardController>();

    return CommonTextInputField(
      textFontWeight: FontWeight.w600,
      controller: createNewCardController.cardProviderController,
      keyboardType: TextInputType.none,
      readOnly: true,
      onTap: () {
        Get.bottomSheet(
          CommonDropdownBottomSheet(
            title: "virtualCard.create_card.provider.select_title".trns(),
            onValueSelected: (value) {},
            selectedValue:
                createNewCardController.cardProvidersList
                    .map((item) => item.name.toString())
                    .toList(),
            dropdownItems:
                createNewCardController.cardProvidersList
                    .map((item) => item.name!)
                    .toList(),
            selectedItem: createNewCardController.cardProvider,
            textController: createNewCardController.cardProviderController,
            currentlySelectedValue: createNewCardController.cardProvider.value,
            bottomSheetHeight: 400,
          ),
        );
      },
      hintText: "virtualCard.create_card.provider.hint".trns(),
      showSuffixIcon: true,
      suffixIcon: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 20,
        color: Colors.grey.withValues(alpha: 0.8),
      ),
    );
  }
}
