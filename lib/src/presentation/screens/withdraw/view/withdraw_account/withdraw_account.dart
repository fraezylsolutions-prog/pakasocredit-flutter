import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/controller/withdraw_account_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/model/account_list_model.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/view/add_new_withdraw_account/add_new_withdraw_account.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/view/edit_withdraw_account/edit_withdraw_account.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/view/withdraw_history/withdraw_history.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawAccount extends StatefulWidget {
  const WithdrawAccount({super.key});

  @override
  State<WithdrawAccount> createState() => _WithdrawAccountState();
}

class _WithdrawAccountState extends State<WithdrawAccount> {
  final ThemeController themeController = Get.find<ThemeController>();
  final WithdrawAccountController withdrawAccountController = Get.put(
    WithdrawAccountController(),
  );

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
            SizedBox(height: 16),
            CommonAppBar(
              title: "withdraw.withdrawAccount.title".trns(),
              isPopEnabled: false,
              showRightSideIcon: true,
              rightSideIcon: PngAssets.commonClockIcon,
              pushPage: WithdrawHistory(),
            ),
            SizedBox(height: 30),
            Expanded(
              child: RefreshIndicator(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkPrimary
                        : AppColors.primary,
                onRefresh: () => withdrawAccountController.fetchAccounts(),
                child: Obx(() {
                  if (withdrawAccountController.isLoading.value) {
                    return const CommonLoading();
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.only(left: 18, right: 18, top: 18),
                    decoration: BoxDecoration(
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkSecondary
                              : AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      gradient: AppStyles.linearGradient(),
                      boxShadow: AppStyles.boxShadow(),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap:
                              () => Get.find<NavigationController>().pushPage(
                                AddNewWithdrawAccount(),
                              ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkPrimary
                                        : Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset(
                                PngAssets.withdrawAddIcon,
                                width: 12,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child:
                              withdrawAccountController.accountList.isEmpty
                                  ? CommonNoDataFound(
                                    message:
                                        "withdraw.withdrawAccount.noAccountFound"
                                            .trns(),
                                    showTryAgainButton: true,
                                    onTryAgain:
                                        () =>
                                            withdrawAccountController
                                                .fetchAccounts(),
                                  )
                                  : ListView.separated(
                                    padding: EdgeInsets.only(bottom: 20),
                                    itemBuilder: (context, index) {
                                      final AccountListData account =
                                          withdrawAccountController
                                              .accountList[index];

                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 22,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkSecondary
                                                  : AppColors.white,
                                          border: Border.all(
                                            color:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkCardBorder
                                                    : Color(
                                                      0xFFE0E0E0,
                                                    ).withValues(alpha: 0.5),
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(7),
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.grey
                                                        .withValues(alpha: 0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.account_balance_sharp,
                                                    color:
                                                        themeController
                                                                .isDarkMode
                                                                .value
                                                            ? AppColors
                                                                .darkTextTertiary
                                                            : AppColors
                                                                .textTertiary,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      account.methodName ??
                                                          "N/A",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12,
                                                        color:
                                                            themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? AppColors
                                                                    .darkTextPrimary
                                                                : AppColors
                                                                    .textPrimary,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      "${account.currency} ${"withdraw.withdrawAccount.account".trns()}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11,
                                                        color:
                                                            themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? AppColors
                                                                    .darkPrimary
                                                                : AppColors
                                                                    .primary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.find<
                                                          NavigationController
                                                        >()
                                                        .pushPage(
                                                          EditWithdrawAccount(
                                                            accountData:
                                                                account,
                                                          ),
                                                        );
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      color:
                                                          themeController
                                                                  .isDarkMode
                                                                  .value
                                                              ? AppColors
                                                                  .darkPrimary
                                                                  .withValues(
                                                                    alpha: 0.10,
                                                                  )
                                                              : AppColors
                                                                  .primary
                                                                  .withValues(
                                                                    alpha: 0.10,
                                                                  ),
                                                    ),
                                                    child: Image.asset(
                                                      PngAssets.commonEditIcon,
                                                      width: 12,
                                                      height: 12,
                                                      fit: BoxFit.contain,
                                                      color:
                                                          themeController
                                                                  .isDarkMode
                                                                  .value
                                                              ? AppColors
                                                                  .darkPrimary
                                                              : AppColors
                                                                  .primary,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 6),
                                                GestureDetector(
                                                  onTap:
                                                      () => withdrawAccountController
                                                          .deleteAccount(
                                                            accountId:
                                                                account.id
                                                                    .toString(),
                                                          ),
                                                  child: Container(
                                                    padding: EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      color:
                                                          themeController
                                                                  .isDarkMode
                                                                  .value
                                                              ? AppColors.error
                                                                  .withValues(
                                                                    alpha: 0.20,
                                                                  )
                                                              : AppColors.error
                                                                  .withValues(
                                                                    alpha: 0.10,
                                                                  ),
                                                    ),
                                                    child: Image.asset(
                                                      PngAssets
                                                          .commonDeleteIcon,
                                                      width: 12,
                                                      height: 12,
                                                      fit: BoxFit.contain,
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
                                    itemCount:
                                        withdrawAccountController
                                            .accountList
                                            .length,
                                  ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
