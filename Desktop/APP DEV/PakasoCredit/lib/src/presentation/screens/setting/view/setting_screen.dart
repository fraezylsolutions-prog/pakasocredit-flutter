import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/services/biometric_auth_service.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_alert_dialog.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/all_notification/all_notification.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/change_password/change_password.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/help_and_support/help_and_support.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/id_verification/id_verification.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/profile_setting/profile_setting.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/security_setting/security_setting.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/sub_sections/close_account_alert.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final HomeController homeController = Get.find<HomeController>();
  final RxBool isBiometricEnabled = false.obs;
  final RxBool isBiometricAvailable = false.obs;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final saved = await SettingsService.getBiometricEnableOrDisable();
    isBiometricEnabled.value = saved ?? false;

    final bioService = BiometricAuthService();
    isBiometricAvailable.value = await bioService.isBiometricAvailable();
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // Check if biometric is available on device
      final bioService = BiometricAuthService();
      final available = await bioService.isBiometricAvailable();
      if (!available) {
        Fluttertoast.showToast(
          msg: 'Biometric not available on this device',
          backgroundColor: AppColors.error,
        );
        return;
      }

      // Authenticate first before enabling
      final authenticated = await bioService.authenticateWithBiometrics();
      if (!authenticated) {
        Fluttertoast.showToast(
          msg: 'Biometric authentication failed',
          backgroundColor: AppColors.error,
        );
        return;
      }
    }

    await Get.find<SettingsService>().saveBiometricEnableOrDisable(value);
    isBiometricEnabled.value = value;

    Fluttertoast.showToast(
      msg: value ? 'Biometric login enabled' : 'Biometric login disabled',
      backgroundColor: value ? AppColors.success : AppColors.textTertiary,
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      CommonAlertDialog(
        title: 'Logout',
        message: 'Are you sure you want to logout?',
        onConfirm: () {
          Get.back();
          homeController.submitLogout();
        },
        onCancel: () => Get.back(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        final navigationController = Get.find<NavigationController>();
        if (!navigationController.popPage()) {
          navigationController.selectedIndex.value = 0;
        }
      },
      child: Obx(() {
        final isDark = themeController.isDarkMode.value;
        final cardBg = isDark ? AppColors.darkSecondary : AppColors.white;
        final textColor =
            isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
        final dividerColor = isDark
            ? AppColors.darkCardBorder
            : AppColors.textPrimary.withValues(alpha: 0.06);

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : const Color(0xFFF0F3FA),
          body: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  CommonAppBar(
                    title: 'settings.title'.trns(),
                    isPopEnabled: false,
                    showRightSideIcon: false,
                    selectedIndex: 0,
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        homeController.isSettingsLoading.value = true;
                        await homeController.fetchUser();
                        homeController.isSettingsLoading.value = false;
                      },
                      child: Obx(() {
                        if (homeController.isSettingsLoading.value) {
                          return SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.7,
                            child: const CommonLoading(),
                          );
                        }

                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              // ── Profile Card ──────────────────────────
                              _buildProfileCard(isDark, textColor),
                              const SizedBox(height: 16),

                              // ── Account Settings ──────────────────────
                              _sectionLabel('Account', isDark),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    _settingItem(
                                      icon: Icons.person_outline_rounded,
                                      title: 'settings.menuItems.profile'.trns(),
                                      color: AppColors.primary,
                                      isDark: isDark,
                                      dividerColor: dividerColor,
                                      onTap: () => Get.find<NavigationController>()
                                          .pushPage(ProfileSetting()),
                                    ),
                                    _settingItem(
                                      icon: Icons.lock_outline_rounded,
                                      title: 'settings.menuItems.password'.trns(),
                                      color: AppColors.primary,
                                      isDark: isDark,
                                      dividerColor: dividerColor,
                                      onTap: () => Get.find<NavigationController>()
                                          .pushPage(ChangePassword()),
                                    ),
                                    if (homeController.faVerification.value != '0' ||
                                        homeController.passcodeVerification.value != '0')
                                      _settingItem(
                                        icon: Icons.security_rounded,
                                        title: 'settings.menuItems.twoFA'.trns(),
                                        color: AppColors.primary,
                                        isDark: isDark,
                                        dividerColor: dividerColor,
                                        onTap: () => Get.find<NavigationController>()
                                            .pushPage(SecuritySetting()),
                                      ),
                                    if (homeController.kycVerification.value != '0')
                                      _settingItem(
                                        icon: Icons.verified_user_rounded,
                                        title: 'settings.menuItems.idVerification'.trns(),
                                        color: AppColors.primary,
                                        isDark: isDark,
                                        dividerColor: dividerColor,
                                        trailing: _kycBadge(),
                                        onTap: () => Get.find<NavigationController>()
                                            .pushPage(IdVerification()),
                                      ),
                                    _settingItem(
                                      icon: Icons.notifications_outlined,
                                      title: 'settings.menuItems.notifications'.trns(),
                                      color: AppColors.primary,
                                      isDark: isDark,
                                      dividerColor: dividerColor,
                                      showDivider: false,
                                      onTap: () => Get.find<NavigationController>()
                                          .pushPage(AllNotification()),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ── Security Settings ─────────────────────
                              _sectionLabel('Security', isDark),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    // Biometric toggle
                                    Obx(() => _biometricToggleItem(
                                          isDark: isDark,
                                          dividerColor: dividerColor,
                                          isAvailable:
                                              isBiometricAvailable.value,
                                          isEnabled: isBiometricEnabled.value,
                                          onToggle: _toggleBiometric,
                                        )),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ── Support ───────────────────────────────
                              _sectionLabel('Support', isDark),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: _settingItem(
                                  icon: Icons.headset_mic_outlined,
                                  title: 'settings.menuItems.helpSupport'.trns(),
                                  color: AppColors.primary,
                                  isDark: isDark,
                                  dividerColor: dividerColor,
                                  showDivider: false,
                                  onTap: () => Get.find<NavigationController>()
                                      .pushPage(HelpAndSupport()),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ── Danger Zone ───────────────────────────
                              _sectionLabel('Account Actions', isDark),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    // Logout
                                    _settingItem(
                                      icon: Icons.logout_rounded,
                                      title: 'Logout',
                                      color: AppColors.warning,
                                      isDark: isDark,
                                      dividerColor: dividerColor,
                                      onTap: _showLogoutDialog,
                                    ),
                                    // Delete Account
                                    _settingItem(
                                      icon: Icons.delete_outline_rounded,
                                      title: 'settings.menuItems.deleteAccount'.trns(),
                                      color: AppColors.error,
                                      isDark: isDark,
                                      dividerColor: dividerColor,
                                      showDivider: false,
                                      onTap: () => showCloseAccountAlert(),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 40),

                              // App version
                              Text(
                                'Pakaso Credit v1.0.0',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppColors.darkTextTertiary
                                      : AppColors.textTertiary,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              Obx(() => Visibility(
                    visible: homeController.isDeleteAccountLoading.value,
                    child: const CommonLoading(),
                  )),
            ],
          ),
        );
      }),
    );
  }

  // ── Profile Card ────────────────────────────────────────────────────────
  Widget _buildProfileCard(bool isDark, Color textColor) {
    final user = homeController.userModel.value;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2150), Color(0xFF1A3A7A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 2),
              color: Colors.white.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: (user.avatarPath ?? user.avatar) != null && (user.avatarPath ?? user.avatar)!.isNotEmpty
                  ? Image.network(user.avatarPath ?? user.avatar!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _avatarFallback(user.firstName ?? 'U'))
                  : _avatarFallback(user.firstName ?? 'U'),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  user.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                const SizedBox(height: 4),
                // KYC badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: user.kyc == 1
                        ? AppColors.success.withValues(alpha: 0.2)
                        : AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.kyc == 1 ? '✓ Verified' : 'Unverified',
                    style: TextStyle(
                      color: user.kyc == 1 ? AppColors.success : AppColors.warning,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Edit icon
          GestureDetector(
            onTap: () => Get.find<NavigationController>()
                .pushPage(ProfileSetting()),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback(String name) => Container(
        color: const Color(0xFF1A3A7A),
        child: Center(
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
        ),
      );

  // ── Section Label ───────────────────────────────────────────────────────
  Widget _sectionLabel(String label, bool isDark) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
            fontFamily: 'Plus Jakarta Sans',
            letterSpacing: 0.5,
          ),
        ),
      );

  // ── Setting Item ────────────────────────────────────────────────────────
  Widget _settingItem({
    required IconData icon,
    required String title,
    required Color color,
    required bool isDark,
    required Color dividerColor,
    required VoidCallback onTap,
    Widget? trailing,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color == AppColors.error || color == AppColors.warning
                          ? color
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary),
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.textTertiary,
                    ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 0, color: dividerColor, indent: 64),
      ],
    );
  }

  // ── Biometric Toggle ────────────────────────────────────────────────────
  Widget _biometricToggleItem({
    required bool isDark,
    required Color dividerColor,
    required bool isAvailable,
    required bool isEnabled,
    required Function(bool) onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.fingerprint_rounded,
                color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biometric Login',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
                Text(
                  isAvailable
                      ? 'Use fingerprint or face ID to login'
                      : 'Not available on this device',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.textTertiary,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: isAvailable ? onToggle : null,
            activeColor: AppColors.accent,
            activeTrackColor: AppColors.accent.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  // ── KYC Badge ───────────────────────────────────────────────────────────
  Widget _kycBadge() {
    final kyc = homeController.userModel.value.kyc;
    Color color;
    String label;

    if (kyc == 0) {
      color = AppColors.error;
      label = 'Submit';
    } else if (kyc == 1) {
      color = AppColors.success;
      label = 'Approved';
    } else if (kyc == 2) {
      color = AppColors.warning;
      label = 'Pending';
    } else {
      color = AppColors.textTertiary;
      label = 'N/A';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
    );
  }

  void showCloseAccountAlert() {
    Get.dialog(CloseAccountAlert());
  }
}
