import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/model/id_verification/kyc_history_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NidVerificationDialogSection extends StatelessWidget {
  final KycHistoryData kycHistoryData;

  const NidVerificationDialogSection({super.key, required this.kycHistoryData});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Dialog(
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.all(18),
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
                    "id_verification.kyc_history.kyc_dialog.title".trns(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => Get.back(),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          themeController.isDarkMode.value
                              ? AppColors.white.withValues(alpha: 0.05)
                              : AppColors.black.withValues(alpha: 0.05),
                      child: Image.asset(
                        PngAssets.commonCancelIcon,
                        width: 14,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                kycHistoryData.type ?? "N/A",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    "id_verification.kyc_history.kyc_dialog.status_label"
                        .trns(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          kycHistoryData.status == "pending"
                              ? themeController.isDarkMode.value
                                  ? AppColors.warning.withValues(alpha: 0.4)
                                  : AppColors.warning.withValues(alpha: 0.1)
                              : kycHistoryData.status == "approved"
                              ? themeController.isDarkMode.value
                                  ? AppColors.success.withValues(alpha: 0.4)
                                  : AppColors.success.withValues(alpha: 0.1)
                              : kycHistoryData.status == "rejected"
                              ? themeController.isDarkMode.value
                                  ? AppColors.error.withValues(alpha: 0.4)
                                  : AppColors.error.withValues(alpha: 0.1)
                              : null,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      kycHistoryData.status == "pending"
                          ? "id_verification.kyc_history.kyc_dialog.status.pending"
                              .trns()
                          : kycHistoryData.status == "approved"
                          ? "id_verification.kyc_history.kyc_dialog.status.approved"
                              .trns()
                          : kycHistoryData.status == "rejected"
                          ? "id_verification.kyc_history.kyc_dialog.status.rejected"
                              .trns()
                          : "N/A",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.white
                                : AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),

              if (kycHistoryData.message != null &&
                  kycHistoryData.message!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "id_verification.kyc_history.kyc_dialog.admin_message_label"
                          .trns(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    CommonTextInputField(
                      textFontWeight: FontWeight.w600,
                      textColor:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextTertiary
                              : AppColors.textTertiary,
                      textFontSize: 10,
                      controller: TextEditingController(
                        text: kycHistoryData.message ?? "N/A",
                      ),
                      hintText: "",
                      maxLines: 4,
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      height: null,
                    ),
                  ],
                ),
              SizedBox(height: 20),
              ...kycHistoryData.data!.entries.toList().asMap().entries.map((
                entry,
              ) {
                final index = entry.key;
                final dataEntry = entry.value;
                final key = dataEntry.key;
                final value = dataEntry.value;
                final isLastItem =
                    index == kycHistoryData.data!.entries.length - 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$key:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (value != null && value.toString().startsWith("http"))
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          value,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: CommonLoading());
                          },
                        ),
                      )
                    else
                      Text(
                        value?.toString() ?? "N/A",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.darkTextTertiary
                                  : AppColors.textTertiary,
                        ),
                      ),
                    if (!isLastItem) const SizedBox(height: 20),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
