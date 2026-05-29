import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';

class TransactionDynamicIcon {
  static String getTransactionIcon(String? type) {
    switch (type) {
      case "Deposit":
        return PngAssets.depositTypeIcon;
      case "Subtract":
        return PngAssets.subtractTypeIcon;
      case "Manual Deposit":
        return PngAssets.manualDepositTypeIcon;
      case "Send Money":
        return PngAssets.sendMoneyTypeIcon;
      case "Exchange":
        return PngAssets.exchangeTypeIcon;
      case "Referral":
        return PngAssets.referralTypeIcon;
      case "Signup Bonus":
        return PngAssets.signUpBonusTypeIcon;
      case "Portfolio Bonus":
        return PngAssets.portfolioBonusTypeIcon;
      case "Reward Redeem":
        return PngAssets.rewardRedeemTypeIcon;
      case "Withdraw":
        return PngAssets.withdrawTypeIcon;
      case "Withdraw Auto":
        return PngAssets.withdrawAutoTypeIcon;
      case "Receive Money":
        return PngAssets.receiveMoneyTypeIcon;
      case "Refund":
        return PngAssets.refundTypeIcon;
      case "Fund Transfer":
        return PngAssets.fundTransferTypeIcon;
      case "Loan":
        return PngAssets.loanTypeIcon;
      case "Loan Applied":
        return PngAssets.loanAppliedTypeIcon;
      case "Loan Installment":
        return PngAssets.loanInstallmentTypeIcon;
      case "Dps Installment":
        return PngAssets.dpsInstallmentTypeIcon;
      case "Dps Increase":
        return PngAssets.dpsIncreaseTypeIcon;
      case "Dps Decrease":
        return PngAssets.dpsDecreaseTypeIcon;
      case "Fdr Increase":
        return PngAssets.fdrIncreaseTypeIcon;
      case "Fdr Decrease":
        return PngAssets.fdrDecreaseTypeIcon;
      case "Dps Maturity":
        return PngAssets.dpsMaturityTypeIcon;
      case "Dps Cancelled":
        return PngAssets.dpsCanceledTypeIcon;
      case "Fdr":
        return PngAssets.fdrTypeIcon;
      case "Fdr Installment":
        return PngAssets.fdrInstallmentTypeIcon;
      case "Fdr Maturity Fee":
        return PngAssets.fdrMatilityFeeTypeIcon;
      case "Fdr Cancelled":
        return PngAssets.fdrCancledTypeIcon;
      case "Pay Bill":
        return PngAssets.payBillTypeIcon;
      case "Card Create":
        return PngAssets.cardCreateTypeIcon;
      case "Card Load":
        return PngAssets.cardLoadTypeIcon;
      case "Card Deposit":
        return PngAssets.cardDepositTypeIcon;
      default:
        return PngAssets.commonSubtractIcon;
    }
  }
}
