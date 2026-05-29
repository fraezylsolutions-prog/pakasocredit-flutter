import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/transfer_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicFundTransferSuccess extends StatelessWidget {
  final String amount;
  final String accountNumber;
  final String transactionId;
  final String currency;
  final String title;
  final bool? isCurrencyVisible;
  final bool? isAccountVisible;

  const DynamicFundTransferSuccess({
    super.key,
    required this.amount,
    required this.accountNumber,
    required this.transactionId,
    required this.currency,
    required this.title,
    this.isCurrencyVisible,
    this.isAccountVisible,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Color(0xFFFAFAF5),
              boxShadow: AppStyles.boxShadow(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(0xFF1E7745),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.water_drop_outlined,
                      color: AppColors.white,
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  textAlign: TextAlign.center,
                  '$amount ${isCurrencyVisible == true ? currency : ""} $title',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (isAccountVisible == true) SizedBox(height: 10),
                if (isAccountVisible == true)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${"fundTransfer.transferSuccess.accountNumberText".trns()} $accountNumber',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 20),
                Text(
                  '${"fundTransfer.transferSuccess.transactionId".trns()}: $transactionId',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 30),
                CommonElevatedButton(
                  width: 150,
                  height: 45,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  borderRadius: 30,
                  backgroundColor: Color(0xFF81EF71),
                  buttonName:
                      "fundTransfer.transferSuccess.transferAgain".trns(),
                  onPressed: () {
                    final transactionController =
                        Get.find<TransferController>();
                    if (transactionController.isSendMoney.value) {
                      transactionController.isSendMoney.value = false;
                    }
                    Get.find<NavigationController>().popPage();
                  },
                  textColor: Color(0xFF1F1F1F),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
