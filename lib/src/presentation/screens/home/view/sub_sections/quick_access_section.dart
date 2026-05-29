import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    final List<Map<String, dynamic>> quickActions = [
      if (homeController.userDeposit.value != "0")
        {
          "title": "home.quickAccess.depositTitle".trns(),
          "icon": PngAssets.commonBriefcaseIcon3,
          "bgImage": PngAssets.quickActionFrame1,
          "navigation":
              () =>
                  Get.find<NavigationController>().pushNamed(BaseRoute.deposit),
        },
      if (homeController.multipleCurrency.value != "0")
        {
          "title": "home.quickAccess.walletTitle".trns(),
          "icon": PngAssets.commonWalletIcon3,
          "bgImage": PngAssets.quickActionFrame2,
          "navigation": () {
            final navigationController = Get.find<NavigationController>();
            navigationController.selectedIndex.value = 2;
            navigationController.pushNamed(BaseRoute.wallet);
          },
        },
      if (homeController.virtualCard.value != "0")
        {
          "title": "home.quickAccess.virtualCardTitle".trns(),
          "icon": PngAssets.commonCreditCardRawIcon,
          "bgImage": PngAssets.quickActionFrame3,
          "navigation": () {
            final navigationController = Get.find<NavigationController>();
            navigationController.selectedIndex.value = 1;
            navigationController.pushNamed(BaseRoute.virtualCard);
          },
        },
      if (homeController.transferStatus.value != "0")
        {
          "title": "home.quickAccess.transferTitle".trns(),
          "icon": PngAssets.commonCircleDataTransferIcon,
          "bgImage": PngAssets.quickActionFrame4,
          "navigation":
              () => Get.find<NavigationController>().pushNamed(
                BaseRoute.fundTransfer,
              ),
        },
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quickActions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 6,
        childAspectRatio: 2.6,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: quickActions[index]["navigation"] as void Function(),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(quickActions[index]["bgImage"]!),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          quickActions[index]["icon"]!,
                          width: 18,
                          fit: BoxFit.contain,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            quickActions[index]["title"]!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    PngAssets.commonRightArrowIcon,
                    width: 18,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
