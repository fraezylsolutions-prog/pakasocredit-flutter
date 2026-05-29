import 'package:pakaso_credit/src/app/navigation/navigation_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/all_statistics/view/all_statistics.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/congrats/view/congrats_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/finish_up_account/view/finish_up_account_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/forgot_password/view/forgot_password_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/forgot_password/view/pin_code_verification/pin_code_verification.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/forgot_password/view/reset_password/reset_password.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/onboarding/view/onboarding_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/sign_in/view/sign_in_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/sign_up/view/sign_up_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/splash/view/splash_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/two_fa/view/two_fa_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/welcome/view/welcome_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/view/deposit_history/deposit_history.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/view/deposit_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/view/dps_plan_list/dps_plan_list.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/view/dps_plan_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/view/fdr_plan_list/fdr_plan_list.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/view/fdr_plan_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/fund_transfer_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/view/loan_plan_list/loan_plan_list.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/view/loan_plan_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/pay_bill_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/portfolio/view/portfolio_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/referral/view/referral_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/referral/view/referral_tree/referral_tree.dart';
import 'package:pakaso_credit/src/presentation/screens/referral/view/referred_friends/referred_friends.dart';
import 'package:pakaso_credit/src/presentation/screens/reward/view/reward_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/all_notification/all_notification.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/change_password/change_password.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/help_and_support/help_and_support.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/id_verification/id_verification.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/id_verification/sub_sections/kyc_history.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/profile_setting/profile_setting.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/security_setting/security_setting.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/setting_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/view/virtual_card_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/view/create_new_wallet/create_new_wallet.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/view/wallet_screen.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/view/withdraw_screen.dart';

class RoutesConfig {
  // Splash Screen
  static const splash = SplashScreen();

  // Welcome Screen
  static const welcome = WelcomeScreen();

  // Onboarding Screen
  static const onboarding = OnboardingScreen();

  // Sign In Screen
  static const signIn = SignInScreen();

  // Forgot Password Screen
  static const forgotPassword = ForgotPasswordScreen();

  // Sign Up Screen
  static const signUp = SignUpScreen();

  // Finish Up Account Screen
  static const finishUpAccount = FinishUpAccountScreen();

  // Navigation Screen
  static const navigation = NavigationScreen();

  // Congrats Screen
  static const congrats = CongratsScreen();

  // Congrats Screen
  static const referral = ReferralScreen();

  // Referred Friends Screen
  static const referredFriends = ReferredFriends();

  // Referral Tree Screen
  static const referralTree = ReferralTree();

  // Deposit Screen
  static const deposit = DepositScreen();

  // Fund Transfer Screen
  static const fundTransfer = FundTransferScreen();

  // DPS Plan Screen
  static const dpsPlan = DpsPlanScreen();

  // FDR Plan Screen
  static const fdrPlan = FdrPlanScreen();

  // Loan Plan Screen
  static const loanPlan = LoanPlanScreen();

  // Wallet Screen
  static const wallet = WalletScreen();

  // Virtual Card Screen
  static const virtualCard = VirtualCardScreen();

  // Statistics Screen
  static const statistics = AllStatistics();

  // Notification Screen
  static const notification = AllNotification();

  // Pay Bill Screen
  static const payBill = PayBillScreen();

  // Withdraw Screen
  static const withdraw = WithdrawScreen();

  // Portfolio Screen
  static const portfolio = PortfolioScreen();

  // Reward Screen
  static const reward = RewardScreen();

  // Deposit History Screen
  static const depositHistory = DepositHistory();

  // KYC History Screen
  static const kycHistory = KycHistory();

  // Create Wallet Screen
  static const createWallet = CreateNewWallet();

  // Profile Setting Screen
  static const profileSetting = ProfileSetting();

  // Change Password Screen
  static const changePassword = ChangePassword();

  // Security Setting Screen
  static const securitySetting = SecuritySetting();

  // Help And Support Screen
  static const helpAndSupport = HelpAndSupport();

  // ID Verification Screen
  static const idVerification = IdVerification();

  // Two Fa Screen
  static const twoFa = TwoFaScreen();

  // Pin Code Verification Screen
  static const pinCodeVerification = PinCodeVerification();

  // Reset Password Screen
  static const resetPassword = ResetPassword();

  // Dps Plan List Screen
  static const dpsPlanList = DpsPlanList();

  // Fdr Plan List Screen
  static const fdrPlanList = FdrPlanList();

  // Loan Plan List Screen
  static const loanPlanList = LoanPlanList();

  // Settings Screen
  static const settings = SettingScreen();
}
