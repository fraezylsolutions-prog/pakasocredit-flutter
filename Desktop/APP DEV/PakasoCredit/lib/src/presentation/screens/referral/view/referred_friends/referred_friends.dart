import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/referral/controller/referred_friends_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReferredFriends extends StatelessWidget {
  const ReferredFriends({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final ReferredFriendsController referredFriendsController = Get.put(
      ReferredFriendsController(),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 30),
          child: Column(
            children: [
              SizedBox(height: 16),
              CommonAppBar(
                padding: 0,
                title: "referral.referredFriends.title".trns(),
                isPopEnabled: false,
                showRightSideIcon: false,
              ),
              Expanded(
                child: RefreshIndicator(
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                  onRefresh:
                      () => referredFriendsController.fetchReferredFriends(),
                  child: Obx(() {
                    if (referredFriendsController.isLoading.value) {
                      return const CommonLoading();
                    }

                    if (referredFriendsController.referredFriendsList.isEmpty) {
                      return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: CommonNoDataFound(
                            message: "referral.referredFriends.noData".trns(),
                            showTryAgainButton: true,
                            onTryAgain:
                                () =>
                                    referredFriendsController
                                        .fetchReferredFriends(),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.only(top: 30, bottom: 20),
                      itemBuilder: (context, index) {
                        final referredFriend =
                            referredFriendsController
                                .referredFriendsList[index];

                        return Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkSecondary
                                    : AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Avatar Section
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        themeController.isDarkMode.value
                                            ? AppColors.darkPrimary.withValues(
                                              alpha: 0.1,
                                            )
                                            : AppColors.primary.withValues(
                                              alpha: 0.1,
                                            ),
                                    width: 1,
                                  ),
                                ),
                                child: ClipOval(
                                  child:
                                      referredFriend.avatar != null
                                          ? Image.network(
                                            referredFriend.avatar!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (_, __, ___) =>
                                                    _buildDefaultAvatar(),
                                          )
                                          : _buildDefaultAvatar(),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      referredFriend.username != null
                                          ? referredFriend.username![0]
                                                  .toUpperCase() +
                                              referredFriend.username!
                                                  .substring(1)
                                                  .toLowerCase()
                                          : "N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color:
                                            themeController.isDarkMode.value
                                                ? AppColors.darkTextPrimary
                                                : AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.account_balance_wallet,
                                          size: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextTertiary
                                                  : AppColors.textTertiary,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "referral.referredFriends.userInfo.portfolio"
                                              .trnsFormat({
                                                "portfolio":
                                                    referredFriend.portfolio ??
                                                    "referral.referredFriends.userInfo.noPortfolioText"
                                                        .trns(),
                                              }),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkTextTertiary
                                                    : AppColors.textTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          referredFriend.createdAt != null
                                              ? "${"referral.referredFriends.userInfo.joinedText".trns()} ${referredFriend.createdAt!}"
                                              : "N/A",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                            color:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      referredFriend.status == true
                                          ? AppColors.success.withValues(
                                            alpha: 0.1,
                                          )
                                          : AppColors.error.withValues(
                                            alpha: 0.1,
                                          ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        referredFriend.status == true
                                            ? AppColors.success.withValues(
                                              alpha: 0.3,
                                            )
                                            : AppColors.error.withValues(
                                              alpha: 0.3,
                                            ),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  referredFriend.status == true
                                      ? "referral.referredFriends.status.active"
                                          .trns()
                                      : "referral.referredFriends.status.inactive"
                                          .trns(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color:
                                        referredFriend.status == true
                                            ? AppColors.success
                                            : AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder:
                          (context, index) => SizedBox(height: 16),
                      itemCount:
                          referredFriendsController.referredFriendsList.length,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          width: 130,
          height: 40,
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            backgroundColor:
                themeController.isDarkMode.value
                    ? AppColors.darkPrimary
                    : AppColors.primary,
            onPressed:
                () => Get.find<NavigationController>().pushNamed(
                  BaseRoute.referralTree,
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.black
                          : AppColors.white,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  'Referral Tree',
                  style: TextStyle(
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.black
                            : AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Center(child: Icon(Icons.person, color: AppColors.primary)),
    );
  }
}
