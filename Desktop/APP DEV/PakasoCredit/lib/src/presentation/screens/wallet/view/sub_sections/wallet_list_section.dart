import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/controller/wallet_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/model/wallets_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class WalletListSection extends StatelessWidget {
  final WalletsData wallet;
  final bool isDefault;
  final VoidCallback onAddMoney;
  final VoidCallback onSendMoney;
  final VoidCallback? onDelete;

  const WalletListSection({
    super.key,
    required this.wallet,
    required this.isDefault,
    required this.onAddMoney,
    required this.onSendMoney,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final WalletController walletController = Get.find<WalletController>();

    final cardColor =
        isDefault
            ? null
            : themeController.isDarkMode.value
            ? AppColors.darkSecondary
            : Color(0xFF6610F2).withValues(alpha: 0.10);
    final textColor = isDefault ? AppColors.textPrimary : AppColors.textPrimary;
    final buttonColor =
        isDefault ? AppColors.white : AppColors.white.withValues(alpha: 0.60);

    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isDefault
                ? PngAssets.cardShape
                : themeController.isDarkMode.value
                ? PngAssets.darkCardShape
                : PngAssets.cardShape2,
          ),
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.circular(20),
        color: cardColor,
        gradient:
            isDefault
                ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF55F4C4), Color(0xFFBAE906)],
                )
                : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "wallet.list.walletName".trnsFormat({
                          "name": wallet.name,
                        }),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color:
                              isDefault
                                  ? textColor
                                  : themeController.isDarkMode.value
                                  ? AppColors.darkTextTertiary
                                  : textColor,
                        ),
                      ),
                      SizedBox(width: 3),
                      isDefault == true
                          ? SizedBox()
                          : Text(
                            "(${wallet.code ?? 'N/A'})",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color:
                                  isDefault
                                      ? textColor
                                      : themeController.isDarkMode.value
                                      ? AppColors.darkTextTertiary
                                      : textColor,
                            ),
                          ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          walletController.isVisibleBalance.value
                              ? wallet.balance ?? '0.00'
                              : "*****",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color:
                                isDefault
                                    ? textColor
                                    : themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (isDefault)
                        Obx(
                          () => GestureDetector(
                            onTap:
                                () => walletController.toggleVisibleBalance(),
                            child: Transform.translate(
                              offset: Offset(
                                0,
                                walletController.isVisibleBalance.value
                                    ? 1.5
                                    : -2.5,
                              ),
                              child: Image.asset(
                                !walletController.isVisibleBalance.value
                                    ? PngAssets.commonEyeIcon
                                    : PngAssets.commonHideEyeIcon,
                                width:
                                    walletController.isVisibleBalance.value
                                        ? 20
                                        : 20,
                                fit: BoxFit.contain,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              if (onDelete != null)
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: onDelete,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor:
                        themeController.isDarkMode.value
                            ? AppColors.error.withValues(alpha: 0.15)
                            : AppColors.error.withValues(alpha: 0.08),
                    child: Image.asset(PngAssets.commonDeleteIcon, width: 18),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(height: isDefault && wallet.accountNo != null ? 0 : 26),
          Visibility(
            visible: isDefault && wallet.accountNo != null,
            child: GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: wallet.accountNo!));
                Fluttertoast.showToast(
                  msg: "wallet.list.copied".trns(),
                  backgroundColor: AppColors.success,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.white.withValues(alpha: 0.47),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${"wallet.list.acName".trns()}: ${wallet.accountNo}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(PngAssets.commonCopyIcon, width: 14),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              GestureDetector(
                onTap: onAddMoney,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDefault
                            ? buttonColor
                            : themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : buttonColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        PngAssets.commonAddIcon,
                        color: textColor,
                        width: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "wallet.list.buttons.add_money".trns(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onSendMoney,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDefault
                            ? buttonColor
                            : themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : buttonColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        PngAssets.commonTransferIcon,
                        color: textColor,
                        width: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "wallet.list.buttons.transfer".trns(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
