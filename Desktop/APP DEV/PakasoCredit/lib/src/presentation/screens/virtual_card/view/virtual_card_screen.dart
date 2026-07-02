import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/controller/virtual_card_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/model/virtual_cards_model.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/view/card_details/card_details.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/view/create_new_card/create_new_card.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualCardScreen extends StatefulWidget {
  const VirtualCardScreen({super.key});

  @override
  State<VirtualCardScreen> createState() => _VirtualCardScreenState();
}

class _VirtualCardScreenState extends State<VirtualCardScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final VirtualCardController virtualCardController = Get.put(
    VirtualCardController(),
  );

  final List<String> cardImages = [
    PngAssets.virtualCard1,
    PngAssets.virtualCard2,
    PngAssets.virtualCard3,
    PngAssets.virtualCard4,
    PngAssets.virtualCard5,
    PngAssets.virtualCard6,
    PngAssets.virtualCard7,
    PngAssets.virtualCard8,
    PngAssets.virtualCard9,
    PngAssets.virtualCard10,
    PngAssets.virtualCard11,
    PngAssets.virtualCard12,
    PngAssets.virtualCard13,
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        final navigationController = Get.find<NavigationController>();
        navigationController.selectedIndex.value = 0;
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 16),
            CommonAppBar(
              title: "virtualCard.title".trns(),
              isPopEnabled: false,
              showRightSideIcon: false,
              selectedIndex: 0,
            ),
            SizedBox(height: 30),
            Expanded(
              child: RefreshIndicator(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkPrimary
                        : AppColors.primary,
                onRefresh: () => virtualCardController.fetchVirtualCards(),
                child: Obx(() {
                  if (virtualCardController.isLoading.value) {
                    return const CommonLoading();
                  }

                  if (virtualCardController.virtualCardList.isEmpty) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: CommonNoDataFound(
                          message: "virtualCard.no_data.message".trns(),
                          showTryAgainButton: true,
                          onTryAgain:
                              () => virtualCardController.fetchVirtualCards(),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 0,
                      bottom: 16,
                    ),
                    itemBuilder: (context, index) {
                      final VirtualCardsData card =
                          virtualCardController.virtualCardList[index];
                      final imageForThisCard =
                          cardImages[index % cardImages.length];

                      return GestureDetector(
                        onTap: () {
                          Get.find<NavigationController>().pushPage(
                            CardDetails(
                              virtualCardController: virtualCardController,
                              cardId: card.id.toString(),
                              imagePath: imageForThisCard,
                              cardTransactionId: card.cardId.toString(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkCardBorder
                                      : Color(
                                        0xFF000000,
                                      ).withValues(alpha: 0.10),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Image.asset(imageForThisCard),
                                    Positioned.fill(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  card.cardHolder?.name ??
                                                      "N/A",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  card.cardNumber != null &&
                                                          card
                                                                  .cardNumber!
                                                                  .length >=
                                                              4
                                                      ? "**** **** **** ${card.cardNumber!.substring(card.cardNumber!.length - 4)}"
                                                      : "N/A",

                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 8,
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "virtualCard.card.expiry.label"
                                                              .trns(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 8,
                                                            color:
                                                                AppColors.white,
                                                          ),
                                                        ),
                                                        SizedBox(width: 12),
                                                        Text(
                                                          "${card.expirationMonth}/${card.expirationYear}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 8,
                                                            color:
                                                                AppColors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(width: 12),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "virtualCard.card.cvc.label"
                                                              .trns(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 8,
                                                            color:
                                                                AppColors.white,
                                                          ),
                                                        ),
                                                        SizedBox(width: 12),
                                                        Text(
                                                          card.cvc ?? "N/A",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 8,
                                                            color:
                                                                AppColors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                                color: AppColors.white,
                                              ),
                                              child: Text(
                                                card.status == "active"
                                                    ? "Active"
                                                    : card.status == "inactive"
                                                    ? "Inactive"
                                                    : "N/A",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 7,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      card.cardHolder?.name ?? "N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color:
                                            themeController.isDarkMode.value
                                                ? AppColors.darkTextPrimary
                                                : AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      card.cardNumber != null &&
                                              card.cardNumber!.length >= 4
                                          ? "**** **** **** ${card.cardNumber!.substring(card.cardNumber!.length - 4)}"
                                          : "N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color:
                                            themeController.isDarkMode.value
                                                ? AppColors.darkTextTertiary
                                                : AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16);
                    },
                    itemCount: virtualCardController.virtualCardList.length,
                  );
                }),
              ),
            ),
          ],
        ),
        floatingActionButton: Obx(() {
          return virtualCardController.cardCreation.value == "1"
              ? SizedBox(
                width: 100,
                height: 40,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor:
                      themeController.isDarkMode.value
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                  onPressed:
                      () => Get.find<NavigationController>().pushPage(
                        CreateNewCard(),
                      ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.black
                                : AppColors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Create',
                        style: TextStyle(
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.black
                                  : AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : const SizedBox.shrink();
        }),
      ),
    );
  }
}
