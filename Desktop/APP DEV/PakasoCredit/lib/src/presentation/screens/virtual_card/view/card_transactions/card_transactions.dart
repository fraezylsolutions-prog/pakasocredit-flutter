import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/controller/card_transactions_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/model/card_transactions_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardTransactions extends StatefulWidget {
  final String cardId;

  const CardTransactions({super.key, required this.cardId});

  @override
  State<CardTransactions> createState() => _CardTransactionsState();
}

class _CardTransactionsState extends State<CardTransactions> {
  final ThemeController themeController = Get.find<ThemeController>();
  final CardTransactionsController cardTransactionsController = Get.put(
    CardTransactionsController(),
  );

  @override
  void initState() {
    super.initState();
    cardTransactionsController.fetchCardTransactions(cardId: widget.cardId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkBackground
              : AppColors.background,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, __) {
          Get.find<NavigationController>().popPage();
        },
        child: Column(
          children: [_buildHeaderSection(), _buildTransactionList()],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          CommonAppBar(
            padding: 0,
            title: "virtualCard.card_transactions.title".trns(),
            isPopEnabled: false,
            showRightSideIcon: false,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: CommonElevatedButton(
              backgroundColor:
                  themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.primary,
              borderRadius: 30,
              height: 34,
              width: 105,
              buttonName: "virtualCard.card_transactions.header.sync".trns(),
              onPressed: () {
                cardTransactionsController.fetchCardTransactionsBySync(
                  cardId: widget.cardId,
                  isSync: "true",
                );
              },
              leftIcon: Icon(
                Icons.sync_rounded,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.black
                        : AppColors.white,
                size: 15,
              ),
              iconSpacing: 2,
              fontSize: 12,
              textColor:
                  themeController.isDarkMode.value
                      ? AppColors.black
                      : AppColors.white,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh:
            () => cardTransactionsController.fetchCardTransactions(
              cardId: widget.cardId,
            ),
        color:
            themeController.isDarkMode.value
                ? AppColors.darkPrimary
                : AppColors.primary,
        displacement: 40,
        child: Obx(() {
          if (cardTransactionsController.isLoading.value) {
            return const Center(child: CommonLoading());
          }

          if (cardTransactionsController.cardTransactionsList.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: CommonNoDataFound(
                  showTryAgainButton: true,
                  message:
                      "virtualCard.card_transactions.no_data.message".trns(),
                  onTryAgain: () {
                    cardTransactionsController.fetchCardTransactions(
                      cardId: widget.cardId,
                    );
                  },
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: cardTransactionsController.cardTransactionsList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final transaction =
                  cardTransactionsController.cardTransactionsList[index];
              return _buildTransactionCard(transaction);
            },
          );
        }),
      ),
    );
  }

  Widget _buildTransactionCard(CardTransactionsData transaction) {
    final isSuccess = transaction.status == "Success";
    final isPending = transaction.status == "Pending";

    final statusColor =
        isSuccess
            ? AppColors.success
            : isPending
            ? AppColors.warning
            : AppColors.error;

    final icon =
        isSuccess
            ? Icons.check_circle_rounded
            : isPending
            ? Icons.pending_rounded
            : Icons.error_rounded;

    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 0.1,
      color:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: statusColor.withValues(alpha: 0.1),
              ),
              child: Icon(icon, color: statusColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.merchantData?.name ?? "Unknown Merchant",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${transaction.amount ?? "0.00"} ${transaction.currency}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color:
                              isSuccess ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: statusColor.withValues(alpha: 0.1),
                        ),
                        child: Text(
                          transaction.status ?? "N/A",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: statusColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          transaction.created ?? "N/A",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextTertiary
                                    : AppColors.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
