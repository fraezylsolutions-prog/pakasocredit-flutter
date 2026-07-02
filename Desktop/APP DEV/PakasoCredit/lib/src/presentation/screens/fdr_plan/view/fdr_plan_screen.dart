import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/controller/fdr_plan_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/model/fdr_plan_model.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FdrPlanScreen extends StatefulWidget {
  const FdrPlanScreen({super.key});

  @override
  State<FdrPlanScreen> createState() => _FdrPlanScreenState();
}

class _FdrPlanScreenState extends State<FdrPlanScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final FdrPlanController fdrPlanController = Get.put(FdrPlanController());
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
                  title: 'Fixed Deposit Plans',
                  isPopEnabled: false,
                  showRightSideIcon: true,
                  rightSideIcon: PngAssets.commonClockIcon,
                  onPressed: () => Get.find<NavigationController>()
                      .pushNamed(BaseRoute.fdrPlanList),
                ),

                // ── Header banner ─────────────────────────────────────
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00695C), Color(0xFF00897B)],
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
                        child: const Icon(Icons.account_balance_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Fixed Deposit Plans',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lock funds and earn fixed returns',
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
                    onRefresh: () => fdrPlanController.loadData(),
                    child: Obx(() {
                      if (fdrPlanController.isLoading.value) {
                        return const CommonLoading();
                      }
                      if (fdrPlanController.fdrPlanList.isEmpty) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: CommonNoDataFound(
                              message: 'No Fixed Deposit plans found',
                              showTryAgainButton: true,
                              onTryAgain: () => fdrPlanController.loadData(),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: fdrPlanController.fdrPlanList.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final plan = fdrPlanController.fdrPlanList[index];
                          return Obx(() {
                            final isSelected =
                                fdrPlanController.selectedCheckbox.value ==
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
                  visible: fdrPlanController.isSubscriptionLoading.value,
                  child: const CommonLoading(),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(FdrPlanData plan, int index, bool isSelected) {
    return GestureDetector(
      onTap: () => fdrPlanController.selectedCheckbox.value =
          isSelected ? -1 : index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00897B)
                : (_isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFF0D2150).withValues(alpha: 0.08)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.15),
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
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.account_balance_rounded,
                        color: Color(0xFF10B981), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name ?? 'N/A',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: _textPrimary,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${plan.profitRate ?? 0}% profit',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF10B981),
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${plan.locked ?? 0} days lock',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accent,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isSelected ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color:
                          isSelected ? const Color(0xFF10B981) : Colors.grey,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // ── Amount range (collapsed) ──────────────────────────────
            if (!isSelected)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 13, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      'Min: ${plan.minimumAmount ?? 0} — Max: ${plan.maximumAmount ?? 0}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontFamily: 'Plus Jakarta Sans',
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
                    _detailRow('Profit Rate', '${plan.profitRate ?? 0}%',
                        const Color(0xFF10B981)),
                    _detailRow('Lock Period', '${plan.locked ?? 0} Days',
                        AppColors.accent),
                    _detailRow('Profit Every',
                        '${plan.profitIntervel ?? 0} Days', AppColors.primary),
                    _detailRow(
                        'Min Amount', plan.minimumAmount ?? 'N/A', _textPrimary),
                    _detailRow(
                        'Max Amount', plan.maximumAmount ?? 'N/A', _textPrimary),
                    _detailRow(
                        'Compounding', plan.compounding ?? 'No', AppColors.primary),
                    _detailRow(
                        'Maturity Fee', plan.maturityFee ?? 'N/A', AppColors.error),
                    if (plan.canCancel == 1)
                      _detailRow(
                          'Cancel In', plan.cancelIn ?? 'N/A', AppColors.warning),
                    const SizedBox(height: 12),

                    // Amount input
                    Container(
                      decoration: BoxDecoration(
                        color: _isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: TextField(
                        controller: fdrPlanController.amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: TextStyle(
                          color: _textPrimary,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter deposit amount',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                          prefixText:
                              '${fdrPlanController.siteCurrency.value}  ',
                          prefixStyle: const TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    CommonElevatedButton(
                      buttonName: 'Subscribe Now',
                      onPressed: () => _onSubscribe(plan),
                      backgroundColor: const Color(0xFF00897B),
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
      padding: const EdgeInsets.symmetric(vertical: 5),
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

  void _onSubscribe(FdrPlanData plan) {
    if (fdrPlanController.amountController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter deposit amount',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final homeCtrl = Get.find<HomeController>();
    final userPasscode = homeCtrl.userModel.value.passcode;

    if (userPasscode == null) {
      fdrPlanController.submitSubscribe(planId: plan.id.toString());
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
          fdrPlanController.submitSubscribe(planId: plan.id.toString());
        },
      ));
    } else {
      fdrPlanController.submitSubscribe(planId: plan.id.toString());
    }
  }
}
