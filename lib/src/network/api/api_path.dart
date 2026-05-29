class ApiPath {
  // Common Endpoints
  static const String baseUrl = 'https://pakasocredit.com/api';

  // Common Endpoints
  static const String countriesEndpoint = '/get-countries';
  static const String branchesEndpoint = '/get-branches';
  static const String currenciesEndpoint = '/get-currencies';
  static const String banksEndpoint = '/get-banks';
  static const String languagesEndpoint = '/get-languages';
  static const String getAccountEndpoint = '/get-account';
  static const String getSettingsEndpoint = '/get-settings';
  static const String getNavigationsEndpoint = '/get-navigations';
  static const String getOnboardingEndpoint = '/get-onboarding-screen-images';
  static const String changeLanguageEndpoint = '/change-language';
  static const String getSetupFcm = '/setup-fcm';

  static String settingsEndpoint({required String endPointType}) =>
      '$getSettingsEndpoint?key=$endPointType';

  static String translationEndpoint({required String languageCode}) =>
      '$changeLanguageEndpoint/$languageCode';

  // Authentication Endpoints
  static const String loginEndpoint = '/login';
  static const String logoutEndpoint = '/logout';
  static const String forgotPasswordEndpoint = '/forgot-password';
  static const String registerStepOneEndpoint = '/register/step1';
  static const String registerStepTwoEndpoint = '/register/step2';
  static const String getRegisterFieldsEndpoint = '/get-register-fields';
  static const String twoFaEndpoint = '/2fa/verify';
  static const String resetVerifyOtpEndpoint = '/reset-verify-otp';
  static const String resetPasswordEndpoint = '/reset-password';

  // Dashboard Endpoints
  static const String userEndpoint = '/user';
  static const String dashboardEndpoint = '/dashboard-data';

  // Statistics Endpoints
  static const String statisticsEndpoint = '/statistics';

  // Transaction Endpoints
  static const String transactionTypeEndpoint = '/get-transaction-types';
  static const String transactionsEndpoint = '/transactions';

  // Wallets Endpoints
  static const String walletsEndpoint = '/wallets';

  // KYC Endpoints
  static const String kycEndpoint = '/kyc';

  // Fund Transfer Endpoints
  static const String beneficiaryEndpoint = '/beneficiary';
  static const String transferEndpoint = '/transfer';
  static const String wireTransferSettingsEndpoint = '/wire-transfer-settings';
  static const String wireTransferEndpoint = '/wire-transfer';

  // Deposit Endpoints
  static const String depositEndpoint = '/deposit';

  // Dps Endpoints
  static const String dpsEndpoint = '/dps';

  // Fdr Endpoints
  static const String fdrEndpoint = '/fdr';

  // Loan Endpoints
  static const String loanEndpoint = '/loan';

  // Pay Bill Endpoints
  static const String billCountriesEndpoint = '/get-bill-countries';
  static const String payBillEndpoint = '/pay-bill';

  // Virtual Cards Endpoints
  static const String virtualCardsEndpoint = '/cards';
  static const String cardProvidersEndpoint = '/get-card-providers';
  static const String cardHoldersEndpoint = '/cardholders';

  // Referral Endpoints
  static const String referralEndpoint = '/referral';

  // Portfolio Endpoints
  static const String portfolioEndpoint = '/portfolio';

  // Rewards Endpoints
  static const String rewardsEndpoint = '/rewards';

  // Tickets Endpoints
  static const String ticketEndpoint = '/ticket';

  // Withdraw Endpoints
  static const String withdrawAccountEndpoint = '/withdraw-account';
  static const String withdrawMethodsEndpoint = '/get-withdraw-methods';
  static const String withdrawEndpoint = '/withdraw';

  // Settings Endpoints
  static const String profileSettingsEndpoint = '/settings';
  static const String markAsReadNotificationEndpoint =
      '/mark-as-read-notification';
  static const String notificationsEndpoint = '/get-notifications';
}
