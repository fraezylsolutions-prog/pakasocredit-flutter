import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/image_picker/image_picker_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/widgets/bottom_sheet/image_picker_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/controller/edit_withdraw_account_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/model/account_list_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditWithdrawAccount extends StatefulWidget {
  final AccountListData accountData;

  const EditWithdrawAccount({super.key, required this.accountData});

  @override
  State<EditWithdrawAccount> createState() => _EditWithdrawAccountState();
}

class _EditWithdrawAccountState extends State<EditWithdrawAccount> {
  final ImagePickerController imagePickerController = Get.put(
    ImagePickerController(),
  );
  final EditWithdrawAccountController controller = Get.put(
    EditWithdrawAccountController(),
  );

  @override
  void initState() {
    super.initState();
    controller.methodNameController.text = widget.accountData.methodName ?? "";
    imagePickerController.clearImage();
    if (widget.accountData.fields != null) {
      controller.initializeFields(widget.accountData.fields!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                CommonAppBar(
                  title: "withdraw.editWithdrawAccount.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: false,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Obx(() {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.only(left: 18, right: 18, top: 20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        gradient: AppStyles.linearGradient(),
                        boxShadow: AppStyles.boxShadow(),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            CommonRequiredLabelAndDynamicField(
                              labelText:
                                  "withdraw.editWithdrawAccount.methodName"
                                      .trns(),
                              isLabelRequired: true,
                              dynamicField: CommonTextInputField(
                                controller: controller.methodNameController,
                                hintText: "",
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...controller.dynamicFields.entries.map((entry) {
                              final key = entry.key;
                              final field = entry.value;
                              final String type = field['type'];
                              final bool isRequired =
                                  field['validation'] == 'required';

                              Widget dynamicFieldWidget;

                              switch (type) {
                                case 'text':
                                  dynamicFieldWidget = CommonTextInputField(
                                    controller: controller.textControllers[key],
                                    hintText: "",
                                    keyboardType: TextInputType.text,
                                  );
                                case 'textarea':
                                  dynamicFieldWidget = CommonTextInputField(
                                    controller: controller.textControllers[key],
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    hintText: "",
                                    keyboardType: TextInputType.text,
                                    maxLines: 4,
                                    height: null,
                                  );
                                  break;
                                case 'file':
                                  dynamicFieldWidget = GestureDetector(
                                    onTap: () {
                                      Get.bottomSheet(
                                        ImagePickerDropdownBottomSheet(),
                                      );
                                    },
                                    child: Obx(() {
                                      if (imagePickerController
                                              .selectedImage
                                              .value !=
                                          null) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.file(
                                            imagePickerController
                                                .selectedImage
                                                .value!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 130,
                                          ),
                                        );
                                      } else if (field["value"] != null &&
                                          field["value"]
                                              .toString()
                                              .isNotEmpty) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            field["value"],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 130,
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return CommonLoading();
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    _buildPlaceholder(key),
                                          ),
                                        );
                                      } else {
                                        return _buildPlaceholder(key);
                                      }
                                    }),
                                  );
                                  break;

                                default:
                                  dynamicFieldWidget = const SizedBox();
                              }

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: CommonRequiredLabelAndDynamicField(
                                  labelText: key,
                                  isLabelRequired: isRequired,
                                  dynamicField: dynamicFieldWidget,
                                ),
                              );
                            }),
                            CommonElevatedButton(
                              buttonName:
                                  "withdraw.editWithdrawAccount.updateButton"
                                      .trns(),
                              onPressed: () {
                                controller.submitEditWithdrawAccount(
                                  methodId: widget.accountData.id.toString(),
                                  dynamicFields: widget.accountData.fields!,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: controller.isLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String key) {
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            PngAssets.commonAttachFile,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                PngAssets.commonUploadIcon,
                width: 18,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8),
              Text(
                key,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
