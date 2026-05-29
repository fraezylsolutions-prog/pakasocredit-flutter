import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/referral/controller/referral_tree_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferralTree extends StatefulWidget {
  const ReferralTree({super.key});

  @override
  State<ReferralTree> createState() => _ReferralTreeState();
}

class _ReferralTreeState extends State<ReferralTree> {
  final ThemeController themeController = Get.find<ThemeController>();
  final ReferralTreeController referralTreeController = Get.put(
    ReferralTreeController(),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: CommonAppBar(
                padding: 0,
                title: "referral.referralTree.title".trns(),
                isPopEnabled: false,
                showRightSideIcon: false,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (referralTreeController.isLoading.value) {
                  return const Center(child: CommonLoading());
                }

                return Container(
                  decoration: BoxDecoration(
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkSecondary
                            : AppColors.white,
                    gradient: AppStyles.linearGradient(),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withAlpha(10),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(500),
                      minScale: 0.5,
                      maxScale: 3.0,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: _buildEnhancedTree(
                          referralTreeController.referralTreeModel.value.data!,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTree(dynamic rootUser) {
    return _buildUserWithChildren(rootUser, isRoot: true);
  }

  Widget _buildUserWithChildren(dynamic user, {bool isRoot = false}) {
    final children = user.children;
    final hasChildren = children != null && children.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEnhancedUserNode(user, isRoot: isRoot),
        if (hasChildren) ...[
          Container(
            width: 2,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.primary,
                  themeController.isDarkMode.value
                      ? AppColors.darkPrimary.withAlpha(80)
                      : AppColors.primary.withAlpha(80),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _buildChildrenSection(children),
        ],
      ],
    );
  }

  Widget _buildChildrenSection(List<dynamic> children) {
    return Column(
      children: [
        if (children.length > 1)
          Container(
            height: 2,
            width: _calculateHorizontalLineWidth(children.length),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeController.isDarkMode.value
                      ? AppColors.darkPrimary.withAlpha(80)
                      : AppColors.primary.withAlpha(80),
                  themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.primary,
                  themeController.isDarkMode.value
                      ? AppColors.darkPrimary.withAlpha(80)
                      : AppColors.primary.withAlpha(80),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 60,
          runSpacing: 40,
          children:
              children
                  .map(
                    (child) => Column(
                      children: [
                        Container(
                          width: 2,
                          height: 30,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                themeController.isDarkMode.value
                                    ? AppColors.darkPrimary.withAlpha(80)
                                    : AppColors.primary.withAlpha(80),
                                themeController.isDarkMode.value
                                    ? AppColors.darkPrimary
                                    : AppColors.primary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildUserWithChildren(child),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  double _calculateHorizontalLineWidth(int childrenCount) {
    return (childrenCount - 1) * 180.0;
  }

  Widget _buildEnhancedUserNode(dynamic user, {bool isRoot = false}) {
    final name = user.name ?? 'N/A';
    final avatar = user.avatar;
    final hasChildren = user.children != null && user.children.isNotEmpty;

    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: isRoot ? 60 : 50,
                height: isRoot ? 60 : 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        isRoot
                            ? [
                              themeController.isDarkMode.value
                                  ? AppColors.darkPrimary
                                  : AppColors.primary,
                              themeController.isDarkMode.value
                                  ? AppColors.darkPrimary.withAlpha(200)
                                  : AppColors.primary.withAlpha(200),
                            ]
                            : [
                              themeController.isDarkMode.value
                                  ? AppColors.darkPrimary
                                  : themeController.isDarkMode.value
                                  ? AppColors.darkPrimary.withAlpha(200)
                                  : Colors.blue[400]!,
                              Colors.blue[600]!,
                            ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withAlpha(30),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkPrimary
                            : AppColors.white,
                  ),
                  child: ClipOval(
                    child:
                        avatar != null
                            ? Image.network(
                              avatar,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      _buildDefaultAvatar(isRoot),
                            )
                            : _buildDefaultAvatar(isRoot),
                  ),
                ),
              ),
              if (isRoot)
                Positioned(
                  top: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star,
                      size: 12,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(minWidth: 80, maxWidth: 140),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isRoot
                        ? [
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary.withAlpha(200)
                              : AppColors.primary.withAlpha(200),
                        ]
                        : [
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : Colors.blue[500]!,
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : Colors.blue[600]!,
                        ],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: (isRoot ? AppColors.primary : Colors.blue[500]!)
                      .withAlpha(80),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isRoot ? 13 : 11,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.black
                            : AppColors.white,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (hasChildren)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${user.children.length} referral${user.children.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 9,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.black
                                : Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isRoot) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'referral.referralTree.user.referrerBadge'.trns(),
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.black
                          : AppColors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(bool isRoot) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[300]!, Colors.grey[400]!],
        ),
      ),
      child: Icon(
        Icons.person,
        size: isRoot ? 30 : 25,
        color: Colors.grey[600],
      ),
    );
  }
}
