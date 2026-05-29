import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/model/notification/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxBool isMarkAllNotificationLoading = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isInitialDataLoaded = false.obs;
  final RxBool isTransactionsLoading = false.obs;
  final Rx<NotificationModel> notificationsModel = NotificationModel().obs;

  final RxInt currentPage = 1.obs;
  final RxBool hasMorePages = true.obs;
  final RxBool isPageLoading = false.obs;
  final ScrollController scrollController = ScrollController();
  final RxInt itemsPerPage = 10.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        hasMorePages.value &&
        !isPageLoading.value) {
      loadMoreTransactions();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> markAsReadNotification() async {
    isMarkAllNotificationLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.markAsReadNotificationEndpoint,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchNotifications();
      }
    } finally {
      isMarkAllNotificationLoading.value = false;
    }
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;

      final response = await Get.find<NetworkService>().get(
        endpoint: '${ApiPath.notificationsEndpoint}?page=${currentPage.value}',
      );

      if (response.status == Status.completed) {
        notificationsModel.value = NotificationModel.fromJson(response.data!);

        if (notificationsModel.value.meta != null) {
          hasMorePages.value =
              currentPage.value < notificationsModel.value.meta!.lastPage!;
        } else {
          final totalItems = _getTotalItemsCount(notificationsModel.value.data);
          hasMorePages.value = totalItems >= itemsPerPage.value;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreTransactions() async {
    if (!hasMorePages.value || isPageLoading.value) return;

    isPageLoading.value = true;
    currentPage.value++;

    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: '${ApiPath.notificationsEndpoint}?page=${currentPage.value}',
      );

      if (response.status == Status.completed) {
        final newNotifications = NotificationModel.fromJson(response.data!);

        if (newNotifications.data == null ||
            _getTotalItemsCount(newNotifications.data) == 0) {
          hasMorePages.value = false;
        } else {
          _mergeNotificationData(newNotifications.data!);

          if (newNotifications.meta != null) {
            hasMorePages.value =
                currentPage.value < newNotifications.meta!.lastPage!;
          } else {
            final totalNewItems = _getTotalItemsCount(newNotifications.data);
            hasMorePages.value = totalNewItems >= itemsPerPage.value;
          }
        }
      }
    } finally {
      isPageLoading.value = false;
    }
  }

  void _mergeNotificationData(NotificationData newData) {
    final currentData = notificationsModel.value.data;

    if (currentData == null) {
      notificationsModel.value.data = newData;
    } else {
      if (newData.today != null && newData.today!.isNotEmpty) {
        currentData.today ??= [];
        currentData.today!.addAll(newData.today!);
      }

      if (newData.yesterday != null && newData.yesterday!.isNotEmpty) {
        currentData.yesterday ??= [];
        currentData.yesterday!.addAll(newData.yesterday!);
      }

      if (newData.otherDates != null && newData.otherDates!.isNotEmpty) {
        currentData.otherDates ??= {};
        newData.otherDates!.forEach((date, notifications) {
          if (currentData.otherDates!.containsKey(date)) {
            currentData.otherDates![date]!.addAll(notifications);
          } else {
            currentData.otherDates![date] = notifications;
          }
        });
      }
    }

    notificationsModel.refresh();
  }

  int _getTotalItemsCount(NotificationData? data) {
    if (data == null) return 0;

    int count = 0;
    count += data.today?.length ?? 0;
    count += data.yesterday?.length ?? 0;

    if (data.otherDates != null) {
      for (var notifications in data.otherDates!.values) {
        count += notifications.length;
      }
    }

    return count;
  }

  void resetFields() {
    currentPage.value = 1;
    hasMorePages.value = true;
    notificationsModel.value = NotificationModel();
  }
}
