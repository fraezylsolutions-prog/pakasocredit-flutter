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
import 'package:pakaso_credit/src/presentation/screens/loan_plan/controller/loan_plan_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_plan_model.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/view/sub_sections/apply_loan_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanPlanScreen extends StatefulWidget {
  const LoanPlanScreen({super.key});

  @override
  State<LoanPlanScreen> createState() => _LoanPlanScreenState();
}

class _LoanPlanScreenState extends State<LoanPlanScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final LoanPlanController loanPlanController = Get.put(LoanPlanController());
  final ConfirmPasscodeController passcodeController =
      Get.put(ConfirmPasscodeController());

  bool get _isDark => themeController.isDarkMode.value;
  Color get _cardBg => _isDark ? const Color(0xFF1A2340) : Colors.white;
  Color get _textPrimary =>
      _isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
  Color get _bg =>
      _isDark ? const Color(0xFF0A0F1E) : const Color(0xFFF0F3FA);

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
                  title: 'loanPlan.title'.trns(),
                  isPopEnabled: false,
                  showRightSideIcon: true,
                  rightSideIcon: PngAssets.commonClockIcon,
                  onPressed: () => Get.find<NavigationController>()
                      .pushNamed(BaseRoute.loanPlanList),
                ),

                // ── Pre-qualified banner ──────────────────────────────
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('🎉 ',
                                    style: TextStyle(fontSize: 16)),
                                const Text(
                                  "You're Pre-qualified!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Apply for a loan quickly and easily',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 11,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                            const SizedBox(height: 12),
                            _benefit('Low Interest Rates'),
                            _benefit('Flexible Repayment'),
                            _benefit('Quick Approval'),
                            _benefit('No Hidden Charges'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.credit_score_rounded,
                            color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                ),

                // ── Plan list ─────────────────────────────────────────
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: () => loanPlanController.loadData(),
                    child: Obx(() {
                      if (loanPlanController.isLoading.value) {
                        return const CommonLoading();
                      }
                      if (loanPlanController.loanPlanList.isEmpty) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: CommonNoDataFound(
                              message: 'loanPlan.noData'.trns(),
                              showTryAgainButton: true,
                              onTryAgain: () => loanPlanController.loadData(),
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: loanPlanController.loanPlanList.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, index) {
                          final plan = loanPlanController.loanPlanList[index];
                          return Obx(() {
                            final isSelected =
                                loanPlanController.selectedCheckbox.value ==
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
                  visible: loanPlanController.isApplyNowLoading.value,
                  child: const CommonLoading(),
                )),
          ],
        ),
      ),
    );
  }

  Widget _benefit(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: Color(0xFFF47920), size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(LoanPlanData plan, int index, bool isSelected) {
    return AnimatedContainer(
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
          // ── Card header ────────────────────────────────────────────
          GestureDetector(
            onTap: () => loanPlanController.selectedCheckbox.value =
                isSelected ? -1 : index,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFF47920).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.credit_score_rounded,
                        color: Color(0xFFF47920), size: 24),
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
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _chip('${plan.installmentRate ?? 0}%',
                                AppColors.error),
                            const SizedBox(width: 6),
                            _chip(
                                '${plan.installmentIntervel ?? 0} days',
                                AppColors.accent),
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
                      color: isSelected ? AppColors.accent : Colors.grey,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Amount range (collapsed) ───────────────────────────────
          if (!isSelected)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 13, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    'Min: ${plan.minimumAmount ?? 0} — Max: ${plan.maximumAmount ?? 0} ${loanPlanController.siteCurrency.value}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ],
              ),
            ),

          // ── Expanded details ───────────────────────────────────────
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
                  _detailRow(
                      'Min Amount',
                      '${plan.minimumAmount ?? 0} ${loanPlanController.siteCurrency.value}',
                      _textPrimary),
                  _detailRow(
                      'Max Amount',
                      '${plan.maximumAmount ?? 0} ${loanPlanController.siteCurrency.value}',
                      _textPrimary),
                  _detailRow('Installment Rate',
                      '${plan.installmentRate ?? 0}%', AppColors.error),
                  _detailRow('Installment Every',
                      '${plan.installmentIntervel ?? 0} Days', AppColors.accent),
                  _detailRow('Total Installments',
                      '${plan.totalInstallment ?? 0}', AppColors.primary),
                  _detailRow(
                      'Apply Fee', plan.loanFee ?? 'N/A', AppColors.error),
                  const SizedBox(height: 16),
                  CommonElevatedButton(
                    buttonName: 'loanPlan.buttons.applyNow'.trns(),
                    onPressed: () => Get.dialog(
                      ApplyLoanPopUp(
                        loanPlanData: plan,
                        passcodeController: passcodeController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
}
