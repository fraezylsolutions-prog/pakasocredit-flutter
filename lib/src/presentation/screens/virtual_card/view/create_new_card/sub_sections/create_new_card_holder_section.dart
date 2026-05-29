import 'package:pakaso_credit/src/common/controller/country_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/controller/create_new_card_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewCardHolderSection extends StatelessWidget {
  final CreateNewCardController createNewCardController;
  final CountryController countryController;

  const CreateNewCardHolderSection({
    super.key,
    required this.createNewCardController,
    required this.countryController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: !createNewCardController.selectedTab.value,
        child: Column(
          children: [
            CommonTextInputField(
              controller: createNewCardController.nameController,
              hintText:
                  "virtualCard.create_card.holder.newCardHolder.personal.name.label"
                      .trns(),
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 16),
            CommonTextInputField(
              controller: createNewCardController.emailController,
              hintText:
                  "virtualCard.create_card.holder.newCardHolder.personal.email.label"
                      .trns(),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            CommonTextInputField(
              controller: createNewCardController.phoneController,
              hintText:
                  "virtualCard.create_card.holder.newCardHolder.personal.phone.label"
                      .trns(),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            CommonTextInputField(
              textFontWeight: FontWeight.w600,
              controller: createNewCardController.countryController,
              keyboardType: TextInputType.none,
              readOnly: true,
              onTap: () {
                Get.bottomSheet(
                  CommonDropdownBottomSheet(
                    title:
                        "virtualCard.create_card.holder.newCardHolder.address.country.select_title"
                            .trns(),
                    onValueSelected: (value) {
                      createNewCardController.countryCode.value = value ?? "";
                    },
                    selectedValue:
                        countryController.countryList
                            .map((item) => item.code.toString())
                            .toList(),
                    dropdownItems:
                        countryController.countryList
                            .map((item) => item.name!)
                            .toList(),
                    selectedItem: createNewCardController.country,
                    textController: createNewCardController.countryController,
                    currentlySelectedValue:
                        createNewCardController.country.value,
                    bottomSheetHeight: 400,
                    showSearch: true,
                  ),
                );
              },
              hintText:
                  "virtualCard.create_card.holder.newCardHolder.address.country.hint"
                      .trns(),
              showSuffixIcon: true,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: Colors.grey.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 16),
            CommonTextInputField(
              controller: createNewCardController.cityController,
              hintText:
                  "virtualCard.create_card.holder.newCardHolder.address.city.label"
                      .trns(),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            CommonTextInputField(
              controller: createNewCardController.stateController,
              hintText:
                  "virtualCard.create_card.holder.newCardHolder.address.state.label"
                      .trns(),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            CommonTextInputField(
              controller: createNewCardController.postalCodeController,
              hintText:
                  "virtualCard.create_card.holder.newCardHolder.address.postal_code.label"
                      .trns(),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            CommonTextInputField(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              height: null,
              maxLines: 4,
              controller: createNewCardController.addressController,
              hintText:
                  "virtualCard.create_card.holder.newCardHolder.address.street.label"
                      .trns(),
              keyboardType: TextInputType.streetAddress,
            ),
          ],
        ),
      ),
    );
  }
}
