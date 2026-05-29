import 'dart:math';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/notification/notification_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/model/notification/notification_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllNotification extends StatefulWidget {
  const AllNotification({super.key});

  @override
  State<AllNotification> createState() => _AllNotificationState();
}

class _AllNotificationState extends State<AllNotification>
    with WidgetsBindingObserver {
  final ThemeController themeController = Get.find<ThemeController>();
  late NotificationController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.put(NotificationController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchNotifications();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        final navigationController = Get.find<NavigationController>();
        navigationController.popPage();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                CommonAppBar(
                  title: "notification.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: false,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: RefreshIndicator(
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                    onRefresh: () => controller.fetchNotifications(),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.only(left: 14, right: 14, top: 10),
                      decoration: BoxDecoration(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkSecondary
                                : AppColors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        gradient: AppStyles.linearGradient(),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "notification.header".trns(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  controller.markAsReadNotification();
                                },
                                child: Text(
                                  "notification.mark_all_read".trns(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color:
                                        themeController.isDarkMode.value
                                            ? AppColors.darkPrimary
                                            : AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Divider(
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkCardBorder
                                    : Color(0xFFE4E8EE),
                            height: 0,
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Obx(() {
                              if (controller.isLoading.value) {
                                return CommonLoading();
                              }

                              final data =
                                  controller.notificationsModel.value.data;

                              if (data == null || _isDataEmpty(data)) {
                                return SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.5,
                                    child: CommonNoDataFound(
                                      message: "notification.no_data".trns(),
                                      showTryAgainButton: true,
                                      onTryAgain:
                                          () => controller.fetchNotifications(),
                                    ),
                                  ),
                                );
                              }

                              return ListView(
                                controller: controller.scrollController,
                                children: [
                                  if (data.today != null &&
                                      data.today!.isNotEmpty)
                                    _buildNotificationSection(
                                      "notification.sections.today".trns(),
                                      data.today!,
                                    ),

                                  if (data.yesterday != null &&
                                      data.yesterday!.isNotEmpty)
                                    _buildNotificationSection(
                                      "notification.sections.yesterday".trns(),
                                      data.yesterday!,
                                    ),

                                  if (data.otherDates != null)
                                    ...data.otherDates!.entries.map(
                                      (entry) => _buildNotificationSection(
                                        entry.key,
                                        entry.value,
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: controller.isPageLoading.value,
                child: Container(
                  color: AppColors.textPrimary.withValues(alpha: 0.3),
                  child: CommonLoading(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isDataEmpty(NotificationData data) {
    return (data.today?.isEmpty ?? true) &&
        (data.yesterday?.isEmpty ?? true) &&
        (data.otherDates?.isEmpty ?? true);
  }

  Widget _buildNotificationSection(
    String title,
    List<Notifications> notifications,
  ) {
    if (notifications.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
            ),
          ),
        ),
        ...notifications.map(
          (notification) => _buildNotificationItem(notification),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(Notifications notification) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: notification.isRead != true ? 8 : 0,
          ),
          decoration:
              notification.isRead != true
                  ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.grey.withValues(alpha: 0.08),
                  )
                  : null,
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _getRandomColor(),
                child: Image.asset(PngAssets.commonGiftIcon, width: 18),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color:
                            notification.isRead == true
                                ? themeController.isDarkMode.value
                                    ? AppColors.darkTextTertiary.withValues(
                                      alpha: 0.7,
                                    )
                                    : AppColors.textPrimary.withValues(
                                      alpha: 0.7,
                                    )
                                : themeController.isDarkMode.value
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      notification.createdAt ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
              if (notification.isRead == false)
                CircleAvatar(
                  backgroundColor:
                      themeController.isDarkMode.value
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                  radius: 4,
                ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Divider(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkCardBorder
                  : Color(0xFFE4E8EE),
          height: 1,
          endIndent: notification.isRead != true ? 0 : 8,
          indent: notification.isRead != true ? 0 : 8,
        ),
      ],
    );
  }

  Color _getRandomColor() {
    return Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      0.7,
    );
  }
}
