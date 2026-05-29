import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/controller/virtual_card_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/view/add_card_balance/add_card_balance.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/view/card_transactions/card_transactions.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CardDetails extends StatefulWidget {
  final VirtualCardController virtualCardController;
  final String cardId;
  final String cardTransactionId;
  final String imagePath;

  const CardDetails({
    super.key,
    required this.virtualCardController,
    required this.cardId,
    required this.imagePath,
    required this.cardTransactionId,
  });

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    loadData();
    loadSettings();
  }

  Future<void> loadData() async {
    widget.virtualCardController.isCardLoading.value = true;
    await widget.virtualCardController.fetchVirtualCardDetails(
      cardId: widget.cardId,
    );
    await widget.virtualCardController.loadCurrencySymbol();
    widget.virtualCardController.isCardLoading.value = false;
  }

  Future<void> loadSettings() async {
    final cardTopupValue = await SettingsService.getSettingValue('card_topup');
    widget.virtualCardController.cardTopUp.value = cardTopupValue ?? "";
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
            SizedBox(height: 16),
            CommonAppBar(
              title: "virtualCard.card_details.title".trns(),
              isPopEnabled: false,
              showRightSideIcon: true,
              rightSideIcon: PngAssets.commonClockIcon,
              pushPage: CardTransactions(cardId: widget.cardTransactionId),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Obx(() {
                  if (widget.virtualCardController.isCardLoading.value) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const CommonLoading(),
                    );
                  }

                  final cardData =
                      widget
                          .virtualCardController
                          .virtualCardDetailsModel
                          .value
                          .data;

                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 30),
                        child: Stack(
                          children: [
                            Image.asset(widget.imagePath),
                            Positioned.fill(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cardData?.cardHolder?.name ?? "N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 24,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      cardData!.cardNumber!.length >= 4
                                          ? "**** **** **** ${cardData.cardNumber!.substring(cardData.cardNumber!.length - 4)}"
                                          : "N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "virtualCard.card_details.card.expiry.label"
                                                  .trns(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: AppColors.white,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              "${cardData.expirationMonth}/${cardData.expirationYear}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "virtualCard.card_details.card.cvc.label"
                                                  .trns(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: AppColors.white,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              cardData.cvc ?? "N/A",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Container(
                          padding: EdgeInsets.all(16),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "virtualCard.card_details.info.type.label"
                                            .trns(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        cardData.type!.toUpperCase(),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "virtualCard.card_details.info.created.label"
                                            .trns(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        DateFormat("MMM dd, yyyy").format(
                                          DateTime.parse(cardData.createdAt!),
                                        ),
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
                                  CommonElevatedButton(
                                    width:
                                        cardData.status == "inactive"
                                            ? 84
                                            : cardData.status == "active"
                                            ? 100
                                            : 0,
                                    height: 28,
                                    buttonName:
                                        cardData.status == "inactive"
                                            ? "virtualCard.card_details.button.status.activate"
                                                .trns()
                                            : cardData.status == "active"
                                            ? "virtualCard.card_details.button.status.deactivate"
                                                .trns()
                                            : "N/A",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    onPressed: () {
                                      widget.virtualCardController
                                          .cardUpdateStatus(
                                            cardId: cardData.id.toString(),
                                          );
                                    },
                                    borderRadius: 8,
                                    backgroundColor: AppColors.success,
                                    leftIcon: Icon(
                                      cardData.status == "inactive"
                                          ? Icons.check_circle_outline
                                          : cardData.status == "active"
                                          ? Icons.lock_clock_outlined
                                          : null,
                                      color:
                                          themeController.isDarkMode.value
                                              ? AppColors.black
                                              : AppColors.white,
                                      size: 14,
                                    ),
                                    iconSpacing: 4,
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "virtualCard.card_details.info.currency.label"
                                            .trns(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        cardData.currency!.toUpperCase(),
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
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 3.5,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color:
                                            cardData.status == "active"
                                                ? AppColors.success
                                                : cardData.status == "inactive"
                                                ? AppColors.error
                                                : AppColors.transparent,
                                        width: 1,
                                      ),
                                      color:
                                          themeController.isDarkMode.value
                                              ? AppColors.transparent
                                              : AppColors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        cardData.status == "active"
                                            ? "virtualCard.card_details.button.status.activate"
                                                .trns()
                                            : cardData.status == "inactive"
                                            ? "virtualCard.card_details.button.status.deactivate"
                                                .trns()
                                            : "N/A",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color:
                                              cardData.status == "active"
                                                  ? AppColors.success
                                                  : cardData.status ==
                                                      "inactive"
                                                  ? AppColors.error
                                                  : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "virtualCard.card_details.info.billing.label"
                                            .trns(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        cardData.cardHolder!.address ?? "N/A",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "${cardData.cardHolder!.city}, ${cardData.cardHolder!.state} - ${cardData.cardHolder!.country} ${cardData.cardHolder!.postalCode}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextTertiary
                                                  : AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "virtualCard.card_details.info.spending.label"
                                            .trns(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "${widget.virtualCardController.currencySymbol.value}${cardData.amount ?? "0.00"}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                      Obx(
                        () => Visibility(
                          visible:
                              widget.virtualCardController.cardTopUp.value ==
                              "1",
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: CommonElevatedButton(
                              buttonName:
                                  "virtualCard.card_details.button.add_balance"
                                      .trns(),
                              onPressed:
                                  () =>
                                      Get.find<NavigationController>().pushPage(
                                        AddCardBalance(
                                          cardId: cardData.id.toString(),
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
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
