import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/id_verification/kyc_history_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/model/id_verification/kyc_history_model.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/id_verification/sub_sections/nid_verification_dialog_section.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class KycHistory extends StatelessWidget {
  const KycHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final KycHistoryController kycHistoryController = Get.put(
      KycHistoryController(),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 16),
            CommonAppBar(
              title: "id_verification.kyc_history.title".trns(),
              isPopEnabled: false,
              showRightSideIcon: false,
            ),
            Expanded(
              child: RefreshIndicator(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkPrimary
                        : AppColors.primary,
                onRefresh: () => kycHistoryController.fetchKycHistory(),
                child: Obx(() {
                  if (kycHistoryController.isLoading.value) {
                    return const CommonLoading();
                  }
                  if (kycHistoryController.kycHistoryList.isEmpty) {
                    return CommonNoDataFound(
                      message: "id_verification.kyc_history.no_data".trns(),
                      showTryAgainButton: true,
                      onTryAgain: () => kycHistoryController.fetchKycHistory(),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 30,
                      bottom: 20,
                    ),
                    itemBuilder: (context, index) {
                      final kyc = kycHistoryController.kycHistoryList[index];

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.darkSecondary
                                  : AppColors.white,
                          border: Border.all(
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkCardBorder
                                    : Color(0xFFE0E0E0).withValues(alpha: 0.5),
                          ),
                        ),
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            kyc.type ?? "N/A",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors
                                                          .darkTextPrimary
                                                      : AppColors.textPrimary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                kyc.status == "pending"
                                                    ? themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors.warning
                                                            .withValues(
                                                              alpha: 0.4,
                                                            )
                                                        : AppColors.warning
                                                            .withValues(
                                                              alpha: 0.1,
                                                            )
                                                    : kyc.status == "approved"
                                                    ? themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors.success
                                                            .withValues(
                                                              alpha: 0.4,
                                                            )
                                                        : AppColors.success
                                                            .withValues(
                                                              alpha: 0.1,
                                                            )
                                                    : kyc.status == "rejected"
                                                    ? themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors.error
                                                            .withValues(
                                                              alpha: 0.4,
                                                            )
                                                        : AppColors.error
                                                            .withValues(
                                                              alpha: 0.1,
                                                            )
                                                    : null,
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
                                          ),
                                          child: Text(
                                            kyc.status == "pending"
                                                ? "id_verification.kyc_history.status.pending"
                                                    .trns()
                                                : kyc.status == "approved"
                                                ? "id_verification.kyc_history.status.approved"
                                                    .trns()
                                                : kyc.status == "rejected"
                                                ? "id_verification.kyc_history.status.rejected"
                                                    .trns()
                                                : "N/A",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.white
                                                      : AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${"id_verification.kyc_history.submission_date".trns()} ${DateFormat("dd MMMM yyyy hh:mm a").format(DateTime.parse(kyc.createdAt!))}",
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
                              ),
                              const SizedBox(width: 8),
                              CommonElevatedButton(
                                width: 50,
                                height: 30,
                                buttonName:
                                    "id_verification.kyc_history.view_button"
                                        .trns(),
                                onPressed: () => showNidVerificationDialog(kyc),
                                borderRadius: 8,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemCount: kycHistoryController.kycHistoryList.length,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showNidVerificationDialog(KycHistoryData kycHistoryData) {
    Get.dialog(NidVerificationDialogSection(kycHistoryData: kycHistoryData));
  }
}
