import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/all_transaction/view/all_transaction.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/model/dashboard_model.dart';
import 'package:pakaso_credit/src/presentation/screens/home/view/sub_sections/transaction_dialog.dart';
import 'package:pakaso_credit/src/presentation/widgets/transaction_dynamic_icon/transaction_dynamic_icon.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecentTransactionSection extends StatelessWidget {
  const RecentTransactionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      // Safety Check: Don't crash if data or transactions list is null
      final data = homeController.dashboardModel.value.data;
      if (data == null) return const SizedBox();

      final transactions = data.transactions ?? [];

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        child: Column(
          children: [
            _buildTransferList(themeController),
            const SizedBox(height: 10),
            transactions.isEmpty
                ? Center(
                    child: CommonNoDataFound(
                      message: "home.recentTransactions.no_data".trns(),
                    ),
                  )
                : ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => showTransactionDialog(transaction),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: themeController.isDarkMode.value
                                ? AppColors.darkSecondary
                                : AppColors.white,
                            border: Border.all(
                              color: themeController.isDarkMode.value
                                  ? AppColors.darkCardBorder
                                  : const Color(0xFFE0E0E0).withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 33,
                                      height: 33,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (themeController.isDarkMode.value
                                                ? AppColors.darkPrimary
                                                : AppColors.primary)
                                            .withOpacity(0.10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.5),
                                        child: Image.asset(
                                          TransactionDynamicIcon.getTransactionIcon(
                                            transaction.type,
                                          ),
                                          color: themeController.isDarkMode.value
                                              ? AppColors.darkPrimary
                                              : AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                transaction.type ?? "Transaction",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: themeController.isDarkMode.value
                                                      ? AppColors.darkTextPrimary
                                                      : AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              _buildStatusBadge(transaction.status),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            transaction.tnx ?? "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: themeController.isDarkMode.value
                                                  ? AppColors.darkTextTertiary
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "${transaction.isPlus == true ? "+" : "-"}${transaction.amount ?? "0.00"}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: transaction.isPlus == true
                                      ? AppColors.success
                                      : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                  ),
          ],
        ),
      );
    });
  }

  Widget _buildStatusBadge(String? status) {
    Color color = AppColors.error;
    if (status == "Success") color = AppColors.success;
    if (status == "Pending") color = AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: color.withOpacity(0.1),
      ),
      child: Text(
        status ?? "Unknown",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: color),
      ),
    );
  }

  void showTransactionDialog(Transactions transaction) {
    Get.dialog(TransactionDialog(controller: transaction));
  }

  Widget _buildTransferList(ThemeController themeController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "home.recentTransactions.title".trns(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: themeController.isDarkMode.value
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
          ),
        ),
        InkWell(
          onTap: () => Get.find<NavigationController>().pushPage(const AllTransaction()),
          child: Text(
            "home.recentTransactions.see_all".trns(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: themeController.isDarkMode.value
                  ? AppColors.darkPrimary
                  : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
