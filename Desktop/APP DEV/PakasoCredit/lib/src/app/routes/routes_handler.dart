import 'package:pakaso_credit/src/app/bindings/app_bindings.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/app/routes/routes_config.dart';
import 'package:get/get.dart';

List<GetPage> routesHandler = [
  // Splash Screen Handler
  GetPage(
    name: BaseRoute.splash,
    page: () => RoutesConfig.splash,
    binding: SplashBinding(),
  ),

  // Welcome Screen Handler
  GetPage(name: BaseRoute.welcome, page: () => RoutesConfig.welcome),

  // Onboarding Screen Handler
  GetPage(name: BaseRoute.onboarding, page: () => RoutesConfig.onboarding),

  // Sign In Screen Handler
  GetPage(
    name: BaseRoute.signIn,
    page: () => RoutesConfig.signIn,
    binding: SignInBinding(),
  ),

  // Forgot Password Screen Handler
  GetPage(
    name: BaseRoute.forgotPassword,
    page: () => RoutesConfig.forgotPassword,
    binding: ForgotPasswordBinding(),
  ),

  // Sign Up Screen Handler
  GetPage(
    name: BaseRoute.signUp,
    page: () => RoutesConfig.signUp,
    bindings: [SignUpBinding(), RegisterFieldsBinding()],
  ),

  // Finish Up Account Screen Handler
  GetPage(
    name: BaseRoute.finishUpAccount,
    page: () => RoutesConfig.finishUpAccount,
    binding: FinishUpAccountBinding(),
  ),

  // Navigation Screen Handler
  GetPage(
    name: BaseRoute.navigation,
    page: () => RoutesConfig.navigation,
    bindings: [NavigationBinding(), HomeBinding()],
  ),

  // Congrats Screen Handler
  GetPage(
    name: BaseRoute.congrats,
    page: () => RoutesConfig.congrats,
    binding: CongratsBinding(),
  ),

  // Referral Screen Handler
  GetPage(name: BaseRoute.referral, page: () => RoutesConfig.referral),

  // Referred Friends Screen Handler
  GetPage(
    name: BaseRoute.referredFriends,
    page: () => RoutesConfig.referredFriends,
  ),

  // Referral Tree Screen Handler
  GetPage(name: BaseRoute.referralTree, page: () => RoutesConfig.referralTree),

  // Deposit Screen Handler
  GetPage(name: BaseRoute.deposit, page: () => RoutesConfig.deposit),

  // Fund Transfer Screen Handler
  GetPage(name: BaseRoute.fundTransfer, page: () => RoutesConfig.fundTransfer),

  // DPS Plan Screen Handler
  GetPage(name: BaseRoute.dpsPlan, page: () => RoutesConfig.dpsPlan),

  // FDR Plan Screen Handler
  GetPage(name: BaseRoute.fdrPlan, page: () => RoutesConfig.fdrPlan),

  // Loan Plan Screen Handler
  GetPage(name: BaseRoute.loanPlan, page: () => RoutesConfig.loanPlan),

  // Wallet Screen Handler
  GetPage(name: BaseRoute.wallet, page: () => RoutesConfig.wallet),

  // Virtual Card Screen Handler
  GetPage(name: BaseRoute.virtualCard, page: () => RoutesConfig.virtualCard),

  // Statistics Screen Handler
  GetPage(name: BaseRoute.statistics, page: () => RoutesConfig.statistics),

  // Notification Screen Handler
  GetPage(name: BaseRoute.notification, page: () => RoutesConfig.notification),

  // Pay Bill Screen Handler
  GetPage(name: BaseRoute.payBill, page: () => RoutesConfig.payBill),

  // Withdraw Screen Handler
  GetPage(name: BaseRoute.withdraw, page: () => RoutesConfig.withdraw),

  // Portfolio Screen Handler
  GetPage(name: BaseRoute.portfolio, page: () => RoutesConfig.portfolio),

  // Reward Screen Handler
  GetPage(name: BaseRoute.reward, page: () => RoutesConfig.reward),

  // Profile Setting Screen Handler
  GetPage(
    name: BaseRoute.profileSetting,
    page: () => RoutesConfig.profileSetting,
  ),

  // Change Password Screen Handler
  GetPage(
    name: BaseRoute.changePassword,
    page: () => RoutesConfig.changePassword,
  ),

  // Security Setting Screen Handler
  GetPage(
    name: BaseRoute.securitySetting,
    page: () => RoutesConfig.securitySetting,
  ),

  // Help And Support Screen Handler
  GetPage(
    name: BaseRoute.helpAndSupport,
    page: () => RoutesConfig.helpAndSupport,
  ),

  // ID Verification Screen Handler
  GetPage(
    name: BaseRoute.idVerification,
    page: () => RoutesConfig.idVerification,
  ),

  // Two Fa Screen Handler
  GetPage(
    name: BaseRoute.twoFa,
    page: () => RoutesConfig.twoFa,
    binding: TwoFaBinding(),
  ),

  // Pin Code Verification Screen Handler
  GetPage(
    name: BaseRoute.pinCodeVerification,
    page: () => RoutesConfig.pinCodeVerification,
    binding: PinCodeBinding(),
  ),

  // Reset Password Screen Handler
  GetPage(
    name: BaseRoute.resetPassword,
    page: () => RoutesConfig.resetPassword,
    binding: ResetPasswordBinding(),
  ),

  // Dps Plan List Screen Handler
  GetPage(name: BaseRoute.dpsPlanList, page: () => RoutesConfig.dpsPlanList),

  // Fdr Plan List Screen Handler
  GetPage(name: BaseRoute.fdrPlanList, page: () => RoutesConfig.fdrPlanList),

  // Loan Plan List Screen Handler
  GetPage(name: BaseRoute.loanPlanList, page: () => RoutesConfig.loanPlanList),

  // Settings Screen Handler
  GetPage(name: BaseRoute.settings, page: () => RoutesConfig.settings),
];
