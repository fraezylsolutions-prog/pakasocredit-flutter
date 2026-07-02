import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/controller/dps_plan_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/model/dps_plan_model.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DpsPlanScreen extends StatefulWidget {
  const DpsPlanScreen({super.key});

  @override
  State<DpsPlanScreen> createState() => _DpsPlanScreenState();
}

class _DpsPlanScreenState extends State<DpsPlanScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final DpsPlanController dpsPlanController = Get.put(DpsPlanController());
  final ConfirmPasscodeController passcodeController =
      Get.put(ConfirmPasscodeController());

  bool get _isDark => themeController.isDarkMode.value;
  Color get _cardBg => _isDark ? const Color(0xFF1A2340) : Colors.white;
  Color get _textPrimary =>
      _isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get _bg => _isDark ? const Color(0xFF0A0F1E) : const Color(0xFFF0F3FA);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) =>
          Get.find<NavigationController>().popPage(),
      child: Scaffold(
        backgroundColor: _bg,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                CommonAppBar(
                  title: 'dpsPlan.title'.trns(),
                  isPopEnabled: false,
                  showRightSideIcon: true,
                  rightSideIcon: PngAssets.commonClockIcon,
                  onPressed: () => Get.find<NavigationController>()
                      .pushNamed(BaseRoute.dpsPlanList),
                ),
                // ── Header banner ─────────────────────────────────────
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D2150), Color(0xFF1A3A7A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.savings_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Smart Save Plans',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Save daily and earn interest at maturity',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 11,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Plan list ─────────────────────────────────────────
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: () => dpsPlanController.loadData(),
                    child: Obx(() {
                      if (dpsPlanController.isLoading.value) {
                        return const CommonLoading();
                      }
                      if (dpsPlanController.dpsPlanList.isEmpty) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: CommonNoDataFound(
                              message: 'dpsPlan.noData'.trns(),
                              showTryAgainButton: true,
                              onTryAgain: () => dpsPlanController.loadData(),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: dpsPlanController.dpsPlanList.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final plan = dpsPlanController.dpsPlanList[index];
                          return Obx(() {
                            final isSelected =
                                dpsPlanController.selectedCheckbox.value ==
                                    index;
                            return _buildPlanCard(plan, index, isSelected);
                          });
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
            Obx(() => Visibility(
                  visible: dpsPlanController.isSubscriptionLoading.value,
                  child: const CommonLoading(),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(DpsPlanData plan, int index, bool isSelected) {
    final symbol = Get.find<SettingsService>().currencySymbol.value;
    final currency = dpsPlanController.siteCurrency.value;

    return GestureDetector(
      onTap: () => dpsPlanController.selectedCheckbox.value =
          isSelected ? -1 : index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : (_isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFF0D2150).withValues(alpha: 0.08)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            // ── Card header ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.savings_rounded,
                        color: Color(0xFF0EA5E9), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.dpsName ?? 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: _textPrimary,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          plan.installmentDays ?? 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: AppColors.accent,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$symbol${plan.perInstallment ?? 0}',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: _textPrimary,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          plan.badge ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: AppColors.primary,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isSelected ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: isSelected ? AppColors.accent : Colors.grey,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // ── Expanded details ─────────────────────────────────────
            if (isSelected) ...[
              Divider(
                height: 1,
                color: _isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFF0D2150).withValues(alpha: 0.08),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _detailRow('Per Installment',
                        '$symbol${plan.perInstallment ?? 0} $currency',
                        AppColors.accent),
                    _detailRow('Interest Rate',
                        '${plan.interestRate ?? 0}%', AppColors.error),
                    _detailRow('Total Installments',
                        '${plan.totalInstallment ?? 0}', AppColors.primary),
                    _detailRow(
                        'Total Deposit', plan.totalDeposit ?? 'N/A', AppColors.primary),
                    _detailRow('At Maturity',
                        plan.totalMatureAmount ?? 'N/A', AppColors.success),
                    _detailRow(
                        'Maturity Fee', plan.maturityFee ?? 'N/A', AppColors.error),
                    const SizedBox(height: 16),
                    CommonElevatedButton(
                      buttonName: 'dpsPlan.buttons.subscribe'.trns(),
                      onPressed: () => _onSubscribe(plan),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.textTertiary,
                fontFamily: 'Plus Jakarta Sans',
              )),
          Text(value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueColor,
                fontFamily: 'Plus Jakarta Sans',
              )),
        ],
      ),
    );
  }

  void _onSubscribe(DpsPlanData plan) {
    final homeCtrl = Get.find<HomeController>();
    final userPasscode = homeCtrl.userModel.value.passcode;

    if (userPasscode == null) {
      dpsPlanController.submitSubscribe(planId: plan.id.toString());
      return;
    }

    final needsPasscode = passcodeController.passcodeStatus.value == '1' ||
        passcodeController.passcodeStatus.value == 'null';

    if (needsPasscode) {
      Get.dialog(ConfirmPasscodePopUp(
        controller: passcodeController.passcodeController,
        onPressed: () async {
          final ok = await passcodeController.submitPasscodeVerify();
          if (!ok) return;
          Get.back();
          dpsPlanController.submitSubscribe(planId: plan.id.toString());
        },
      ));
    } else {
      dpsPlanController.submitSubscribe(planId: plan.id.toString());
    }
  }
}
