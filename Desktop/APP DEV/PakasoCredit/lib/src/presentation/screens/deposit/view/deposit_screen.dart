import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/controller/deposit_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/view/deposit_history/deposit_history.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/view/sub_sections/deposit_amount_input_section.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/view/sub_sections/deposit_manual_dynamic_fields.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/view/sub_sections/deposit_review_details_section.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/view/sub_sections/deposit_wallet_and_gateway_section.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/model/wallets_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepositScreen extends StatefulWidget {
  final WalletsData? selectedWallet;
  final bool? preSelectWallet;

  const DepositScreen({super.key, this.selectedWallet, this.preSelectWallet});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final DepositController depositController = Get.put(DepositController());
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    depositController.isLoading.value = true;
    depositController.clearFields();
    await depositController.fetchMultipleCurrencyBool();
    await depositController.loadSiteCurrency();
    await passcodeController.loadPasscodeStatus(
      passcodeType: "deposit_passcode_status",
    );
    if (depositController.isMultipleCurrency.value == "1") {
      await depositController.fetchWallets();
      if (widget.preSelectWallet != null && widget.selectedWallet != null) {
        depositController.setSelectedWallet(widget.selectedWallet!);
      }
    }
    if (depositController.isMultipleCurrency.value == "0") {
      await depositController.fetchDepositMethods();
    }
    depositController.isLoading.value = false;
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
                  showRightSideIcon: true,
                  title: "deposit.title".trns(),
                  rightSideIcon: PngAssets.commonClockIcon,
                  pushPage: DepositHistory(),
                  isPopEnabled: false,
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Obx(
                    () =>
                        depositController.isLoading.value
                            ? CommonLoading()
                            : Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 18,
                              ),
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
                              child: SingleChildScrollView(
                                child: Obx(
                                  () => Column(
                                    children: [
                                      DepositWalletAndGatewaySection(
                                        depositController: depositController,
                                      ),
                                      SizedBox(height: 16),
                                      DepositAmountInputSection(),
                                      if (depositController.paymentType.value ==
                                          "manual")
                                        SizedBox(height: 16),

                                      Obx(
                                        () => Visibility(
                                          visible:
                                              depositController
                                                      .paymentType
                                                      .value ==
                                                  "manual" &&
                                              depositController
                                                  .gateway
                                                  .value
                                                  .isNotEmpty,
                                          child: DepositManualDynamicFields(),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      DepositReviewDetailsSection(
                                        passcodeController: passcodeController,
                                      ),
                                      SizedBox(height: 50),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: depositController.isManualDepositLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
