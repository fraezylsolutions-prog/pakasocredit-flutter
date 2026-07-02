import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/id_verification/id_verification_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/id_verification/sub_sections/kyc_dynamic_form.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/id_verification/sub_sections/kyc_history.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IdVerification extends StatefulWidget {
  const IdVerification({super.key});

  @override
  State<IdVerification> createState() => _IdVerificationState();
}

class _IdVerificationState extends State<IdVerification> {
  final ThemeController themeController = Get.find<ThemeController>();
  final IdVerificationController idVerificationController = Get.put(
    IdVerificationController(),
  );

  Future<void> refreshData() async {
    await idVerificationController.fetchUser();
    await idVerificationController.fetchKyc();
  }

  @override
  Widget build(BuildContext context) {
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
              title: "id_verification.title".trns(),
              isPopEnabled: false,
              showRightSideIcon: true,
              rightSideIcon: PngAssets.commonClockIcon,
              pushPage: const KycHistory(),
            ),
            Expanded(
              child: Obx(() {
                if (idVerificationController.isLoading.value) {
                  return const CommonLoading();
                }

                return RefreshIndicator(
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                  onRefresh: () => refreshData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              _buildVerificationSection(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 18,
                            top: 16,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkSecondary
                                    : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "id_verification.verification_center".trns(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Divider(
                                color:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkCardBorder
                                        : AppColors.black.withValues(
                                          alpha: 0.10,
                                        ),
                                height: 0,
                              ),
                              const SizedBox(height: 24),
                              if (idVerificationController.kycList.isEmpty)
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Text(
                                      "id_verification.no_documents".trns(),
                                      style: TextStyle(
                                        color:
                                            themeController.isDarkMode.value
                                                ? AppColors.darkTextPrimary
                                                : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              if (idVerificationController.kycList.isNotEmpty)
                                ...idVerificationController.kycList.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: CommonElevatedButton(
                                      backgroundColor: const Color(0xFF81EF71),
                                      textColor: AppColors.black,
                                      borderRadius: 8,
                                      buttonName: item.name!,
                                      onPressed: () {
                                        Get.find<NavigationController>()
                                            .pushPage(
                                              KycDynamicForm(kycData: item),
                                            );
                                      },
                                      leftIcon: Image.asset(
                                        PngAssets.commonCreditCardAddIcon,
                                        width: 20,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  );
                                }),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color:
            idVerificationController.userModel.value.kyc == 0
                ? AppColors.error.withValues(alpha: 0.08)
                : idVerificationController.userModel.value.kyc == 1
                ? AppColors.success.withValues(alpha: 0.08)
                : idVerificationController.userModel.value.kyc == 2
                ? AppColors.warning.withValues(alpha: 0.08)
                : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  idVerificationController.userModel.value.kyc == 0
                      ? AppColors.error
                      : idVerificationController.userModel.value.kyc == 1
                      ? AppColors.success
                      : idVerificationController.userModel.value.kyc == 2
                      ? AppColors.warning
                      : null,
            ),
            child: Icon(
              idVerificationController.userModel.value.kyc == 0
                  ? Icons.error_outline_outlined
                  : idVerificationController.userModel.value.kyc == 1
                  ? Icons.check_circle_outline_outlined
                  : idVerificationController.userModel.value.kyc == 2
                  ? Icons.warning_amber_outlined
                  : null,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            "id_verification.verification_center".trns(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 70),
            child: Text(
              textAlign: TextAlign.center,
              idVerificationController.userModel.value.kyc == 0
                  ? "id_verification.status.not_submitted".trns()
                  : idVerificationController.userModel.value.kyc == 1
                  ? "id_verification.status.verified".trns()
                  : idVerificationController.userModel.value.kyc == 2
                  ? "id_verification.status.pending".trns()
                  : "N/A",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 11,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextTertiary
                        : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
