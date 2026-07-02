import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/image_picker/multiple_image_picker_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/bottom_sheet/multiple_image_picker_bottom_sheet.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_label_text.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/helo_and_support/create_ticket_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class OpenNewTicketDialogSection extends StatefulWidget {
  const OpenNewTicketDialogSection({super.key});

  @override
  State<OpenNewTicketDialogSection> createState() =>
      _OpenNewTicketDialogSectionState();
}

class _OpenNewTicketDialogSectionState
    extends State<OpenNewTicketDialogSection> {
  final ThemeController themeController = Get.find<ThemeController>();
  final CreateTicketController createTicketController = Get.put(
    CreateTicketController(),
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "help_and_support.create_ticket_dialog.title".trns(),
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
                    CommonTextInputField(
                      controller: createTicketController.subjectController,
                      hintText:
                          "help_and_support.create_ticket_dialog.subject_label"
                              .trns(),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 20),
                    CommonTextInputField(
                      textFontWeight: FontWeight.w600,
                      controller: createTicketController.precedenceController,
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      onTap: () {
                        Get.bottomSheet(
                          CommonDropdownBottomSheet(
                            title:
                                "help_and_support.create_ticket_dialog.dropdown_title"
                                    .trns(),
                            dropdownItems: [
                              "help_and_support.create_ticket_dialog.precedence_options.low"
                                  .trns(),
                              "help_and_support.create_ticket_dialog.precedence_options.medium"
                                  .trns(),
                              "help_and_support.create_ticket_dialog.precedence_options.high"
                                  .trns(),
                            ],
                            selectedItem: createTicketController.precedence,
                            textController:
                                createTicketController.precedenceController,
                            currentlySelectedValue:
                                createTicketController.precedence.value,
                            bottomSheetHeight: 300,
                          ),
                        );
                      },
                      hintText:
                          "help_and_support.create_ticket_dialog.precedence_placeholder"
                              .trns(),
                      showSuffixIcon: true,
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: Colors.grey.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 20),
                    CommonTextInputField(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      controller: createTicketController.messageController,
                      hintText:
                          "help_and_support.create_ticket_dialog.message_label"
                              .trns(),
                      height: null,
                      maxLines: 5,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonLabelText(
                          text:
                              "help_and_support.create_ticket_dialog.attachments_label"
                                  .trns(),
                          isRequired: false,
                        ),
                        GestureDetector(
                          onTap: () => createTicketController.addAttachment(),
                          child: Container(
                            padding: EdgeInsets.all(3),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkPrimary
                                      : AppColors.primary,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Image.asset(
                              PngAssets.commonAddIcon,
                              width: 14,
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.black
                                      : AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => Column(
                        children:
                            createTicketController.attachments
                                .map(
                                  (id) => Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: _buildAttachmentItem(
                                      context,
                                      id,
                                      createTicketController,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonElevatedButton(
                            iconSpacing: 4,
                            backgroundColor: AppColors.error,
                            borderRadius: 6,
                            width: 70,
                            height: 32,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            textColor: AppColors.white,
                            buttonName:
                                "help_and_support.create_ticket_dialog.close_button"
                                    .trns(),
                            onPressed: () => Get.back(),
                            leftIcon: Image.asset(
                              PngAssets.commonCancelIcon,
                              width: 14,
                            ),
                          ),
                          SizedBox(width: 10),
                          CommonElevatedButton(
                            iconSpacing: 4,
                            borderRadius: 6,
                            width: 112,
                            height: 32,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            buttonName:
                                "help_and_support.create_ticket_dialog.create_button"
                                    .trns(),
                            onPressed: () {
                              if (createTicketController
                                      .subjectController
                                      .text
                                      .isNotEmpty &&
                                  createTicketController
                                      .precedenceController
                                      .text
                                      .isNotEmpty &&
                                  createTicketController
                                      .messageController
                                      .text
                                      .isNotEmpty) {
                                createTicketController.createNewTicket();
                              } else {
                                Fluttertoast.showToast(
                                  msg:
                                      "help_and_support.create_ticket_dialog.toast_required_fields"
                                          .trns(),
                                  backgroundColor: AppColors.error,
                                );
                              }
                            },
                            leftIcon: Image.asset(
                              PngAssets.commonTickIcon,
                              width: 14,
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.black
                                      : AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: createTicketController.isCreateTicketLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentItem(
    BuildContext context,
    int id,
    CreateTicketController controller,
  ) {
    final MultipleImagePickerController multipleImagePickerController = Get.put(
      MultipleImagePickerController(),
    );

    return GestureDetector(
      onTap: () {
        showImageSourceSheet(id);
      },
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              themeController.isDarkMode.value
                  ? PngAssets.commonDarkAttachFile
                  : PngAssets.commonAttachFile,
            ),
            if (multipleImagePickerController.images.containsKey(id))
              Container(
                width: 100,
                height: 70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(multipleImagePickerController.images[id]!),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            if (!multipleImagePickerController.images.containsKey(id))
              Column(
                children: [
                  Image.asset(
                    PngAssets.commonUploadIcon,
                    width: 18,
                    height: 18,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextTertiary
                            : AppColors.textTertiary,
                  ),
                  SizedBox(height: 2),
                  Text(
                    "help_and_support.create_ticket_dialog.attach_file".trns(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextTertiary
                              : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            if (controller.attachments.length > 1 ||
                multipleImagePickerController.images.containsKey(id))
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => controller.removeAttachment(id),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      PngAssets.commonCancelIcon,
                      width: 14,
                      height: 14,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showImageSourceSheet(int attachmentId) {
    Get.bottomSheet(MultipleImagePickerBottomSheet(attachmentId: attachmentId));
  }
}
