import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/view/deposit_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/fund_transfer_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/controller/wallet_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/model/wallets_model.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/view/create_new_wallet/create_new_wallet.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/view/sub_sections/wallet_delete_pop_up.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/view/sub_sections/wallet_list_section.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final WalletController walletController = Get.put(WalletController());
    final NavigationController navigationController =
        Get.find<NavigationController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        navigationController.selectedIndex.value = 0;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              CommonAppBar(
                showRightSideIcon: false,
                padding: 0,
                title: "wallet.title".trns(),
                isPopEnabled: false,
                selectedIndex: 0,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: RefreshIndicator(
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                  onRefresh: () => walletController.fetchWallets(),
                  child: Obx(() {
                    if (walletController.isLoading.value) {
                      return const CommonLoading();
                    }

                    if (walletController.walletsList.isEmpty) {
                      return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(
                            child: CommonNoDataFound(
                              message: "wallet.no_data.message".trns(),
                              showTryAgainButton: true,
                              onTryAgain: () => walletController.fetchWallets(),
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 20,
                      ),
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 20);
                      },
                      itemCount: walletController.walletsList.length,
                      itemBuilder: (context, index) {
                        final WalletsData wallet =
                            walletController.walletsList[index];
                        final isDefault = index == 0;

                        return WalletListSection(
                          wallet: wallet,
                          isDefault: isDefault,
                          onAddMoney: () {
                            navigationController.pushPage(
                              DepositScreen(
                                selectedWallet: wallet,
                                preSelectWallet: true,
                              ),
                            );
                          },
                          onSendMoney: () {
                            navigationController.pushPage(
                              FundTransferScreen(
                                selectedWallet: wallet,
                                preSelectWallet: true,
                              ),
                            );
                          },
                          onDelete:
                              isDefault
                                  ? null
                                  : () => showDeleteWallet(
                                    walletId: wallet.id.toString(),
                                  ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
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
                  CreateNewWallet(),
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
        ),
      ),
    );
  }

  void showDeleteWallet({required walletId}) {
    Get.dialog(
      barrierDismissible: false,
      WalletDeletePopUp(walletId: walletId),
    );
  }
}
