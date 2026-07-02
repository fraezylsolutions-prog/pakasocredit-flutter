import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/banks_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/beneficiary_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/fund_transfer_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/transfer_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/model/beneficiary_details_model.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/beneficiary_list/sub_sections/beneficiary_details_dialog_section.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/beneficiary_list/sub_sections/delete_beneficiary_dialog_section.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/beneficiary_list/sub_sections/edit_beneficiary_dialog_section.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeneficiaryList extends StatelessWidget {
  const BeneficiaryList({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final BeneficiaryController beneficiaryController = Get.put(
      BeneficiaryController(),
    );
    final BanksController banksController = Get.put(BanksController());

    return Expanded(
      child: Stack(
        children: [
          RefreshIndicator(
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkPrimary
                    : AppColors.primary,
            onRefresh: () => beneficiaryController.fetchBeneficiary(),
            child: Obx(() {
              if (beneficiaryController.isLoading.value) {
                return const CommonLoading();
              }

              if (beneficiaryController.beneficiaryList.isEmpty) {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(Get.context!).size.height * 0.8,
                    child: CommonNoDataFound(
                      message:
                          "fundTransfer.beneficiaryList.noData.message".trns(),
                      showTryAgainButton: true,
                      onTryAgain:
                          () => beneficiaryController.fetchBeneficiary(),
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 18),
                itemBuilder: (context, index) {
                  final beneficiary =
                      beneficiaryController.beneficiaryList[index];

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkSecondary
                              : AppColors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              beneficiary.accountName ?? "N/A",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${"fundTransfer.beneficiaryList.labels.branch".trns()} ${beneficiary.branchName ?? "N/A"}",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                color:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkTextTertiary
                                        : AppColors.textTertiary,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${"fundTransfer.beneficiaryList.labels.acName".trns()} ${beneficiary.accountNumber ?? "N/A"}",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                color:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkPrimary
                                        : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Transform.translate(
                              offset: Offset(10, 0),
                              child: PopupMenuButton(
                                color:
                                    themeController.isDarkMode.value
                                        ? Color(0xFF1C2E24)
                                        : AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                icon: Image.asset(
                                  PngAssets.commonThreeDotCircle,
                                  width: 22,
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                ),
                                itemBuilder:
                                    (context) => <PopupMenuEntry<String>>[
                                      PopupMenuItem(
                                        height: 30,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 10,
                                        ),
                                        onTap: () async {
                                          beneficiaryController
                                              .isBeneficiaryDetailsLoading
                                              .value = true;

                                          try {
                                            await beneficiaryController
                                                .fetchBeneficiaryDetails(
                                                  beneficiaryId:
                                                      beneficiary.id.toString(),
                                                );
                                            if (beneficiaryController
                                                    .beneficiaryDetailsModel
                                                    .value
                                                    .data !=
                                                null) {
                                              showBeneficiaryDetailsDialog(
                                                beneficiaryController
                                                    .beneficiaryDetailsModel
                                                    .value,
                                              );
                                            }
                                          } finally {
                                            beneficiaryController
                                                .isBeneficiaryDetailsLoading
                                                .value = false;
                                          }
                                        },
                                        child: Text(
                                          'fundTransfer.beneficiaryList.actions.details'
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
                                      ),
                                      PopupMenuItem(
                                        height: 30,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 10,
                                        ),
                                        onTap: () async {
                                          beneficiaryController
                                              .isBeneficiaryEditLoading
                                              .value = true;

                                          try {
                                            await banksController.fetchBanks();
                                            final matchedBank = banksController
                                                .banksList
                                                .firstWhere(
                                                  (item) =>
                                                      item.id ==
                                                      beneficiary.bankId,
                                                );

                                            beneficiaryController
                                                    .editBankController
                                                    .text =
                                                matchedBank.name ?? "N/A";
                                            beneficiaryController
                                                    .editBank
                                                    .value =
                                                matchedBank.name ?? "N/A";
                                            beneficiaryController
                                                    .editBankId
                                                    .value =
                                                matchedBank.id.toString();
                                            beneficiaryController
                                                    .editAccountNumberController
                                                    .text =
                                                beneficiary.accountNumber ??
                                                "N/A";
                                            beneficiaryController
                                                    .editNameOnAccountController
                                                    .text =
                                                beneficiary.accountName ??
                                                "N/A";
                                            beneficiaryController
                                                    .editBranchNameController
                                                    .text =
                                                beneficiary.branchName ?? "N/A";
                                            beneficiaryController
                                                    .editNickNameController
                                                    .text =
                                                beneficiary.nickName ?? "N/A";

                                            if (banksController
                                                .banksList
                                                .isNotEmpty) {
                                              showEditBeneficiaryDialog(
                                                beneficiary.id,
                                              );
                                            }
                                          } finally {
                                            beneficiaryController
                                                .isBeneficiaryEditLoading
                                                .value = false;
                                          }
                                        },
                                        child: Text(
                                          'fundTransfer.beneficiaryList.actions.edit'
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
                                      ),
                                      PopupMenuItem(
                                        height: 30,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 10,
                                        ),
                                        onTap:
                                            () => showDeleteBeneficiaryDialog(
                                              beneficiaryId:
                                                  beneficiary.id.toString(),
                                            ),
                                        child: Text(
                                          'fundTransfer.beneficiaryList.actions.delete'
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
                                      ),
                                    ],
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Get.find<TransferController>()
                                    .isSendMoney
                                    .value = true;
                                Get.find<TransferController>()
                                    .sendMoneyBankId
                                    .value = beneficiary.bankId.toString();
                                Get.find<TransferController>()
                                    .sendMoneyBeneficiaryId
                                    .value = beneficiary.id.toString();
                                Get.find<FundTransferController>()
                                    .selectedTab
                                    .value = 0;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkPrimary
                                          : AppColors.primary,
                                ),
                                child: Text(
                                  "fundTransfer.beneficiaryList.actions.sendMoney"
                                      .trns(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color:
                                        themeController.isDarkMode.value
                                            ? AppColors.black
                                            : AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 20);
                },
                itemCount: beneficiaryController.beneficiaryList.length,
              );
            }),
          ),
          Obx(
            () => Visibility(
              visible:
                  beneficiaryController.isBeneficiaryDetailsLoading.value ||
                  beneficiaryController.isBeneficiaryDeleteLoading.value ||
                  beneficiaryController.isBeneficiaryEditLoading.value,
              child: CommonLoading(),
            ),
          ),
        ],
      ),
    );
  }

  void showBeneficiaryDetailsDialog(
    BeneficiaryDetailsModel beneficiaryDetailsModel,
  ) {
    Get.dialog(
      BeneficiaryDetailsDialogSection(
        beneficiaryDetailsModel: beneficiaryDetailsModel,
      ),
    );
  }

  void showEditBeneficiaryDialog(beneficiaryId) {
    Get.dialog(
      EditBeneficiaryDialogSection(beneficiaryId: beneficiaryId.toString()),
    );
  }

  void showDeleteBeneficiaryDialog({required String beneficiaryId}) {
    Get.dialog(DeleteBeneficiaryDialogSection(beneficiaryId: beneficiaryId));
  }
}
