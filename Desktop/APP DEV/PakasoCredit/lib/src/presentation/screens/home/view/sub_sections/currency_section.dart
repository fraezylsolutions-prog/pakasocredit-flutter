import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/model/dashboard_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrencyCardSection extends StatelessWidget {
  const CurrencyCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Obx(() {
          final data = homeController.dashboardModel.value.data;
          if (data == null) return const SizedBox();

          final List<Widget> cardList = [];

          // DPS Card
          if (homeController.userDps.value != "0" && data.dpsData != null) {
            cardList.add(
              _buildCurrencyCard(
                context,
                icon1: PngAssets.commonBriefcaseIcon2,
                icon2: PngAssets.commonFiIcon,
                title: "home.summery.dpsTitle".trns(),
                amount: !homeController.isVisibleBalance.value
                    ? "*****"
                    : (data.dpsData!.totalRunningDpsAmount ?? "0.00"),
                cardColor: AppColors.white,
                onPressed: () => Get.find<NavigationController>().pushNamed(BaseRoute.dpsPlan),
                summary: data.dpsData!.runningDpsSummary ?? [],
                summaryName: "home.summery.summaryTitleDps".trns(),
              ),
            );
          }

          // FDR Card
          if (homeController.userFdr.value != "0" && data.fdrData != null) {
            if (cardList.isNotEmpty) cardList.add(const SizedBox(width: 10));
            cardList.add(
              _buildCurrencyCard(
                context,
                icon1: PngAssets.commonGoldIngotsIcon,
                icon2: PngAssets.commonFiIcon,
                title: "home.summery.fdrTitle".trns(),
                amount: !homeController.isVisibleBalance.value
                    ? "*****"
                    : (data.fdrData!.totalRunningFdrAmount ?? "0.00"),
                cardColor: AppColors.white,
                onPressed: () => Get.find<NavigationController>().pushNamed(BaseRoute.fdrPlan),
                summary: data.fdrData!.runningFdrSummary ?? [],
                summaryName: "home.summery.summaryTitleFdr".trns(),
              ),
            );
          }

          // Loan Card
          if (homeController.userLoan.value != "0" && data.loanData != null) {
            if (cardList.isNotEmpty) cardList.add(const SizedBox(width: 10));
            cardList.add(
              _buildCurrencyCard(
                context,
                icon1: PngAssets.commonInvoiceIcon2,
                icon2: PngAssets.commonFiIcon,
                title: "home.summery.loanTitle".trns(),
                amount: !homeController.isVisibleBalance.value
                    ? "*****"
                    : (data.loanData!.totalRunningLoanAmount ?? "0.00"),
                cardColor: AppColors.white,
                onPressed: () => Get.find<NavigationController>().pushNamed(BaseRoute.loanPlan),
                summary: data.loanData!.runningLoanSummary ?? [],
                summaryName: "home.summery.summaryTitleLoan".trns(),
              ),
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: cardList,
          );
        }),
      ),
    );
  }

  Widget _buildCurrencyCard(
    context, {
    required String icon1,
    required String icon2,
    required String title,
    required String amount,
    required Color cardColor,
    required GestureTapCallback onPressed,
    required List<Summary> summary,
    required String summaryName,
  }) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeController.isDarkMode.value ? AppColors.darkSecondary : cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: themeController.isDarkMode.value ? AppColors.darkCardBorder : const Color(0xFFE6E6E6),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    icon1,
                    width: 24,
                    fit: BoxFit.contain,
                    color: themeController.isDarkMode.value ? AppColors.darkTextTertiary : AppColors.textPrimary,
                  ),
                  GestureDetector(
                    onTap: () => showIdentificationDialog(context, summary, summaryName),
                    child: Image.asset(
                      themeController.isDarkMode.value ? PngAssets.commonDarkFiIcon : icon2,
                      width: 18,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  void showIdentificationDialog(context, List<Summary> summary, String summaryName) {
    final ThemeController themeController = Get.find<ThemeController>();

    Get.dialog(
      Dialog(
        backgroundColor: themeController.isDarkMode.value ? AppColors.darkSecondary : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(summaryName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back()),
                ],
              ),
              const Divider(),
              if (summary.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text("No data found"),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: summary.length,
                    itemBuilder: (context, index) {
                      final item = summary[index];
                      return ListTile(
                        title: Text(item.name ?? ""),
                        subtitle: Text("End Date: ${item.endDate ?? ""}"),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
