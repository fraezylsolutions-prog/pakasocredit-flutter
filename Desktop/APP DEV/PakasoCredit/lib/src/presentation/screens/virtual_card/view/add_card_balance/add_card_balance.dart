import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/controller/virtual_card_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddCardBalance extends StatefulWidget {
  final String cardId;

  const AddCardBalance({super.key, required this.cardId});

  @override
  State<AddCardBalance> createState() => _AddCardBalanceState();
}

class _AddCardBalanceState extends State<AddCardBalance> {
  final ThemeController themeController = Get.find<ThemeController>();
  final VirtualCardController virtualCardController = Get.find();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    virtualCardController.isTopUpLoading.value = true;
    await virtualCardController.fetchUser();
    await virtualCardController.loadCurrencySymbol();
    await virtualCardController.loadMinCardTopUp();
    await virtualCardController.loadMaxCardTopUp();
    await virtualCardController.loadSiteCurrency();
    virtualCardController.isTopUpLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 16),
                CommonAppBar(
                  title: "virtualCard.card_topup.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: false,
                ),
                SizedBox(height: 30),
                Obx(() {
                  if (virtualCardController.isTopUpLoading.value) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const CommonLoading(),
                    );
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(18),
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
                          "virtualCard.card_topup.balance.title".trns(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 20),
                        Obx(
                          () => Text(
                            "${"virtualCard.card_topup.balance.default_account.label".trns()} ${virtualCardController.currencySymbol.value}${virtualCardController.userModel.value.balance}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        CommonTextInputField(
                          controller: virtualCardController.amountController,
                          hintText:
                              "virtualCard.card_topup.amount.label".trns(),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 4),
                        Obx(
                          () => Text(
                            "virtualCard.card_topup.amount.limit.message".trnsFormat({
                              "min_range":
                                  "${virtualCardController.minCardTopUp.value} ${virtualCardController.siteCurrency.value}",
                              "max_range":
                                  "${virtualCardController.maxCardTopUp.value} ${virtualCardController.siteCurrency.value}",
                            }),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 8,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Spacer(),

                Obx(
                  () =>
                      !virtualCardController.isTopUpLoading.value
                          ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: CommonElevatedButton(
                              buttonName:
                                  "virtualCard.card_topup.button.topup".trns(),
                              onPressed: () {
                                if (virtualCardController
                                    .amountController
                                    .text
                                    .isNotEmpty) {
                                  virtualCardController.cardBalanceTopUp(
                                    cardId: widget.cardId,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        "virtualCard.card_topup.amount.error.empty"
                                            .trns(),
                                    backgroundColor: AppColors.error,
                                  );
                                }
                              },
                            ),
                          )
                          : SizedBox(),
                ),

                SizedBox(height: 30),
              ],
            ),
            Obx(
              () => Visibility(
                visible: virtualCardController.isCardTopUpLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
