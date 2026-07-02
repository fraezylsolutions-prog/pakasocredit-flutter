import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_alert_dialog.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final NavigationController navigationController =
      Get.find<NavigationController>();

  bool get _isDark => themeController.isDarkMode.value;
  Color get _bg => _isDark ? const Color(0xFF0A0F1E) : const Color(0xFFF0F3FA);
  Color get _cardBg => _isDark ? const Color(0xFF1A2340) : Colors.white;
  Color get _cardBorder => _isDark
      ? Colors.white.withValues(alpha: 0.08)
      : const Color(0xFF0D2150).withValues(alpha: 0.08);
  Color get _labelColor =>
      _isDark ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF4A5568);
  Color get _titleColor => _isDark ? Colors.white : const Color(0xFF0D2150);
  Color get _svcColor =>
      _isDark ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF0D2150);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => _showExitDialog(),
      child: Obx(() => Scaffold(
            backgroundColor: _bg,
            body: homeController.isDashboardLoading.value
                ? const CommonLoading()
                : RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: () => homeController.loadData(),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(child: _buildHeader()),
                        SliverToBoxAdapter(child: _buildQuickActions()),
                        SliverToBoxAdapter(child: _buildServicesGrid()),
                        SliverToBoxAdapter(child: _buildRecentTransactions()),
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
                    ),
                  ),
          )),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HEADER — Navy gradient, greeting, wallet card
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0D2150),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              // ── Top bar ────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Avatar + Greeting
                  Obx(() {
                    final user = homeController.userModel.value;
                    final name = user.firstName ?? 'User';
                    final hour = DateTime.now().hour;
                    final greeting = hour < 12
                        ? 'Good Morning,'
                        : hour < 17
                            ? 'Good Afternoon,'
                            : 'Good Evening,';
                    final avatar = user.avatarPath ?? user.avatar;

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () => navigationController.pushNamed(BaseRoute.settings),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: AppColors.accent, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: avatar != null && avatar.isNotEmpty
                                  ? Image.network(avatar,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _avatarPlaceholder(name))
                                  : _avatarPlaceholder(name),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(greeting,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  fontSize: 11,
                                  fontFamily: 'Plus Jakarta Sans',
                                )),
                            Text(name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Plus Jakarta Sans',
                                )),
                          ],
                        ),
                      ],
                    );
                  }),

                  // Theme toggle + Notification
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => themeController.toggleTheme(),
                        child: Obx(() => _iconBtn(
                              _isDark
                                  ? Icons.wb_sunny_rounded
                                  : Icons.dark_mode_rounded,
                            )),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => navigationController.pushNamed(BaseRoute.notification),
                        child: Stack(
                          children: [
                            _iconBtn(Icons.notifications_outlined),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Wallet Card ─────────────────────────────────────────────
              Obx(() {
                final data = homeController.dashboardModel.value.data;
                final wallet =
                    data?.wallets != null && data!.wallets!.isNotEmpty
                        ? data.wallets!.first
                        : null;
                final balance = wallet?.balance ?? '0.00';
                final accountNo = wallet?.accountNo ?? '';
                final walletName = wallet?.name ?? 'Main Wallet';
                final isVisible = homeController.isVisibleBalance.value;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(walletName,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12,
                                fontFamily: 'Plus Jakarta Sans',
                              )),
                          GestureDetector(
                            onTap: () => homeController.isVisibleBalance
                                .value = !isVisible,
                            child: Icon(
                              isVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.white.withValues(alpha: 0.6),
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isVisible ? '$balance' : '••••••',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Plus Jakarta Sans',
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (accountNo.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                ClipboardData(text: accountNo));
                            Fluttertoast.showToast(
                              msg: 'Account number copied!',
                              backgroundColor: AppColors.success,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('A/C: $accountNo',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Plus Jakarta Sans',
                                    )),
                                const SizedBox(width: 6),
                                const Icon(Icons.copy_rounded,
                                    color: Colors.white, size: 12),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          if (homeController.userDeposit.value != '0')
                            _walletBtn(
                              label: 'Add Funds',
                              isPrimary: true,
                              onTap: () => navigationController.pushNamed(BaseRoute.deposit),
                            ),
                          const SizedBox(width: 10),
                          if (homeController.transferStatus.value != '0')
                            _walletBtn(
                              label: 'Send Money',
                              isPrimary: false,
                              onTap: () =>
                                  navigationController.pushNamed(BaseRoute.fundTransfer),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUICK ACTIONS — 5 icons row
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildQuickActions() {
    return Obx(() {
      final actions = <_ActionItem>[
        if (homeController.userDeposit.value != '0')
          _ActionItem(
            icon: Icons.add_circle_outline_rounded,
            label: 'Deposit',
            color: const Color(0xFF0D2150),
            bg: const Color(0xFF0D2150).withValues(alpha: 0.08),
            onTap: () => navigationController.pushNamed(BaseRoute.deposit),
          ),
        if (homeController.userWithdraw.value != '0')
          _ActionItem(
            icon: Icons.arrow_upward_rounded,
            label: 'Withdraw',
            color: const Color(0xFFF47920),
            bg: const Color(0xFFF47920).withValues(alpha: 0.1),
            onTap: () => navigationController.pushNamed(BaseRoute.withdraw),
          ),
        if (homeController.transferStatus.value != '0')
          _ActionItem(
            icon: Icons.swap_horiz_rounded,
            label: 'Transfer',
            color: const Color(0xFF8B5CF6),
            bg: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            onTap: () => navigationController.pushNamed(BaseRoute.fundTransfer),
          ),
        if (homeController.userPayBill.value != '0')
          _ActionItem(
            icon: Icons.receipt_long_rounded,
            label: 'Pay Bills',
            color: const Color(0xFF10B981),
            bg: const Color(0xFF10B981).withValues(alpha: 0.1),
            onTap: () => navigationController.pushNamed(BaseRoute.payBill),
          ),
        _ActionItem(
          icon: Icons.more_horiz_rounded,
          label: 'More',
          color: const Color(0xFF9AA5B4),
          bg: const Color(0xFF9AA5B4).withValues(alpha: 0.1),
          onTap: () => navigationController.pushNamed(BaseRoute.statistics),
        ),
      ];

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions
              .map((a) => GestureDetector(
                    onTap: a.onTap,
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: a.bg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(a.icon, color: a.color, size: 24),
                        ),
                        const SizedBox(height: 6),
                        Text(a.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _labelColor,
                              fontFamily: 'Plus Jakarta Sans',
                            )),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
    });
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SERVICES GRID — 4 per row, 2 rows, no title
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildServicesGrid() {
    return Obx(() {
      // Row 1
      final row1 = <_ServiceItem>[
        if (homeController.userDps.value != '0')
          _ServiceItem(
            icon: Icons.savings_rounded,
            label: 'Smart Save',
            color: const Color(0xFF0EA5E9),
            bg: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
            onTap: () => navigationController.pushNamed(BaseRoute.dpsPlan),
          ),
        if (homeController.userFdr.value != '0')
          _ServiceItem(
            icon: Icons.account_balance_rounded,
            label: 'Fixed Deposit',
            color: const Color(0xFF10B981),
            bg: const Color(0xFF10B981).withValues(alpha: 0.12),
            onTap: () => navigationController.pushNamed(BaseRoute.fdrPlan),
          ),
        if (homeController.userLoan.value != '0')
          _ServiceItem(
            icon: Icons.credit_score_rounded,
            label: 'Loan',
            color: const Color(0xFFF47920),
            bg: const Color(0xFFF47920).withValues(alpha: 0.12),
            onTap: () => navigationController.pushNamed(BaseRoute.loanPlan),
          ),
        if (homeController.multipleCurrency.value != '0')
          _ServiceItem(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Wallet',
            color: const Color(0xFF0D2150),
            bg: const Color(0xFF0D2150).withValues(alpha: 0.08),
            onTap: () => navigationController.pushNamed(BaseRoute.wallet),
          ),
      ];

      // Row 2
      final row2 = <_ServiceItem>[
        if (homeController.virtualCard.value != '0')
          _ServiceItem(
            icon: Icons.credit_card_rounded,
            label: 'Virtual Cards',
            color: const Color(0xFF8B5CF6),
            bg: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
            onTap: () => navigationController.pushNamed(BaseRoute.virtualCard),
          ),
        if (homeController.userReward.value != '0')
          _ServiceItem(
            icon: Icons.card_giftcard_rounded,
            label: 'Rewards',
            color: const Color(0xFFEC4899),
            bg: const Color(0xFFEC4899).withValues(alpha: 0.12),
            onTap: () => navigationController.pushNamed(BaseRoute.reward),
          ),
        if (homeController.userPortfolio.value != '0')
          _ServiceItem(
            icon: Icons.pie_chart_rounded,
            label: 'Portfolio',
            color: const Color(0xFF14B8A6),
            bg: const Color(0xFF14B8A6).withValues(alpha: 0.12),
            onTap: () => navigationController.pushNamed(BaseRoute.portfolio),
          ),
        if (homeController.signUpReferral.value != '0')
          _ServiceItem(
            icon: Icons.people_rounded,
            label: 'Referral',
            color: const Color(0xFF6366F1),
            bg: const Color(0xFF6366F1).withValues(alpha: 0.12),
            onTap: () => navigationController.pushNamed(BaseRoute.referral),
          ),
      ];

      if (row1.isEmpty && row2.isEmpty) return const SizedBox();

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          children: [
            if (row1.isNotEmpty) _buildServiceRow(row1),
            if (row1.isNotEmpty && row2.isNotEmpty) const SizedBox(height: 14),
            if (row2.isNotEmpty) _buildServiceRow(row2),
          ],
        ),
      );
    });
  }

  Widget _buildServiceRow(List<_ServiceItem> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items
          .map((s) => GestureDetector(
                onTap: s.onTap,
                child: SizedBox(
                  width: 70,
                  child: Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: s.bg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(s.icon, color: s.color, size: 26),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        s.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: _svcColor,
                          fontFamily: 'Plus Jakarta Sans',
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // RECENT TRANSACTIONS
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildRecentTransactions() {
    return Obx(() {
      final data = homeController.dashboardModel.value.data;
      final transactions = data?.transactions ?? [];

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Transactions',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: _titleColor,
                      fontFamily: 'Plus Jakarta Sans',
                    )),
                GestureDetector(
                  onTap: () => navigationController.pushNamed(BaseRoute.statistics),
                  child: const Text('See all',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF47920),
                        fontFamily: 'Plus Jakarta Sans',
                      )),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (transactions.isEmpty)
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _cardBorder),
                ),
                child: const Center(
                  child: Text('No transactions yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Plus Jakarta Sans',
                      )),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _buildTxnCard(transactions[i]),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTxnCard(Transactions txn) {
    final isPlus = txn.isPlus == true;
    final status = txn.status ?? '';

    Color statusColor;
    Color statusBg;
    switch (status.toLowerCase()) {
      case 'success':
        statusColor = const Color(0xFF065F46);
        statusBg = const Color(0xFF10B981).withValues(alpha: 0.12);
        break;
      case 'pending':
        statusColor = const Color(0xFFB45309);
        statusBg = const Color(0xFFF59E0B).withValues(alpha: 0.12);
        break;
      default:
        statusColor = const Color(0xFF991B1B);
        statusBg = const Color(0xFFEF4444).withValues(alpha: 0.12);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: (isPlus ? AppColors.success : AppColors.error)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPlus
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: isPlus ? AppColors.success : AppColors.error,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.description ?? txn.type ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: _titleColor,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  txn.tnx ?? '',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9AA5B4),
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
                '${isPlus ? '+' : '-'}${txn.amount ?? '0'}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isPlus ? AppColors.success : AppColors.error,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.isEmpty
                      ? ''
                      : status[0].toUpperCase() + status.substring(1),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────
  Widget _iconBtn(IconData icon) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      );

  Widget _avatarPlaceholder(String name) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A3A7A),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ),
      );

  Widget _walletBtn({
    required String label,
    required bool isPrimary,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isPrimary
                ? Colors.white
                : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: isPrimary
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isPrimary ? const Color(0xFF0D2150) : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ),
      );

  void _showExitDialog() {
    Get.dialog(CommonAlertDialog(
      title: 'Exit App',
      message: 'Are you sure you want to exit?',
      onConfirm: () => SystemNavigator.pop(),
      onCancel: () => Get.back(),
    ));
  }
}

// ── Data classes ──────────────────────────────────────────────────────────────
class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
  });
}

class _ServiceItem {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  _ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
  });
}
