import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/banks_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/beneficiary_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewBeneficiaryDialogSection extends StatefulWidget {
  const AddNewBeneficiaryDialogSection({super.key});

  @override
  State<AddNewBeneficiaryDialogSection> createState() =>
      _AddNewBeneficiaryDialogSectionState();
}

class _AddNewBeneficiaryDialogSectionState
    extends State<AddNewBeneficiaryDialogSection> {
  final ThemeController themeController = Get.find<ThemeController>();
  final BeneficiaryController beneficiaryController =
      Get.find<BeneficiaryController>();
  final BanksController banksController = Get.find<BanksController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "fundTransfer.addBeneficiary.title".trns(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(8, 0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          Get.back();
                          beneficiaryController.clearFields();
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor:
                              themeController.isDarkMode.value
                                  ? AppColors.white.withValues(alpha: 0.05)
                                  : AppColors.black.withValues(alpha: 0.05),
                          child: Image.asset(
                            PngAssets.commonCancelIcon,
                            width: 14,
                            fit: BoxFit.contain,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.white
                                    : AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CommonTextInputField(
                        height: null,
                        textFontWeight: FontWeight.w600,
                        controller: beneficiaryController.bankController,
                        keyboardType: TextInputType.none,
                        readOnly: true,
                        onTap: () {
                          Get.bottomSheet(
                            CommonDropdownBottomSheet(
                              title:
                                  "fundTransfer.addBeneficiary.fields.selectBank"
                                      .trns(),
                              onValueSelected: (value) {
                                beneficiaryController.bankId.value = value;
                              },
                              selectedValue:
                                  banksController.banksList
                                      .map((item) => item.id.toString())
                                      .toList(),
                              dropdownItems:
                                  banksController.banksList
                                      .map((item) => item.name!)
                                      .toList(),
                              selectedItem: beneficiaryController.bank,
                              textController:
                                  beneficiaryController.bankController,
                              currentlySelectedValue:
                                  beneficiaryController.bank.value,
                              bottomSheetHeight: 400,
                            ),
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "fundTransfer.addBeneficiary.validation.required"
                                .trns();
                          }
                          return null;
                        },
                        hintText:
                            "fundTransfer.addBeneficiary.fields.selectBank"
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
                        height: null,
                        hintText:
                            "fundTransfer.addBeneficiary.fields.accountNumber"
                                .trns(),
                        controller:
                            beneficiaryController.accountNumberController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "fundTransfer.addBeneficiary.validation.required"
                                .trns();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      CommonTextInputField(
                        height: null,
                        hintText:
                            "fundTransfer.addBeneficiary.fields.accountName"
                                .trns(),
                        controller:
                            beneficiaryController.nameOnAccountController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "fundTransfer.addBeneficiary.validation.required"
                                .trns();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      CommonTextInputField(
                        height: null,
                        hintText:
                            "fundTransfer.addBeneficiary.fields.branchName"
                                .trns(),
                        controller: beneficiaryController.branchNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "fundTransfer.addBeneficiary.validation.required"
                                .trns();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      CommonTextInputField(
                        height: null,
                        hintText:
                            "fundTransfer.addBeneficiary.fields.nickName"
                                .trns(),
                        controller: beneficiaryController.nickNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "fundTransfer.addBeneficiary.validation.required"
                                .trns();
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonElevatedButton(
                        borderRadius: 6,
                        width: 80,
                        height: 34,
                        iconSpacing: 4,
                        backgroundColor: AppColors.error,
                        textColor: AppColors.white,
                        leftIcon: Image.asset(
                          PngAssets.commonCancelIcon,
                          width: 14,
                          color: AppColors.white,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        buttonName:
                            "fundTransfer.addBeneficiary.buttons.close".trns(),
                        onPressed: () {
                          Get.back();
                          beneficiaryController.clearFields();
                        },
                      ),
                      SizedBox(width: 10),
                      CommonElevatedButton(
                        borderRadius: 6,
                        width: 90,
                        height: 34,
                        iconSpacing: 4,
                        leftIcon: Image.asset(
                          PngAssets.commonTickIcon,
                          width: 14,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.black
                                  : AppColors.white,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        buttonName:
                            "fundTransfer.addBeneficiary.buttons.add".trns(),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Get.back();
                            beneficiaryController.createNewBeneficiary();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
