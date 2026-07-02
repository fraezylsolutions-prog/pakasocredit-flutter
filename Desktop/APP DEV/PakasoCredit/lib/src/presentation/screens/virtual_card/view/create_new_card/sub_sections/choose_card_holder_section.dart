import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/controller/create_new_card_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseCardHolderSection extends StatelessWidget {
  final CreateNewCardController createNewCardController;

  const ChooseCardHolderSection({
    super.key,
    required this.createNewCardController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: createNewCardController.selectedTab.value,
        child: CommonTextInputField(
          textFontWeight: FontWeight.w600,
          controller: createNewCardController.cardHolderController,
          keyboardType: TextInputType.none,
          readOnly: true,
          onTap: () {
            List<String> formattedCardHolders =
                createNewCardController.cardHoldersList.map((item) {
                  return "${item.name} - ${item.email}";
                }).toList();

            Get.bottomSheet(
              CommonDropdownBottomSheet(
                title:
                    "virtualCard.create_card.holder.cardHolder.select_title"
                        .trns(),
                onValueSelected: (value) async {
                  int index = formattedCardHolders.indexOf(value);
                  if (index != -1) {
                    final selectedCardHolder =
                        createNewCardController.cardHoldersList[index];
                    createNewCardController.cardHolderId.value =
                        selectedCardHolder.id.toString();
                  }
                },
                selectedValue: formattedCardHolders,
                dropdownItems: formattedCardHolders,
                selectedItem: createNewCardController.cardHolderNameAndEmail,
                textController: createNewCardController.cardHolderController,
                currentlySelectedValue:
                    createNewCardController.cardHolderNameAndEmail.value,
                bottomSheetHeight: 400,
              ),
            );
          },
          hintText: "virtualCard.create_card.holder.cardHolder.hint".trns(),
          showSuffixIcon: true,
          suffixIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Colors.grey.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}
