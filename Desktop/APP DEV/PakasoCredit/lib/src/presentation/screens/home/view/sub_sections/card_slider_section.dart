import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/view/deposit_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/fund_transfer_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/model/wallets_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AccountOverviewSection extends StatelessWidget {
  const AccountOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    
    // Safety check: Don't build if data is null
    if (homeController.dashboardModel.value.data == null) {
      return const SizedBox();
    }

    final wallets = homeController.dashboardModel.value.data!.wallets;
    if (wallets == null || wallets.isEmpty) return const SizedBox();

    final showSingleWalletOnly = homeController.multipleCurrency.value == "0";
    final filteredWallets = showSingleWalletOnly ? [wallets.first] : wallets;

    return filteredWallets.length > 1
        ? _buildHorizontalScrollView(filteredWallets)
        : _buildSingleCardView(filteredWallets);
  }

  Widget _buildHorizontalScrollView(List<WalletsData> wallets) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IntrinsicHeight(
          child: Row(children: _buildWalletCards(wallets)),
        ),
      ),
    );
  }

  Widget _buildSingleCardView(List<WalletsData> wallets) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildCard(
                wallet: wallets[0],
                index: 0,
                walletLength: wallets.length,
                useFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWalletCards(List<WalletsData> wallets) {
    return wallets.asMap().entries.map<Widget>((entry) {
      final index = entry.key;
      final isLastItem = index == wallets.length - 1;
      final WalletsData wallet = entry.value;

      return Padding(
        padding: EdgeInsets.only(right: isLastItem ? 0 : 10),
        child: _buildCard(
          wallet: wallet,
          index: index,
          walletLength: wallets.length,
          useFullWidth: false,
        ),
      );
    }).toList();
  }

  Widget _buildCard({
    required WalletsData wallet,
    required int index,
    required int walletLength,
    required bool useFullWidth,
  }) {
    final HomeController homeController = Get.find<HomeController>();
    final ThemeController themeController = Get.find<ThemeController>();

    final isPrimaryCard = index == 0;
    final cardColor = isPrimaryCard
        ? null
        : themeController.isDarkMode.value
            ? AppColors.darkSecondary
            : const Color(0xFF6610F2).withOpacity(0.10);
    final textColor = isPrimaryCard ? AppColors.textPrimary : AppColors.textPrimary;

    return SizedBox(
      width: useFullWidth ? double.infinity : 267,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: cardColor,
          gradient: isPrimaryCard
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF55F4C4), Color(0xFFBAE906)],
                )
              : null,
          image: DecorationImage(
            image: AssetImage(
              isPrimaryCard
                  ? PngAssets.cardShape
                  : themeController.isDarkMode.value
                      ? PngAssets.darkCardShape
                      : PngAssets.cardShape2,
            ),
            alignment: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              title: "${"home.cardSlider.walletName".trnsFormat({"name": wallet.name ?? ""})} ${isPrimaryCard ? "" : "(${wallet.code ?? ""})"}",
              titleColor: textColor,
              themeController: themeController,
              isPrimaryCard: isPrimaryCard,
            ),
            const SizedBox(height: 6),
            _buildBalanceRow(
              balance: wallet.balance ?? "0.00",
              isShowEye: isPrimaryCard,
              titleColor: textColor,
              themeController: themeController,
              isPrimaryCard: isPrimaryCard,
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildAccountRow(
                account: wallet.accountNo ?? "",
                titleColor: textColor,
              ),
            ),
            if (homeController.userDeposit.value != "0" ||
                homeController.transferStatus.value != "0")
              const SizedBox(height: 20),
            _buildActionButtons(
              wallet: wallet,
              bgColor: isPrimaryCard
                  ? AppColors.white
                  : AppColors.white.withOpacity(0.60),
              textColor: textColor,
              themeController: themeController,
              isPrimaryCard: isPrimaryCard,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required String title,
    required Color titleColor,
    required ThemeController themeController,
    required bool isPrimaryCard,
  }) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: isPrimaryCard
            ? titleColor
            : themeController.isDarkMode.value
                ? AppColors.darkTextTertiary
                : titleColor,
      ),
    );
  }

  Widget _buildBalanceRow({
    required String balance,
    required bool isShowEye,
    required Color titleColor,
    required ThemeController themeController,
    required bool isPrimaryCard,
  }) {
    final homeController = Get.find<HomeController>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => Text(
            homeController.isVisibleBalance.value ? balance : "*****",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isPrimaryCard
                  ? titleColor
                  : themeController.isDarkMode.value
                      ? AppColors.darkTextPrimary
                      : titleColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (isShowEye)
          Obx(
            () => GestureDetector(
              onTap: () => homeController.toggleVisibleBalance(),
              child: Image.asset(
                !homeController.isVisibleBalance.value
                    ? PngAssets.commonEyeIcon
                    : PngAssets.commonHideEyeIcon,
                width: 20,
                fit: BoxFit.contain,
                color: titleColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAccountRow({
    required String account,
    required Color titleColor,
  }) {
    return account.isNotEmpty
        ? GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: account));
              Fluttertoast.showToast(
                msg: "home.cardSlider.accountCopyMessage".trns(),
                backgroundColor: AppColors.success,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.white.withOpacity(0.6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${"home.cardSlider.acName".trns()}: $account",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(
                    PngAssets.commonCopyIcon,
                    width: 14,
                    fit: BoxFit.contain,
                    color: titleColor,
                  ),
                ],
              ),
            ),
          )
        : const SizedBox(height: 26);
  }

  Widget _buildActionButtons({
    required Color bgColor,
    required Color textColor,
    required WalletsData wallet,
    required ThemeController themeController,
    required bool isPrimaryCard,
  }) {
    final homeController = Get.find<HomeController>();
    return Row(
      children: [
        if (homeController.userDeposit.value != "0")
          _ButtonWidget(
            buttonWidth: 101,
            buttonHeight: 32,
            icon: PngAssets.commonAddIcon,
            label: "home.cardSlider.addMoney".trns(),
            bgColor: isPrimaryCard
                ? bgColor
                : themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : bgColor,
            textColor: textColor,
            onPressed: () => Get.find<NavigationController>().pushPage(
              DepositScreen(selectedWallet: wallet, preSelectWallet: true),
            ),
          ),
        const SizedBox(width: 10),
        if (homeController.transferStatus.value != "0")
          _ButtonWidget(
            buttonWidth: 83,
            buttonHeight: 32,
            icon: PngAssets.commonTransferIcon,
            label: "home.cardSlider.transfer".trns(),
            bgColor: isPrimaryCard
                ? bgColor
                : themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : bgColor,
            textColor: textColor,
            onPressed: () => Get.find<NavigationController>().pushPage(
              FundTransferScreen(
                selectedWallet: wallet,
                preSelectWallet: true,
              ),
            ),
          ),
      ],
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  final double buttonWidth;
  final double buttonHeight;
  final String icon;
  final String label;
  final Color bgColor;
  final Color textColor;
  final GestureTapCallback onPressed;

  const _ButtonWidget({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.onPressed,
    required this.buttonWidth,
    required this.buttonHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 14, fit: BoxFit.contain, color: textColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
