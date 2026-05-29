import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/banks_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/beneficiary_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditBeneficiaryDialogSection extends StatefulWidget {
  final String beneficiaryId;

  const EditBeneficiaryDialogSection({super.key, required this.beneficiaryId});

  @override
  State<EditBeneficiaryDialogSection> createState() =>
      _EditBeneficiaryDialogSectionState();
}

class _EditBeneficiaryDialogSectionState
    extends State<EditBeneficiaryDialogSection> {
  final ThemeController themeController = Get.find<ThemeController>();
  final BeneficiaryController beneficiaryController =
      Get.find<BeneficiaryController>();
  final BanksController banksController = Get.put(BanksController());
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "fundTransfer.beneficiaryList.editBeneficiary.title"
                          .trns(),
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
                      CommonRequiredLabelAndDynamicField(
                        labelText:
                            "fundTransfer.beneficiaryList.editBeneficiary.fields.selectBank"
                                .trns(),
                        dynamicField: CommonTextInputField(
                          height: null,
                          textFontWeight: FontWeight.w600,
                          controller: beneficiaryController.editBankController,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          onTap: () {
                            Get.bottomSheet(
                              CommonDropdownBottomSheet(
                                title:
                                    "fundTransfer.beneficiaryList.editBeneficiary.fields.selectBank"
                                        .trns(),
                                onValueSelected: (value) {
                                  beneficiaryController.editBankId.value =
                                      value;
                                },
                                selectedValue:
                                    banksController.banksList
                                        .map((item) => item.id.toString())
                                        .toList(),
                                dropdownItems:
                                    banksController.banksList
                                        .map((item) => item.name!)
                                        .toList(),
                                selectedItem: beneficiaryController.editBank,
                                textController:
                                    beneficiaryController.editBankController,
                                currentlySelectedValue:
                                    beneficiaryController.editBank.value,
                                bottomSheetHeight: 400,
                              ),
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "fundTransfer.beneficiaryList.editBeneficiary.validation.required"
                                  .trns();
                            }
                            return null;
                          },
                          hintText:
                              "fundTransfer.beneficiaryList.editBeneficiary.fields.selectBank"
                                  .trns(),
                          showSuffixIcon: true,
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: Colors.grey.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      CommonRequiredLabelAndDynamicField(
                        labelText:
                            "fundTransfer.beneficiaryList.editBeneficiary.fields.accountNumber"
                                .trns(),
                        labelFontWeight: FontWeight.w700,
                        dynamicField: CommonTextInputField(
                          height: null,
                          hintText: "",
                          controller:
                              beneficiaryController.editAccountNumberController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "fundTransfer.beneficiaryList.editBeneficiary.validation.required"
                                  .trns();
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      CommonRequiredLabelAndDynamicField(
                        labelText:
                            "fundTransfer.beneficiaryList.editBeneficiary.fields.accountName"
                                .trns(),
                        labelFontWeight: FontWeight.w700,
                        dynamicField: CommonTextInputField(
                          height: null,
                          hintText: "",
                          controller:
                              beneficiaryController.editNameOnAccountController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "fundTransfer.beneficiaryList.editBeneficiary.validation.required"
                                  .trns();
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      CommonRequiredLabelAndDynamicField(
                        labelText:
                            "fundTransfer.beneficiaryList.editBeneficiary.fields.branchName"
                                .trns(),
                        labelFontWeight: FontWeight.w700,
                        dynamicField: CommonTextInputField(
                          height: null,
                          hintText: "",
                          controller:
                              beneficiaryController.editBranchNameController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "fundTransfer.beneficiaryList.editBeneficiary.validation.required"
                                  .trns();
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      CommonRequiredLabelAndDynamicField(
                        labelText:
                            "fundTransfer.beneficiaryList.editBeneficiary.fields.nickName"
                                .trns(),
                        labelFontWeight: FontWeight.w700,
                        dynamicField: CommonTextInputField(
                          height: null,
                          hintText: "",
                          controller:
                              beneficiaryController.editNickNameController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "fundTransfer.beneficiaryList.editBeneficiary.validation.required"
                                  .trns();
                            }
                            return null;
                          },
                        ),
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
                        leftIcon: Image.asset(
                          PngAssets.commonCancelIcon,
                          width: 14,
                          color: AppColors.white,
                        ),
                        textColor: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        buttonName:
                            "fundTransfer.beneficiaryList.editBeneficiary.buttons.close"
                                .trns(),
                        onPressed: () => Get.back(),
                      ),
                      SizedBox(width: 10),
                      CommonElevatedButton(
                        borderRadius: 6,
                        width: 120,
                        height: 34,
                        iconSpacing: 4,
                        leftIcon: Image.asset(
                          PngAssets.commonTickIcon,
                          width: 16,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.black
                                  : AppColors.white,
                        ),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        buttonName:
                            "fundTransfer.beneficiaryList.editBeneficiary.buttons.save"
                                .trns(),
                        onPressed: () {
                          Get.back();
                          if (formKey.currentState!.validate()) {
                            beneficiaryController.updateBeneficiary(
                              beneficiaryId: widget.beneficiaryId.toString(),
                            );
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
