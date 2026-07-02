import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/banks_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/fund_transfer_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/beneficiary_list/beneficiary_list.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/beneficiary_list/sub_sections/add_new_beneficiary_dialog_section.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/beneficiary_list/sub_sections/ware_transfer_limit_dialog_section.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/sub_sections/tab_bar_section.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/transfer/transfer.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/transfer_history/transfer_history.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/wire_transfer/wire_transfer.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/model/wallets_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FundTransferScreen extends StatelessWidget {
  final WalletsData? selectedWallet;
  final bool? preSelectWallet;

  const FundTransferScreen({
    super.key,
    this.selectedWallet,
    this.preSelectWallet,
  });

  @override
  Widget build(BuildContext context) {
    final FundTransferController fundTransferController = Get.put(
      FundTransferController(),
    );
    final BanksController banksController = Get.put(BanksController());

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
                Obx(
                  () => CommonAppBar(
                    title: _getAppBarTitle(
                      fundTransferController.selectedTab.value,
                    ),
                    isPopEnabled: false,
                    showRightSideIcon: true,
                    rightSideIcon: _getAppBarIcon(
                      fundTransferController.selectedTab.value,
                    ),
                    onPressed:
                        fundTransferController.selectedTab.value == 1
                            ? () async {
                              banksController.isLoading.value = true;

                              try {
                                await banksController.loadBanks();
                                if (banksController.banksList.isNotEmpty) {
                                  showAddNewBeneficiaryDialog();
                                }
                              } finally {
                                banksController.isLoading.value = false;
                              }
                            }
                            : fundTransferController.selectedTab.value == 2
                            ? () => showWareTransferLimitDialog()
                            : () => Get.find<NavigationController>().pushPage(
                              TransferHistory(),
                            ),
                  ),
                ),
                SizedBox(height: 30),
                TabBarSection(fundTransferController: fundTransferController),
                SizedBox(height: 16),
                Obx(
                  () =>
                      fundTransferController.selectedTab.value == 0
                          ? Transfer(
                            selectedWallet: selectedWallet,
                            preSelectWallet: preSelectWallet,
                          )
                          : fundTransferController.selectedTab.value == 1
                          ? BeneficiaryList()
                          : WireTransfer(),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: banksController.isLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return "fundTransfer.appBar.title.fundTransfer".trns();
      case 1:
        return "fundTransfer.appBar.title.beneficiaryList".trns();
      case 2:
        return "Initiate Transfer";
      default:
        return "";
    }
  }

  String _getAppBarIcon(int index) {
    switch (index) {
      case 0:
        return PngAssets.commonClockIcon;
      case 1:
        return PngAssets.commonAddCircleIcon;
      case 2:
        return PngAssets.commonAlertCircleIcon;
      default:
        return "";
    }
  }

  void showAddNewBeneficiaryDialog() {
    Get.dialog(AddNewBeneficiaryDialogSection());
  }

  void showWareTransferLimitDialog() {
    Get.dialog(WareTransferLimitDialogSection());
  }
}
