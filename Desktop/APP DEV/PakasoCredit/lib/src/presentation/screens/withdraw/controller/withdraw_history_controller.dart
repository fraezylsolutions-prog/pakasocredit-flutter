import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/model/withdraw_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawHistoryController extends GetxController {
  final RxBool isInitialDataLoaded = false.obs;
  RxList<DateTime?> selectedDates = <DateTime?>[null, null].obs;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isTransactionsLoading = false.obs;
  final RxBool isFilter = false.obs;
  final Rx<WithdrawHistoryModel> withdrawHistoryModel =
      WithdrawHistoryModel().obs;
  final dateRangeController = TextEditingController();
  final transactionIdController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  // Pagination properties
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

  @override
  void onClose() {
    scrollController.dispose();
    dateRangeController.dispose();
    transactionIdController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        hasMorePages.value &&
        !isPageLoading.value) {
      loadMoreWithdrawHistory();
    }
  }

  Future<void> fetchWithdrawHistory() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;

      final response = await Get.find<NetworkService>().get(
        endpoint:
            '${ApiPath.transactionsEndpoint}?page=$currentPage&type=Withdraw, Withdraw Auto',
      );

      if (response.status == Status.completed) {
        withdrawHistoryModel.value = WithdrawHistoryModel.fromJson(
          response.data!,
        );
        if (withdrawHistoryModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDynamicWithdrawHistory() async {
    try {
      isTransactionsLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}&type=Withdraw, Withdraw Auto');
      if (transactionIdController.text.isNotEmpty) {
        queryParams.add(
          'transaction_id=${Uri.encodeComponent(transactionIdController.text)}',
        );
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      final endpoint =
          '${ApiPath.transactionsEndpoint}?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        withdrawHistoryModel.value = WithdrawHistoryModel.fromJson(
          response.data!,
        );
        if (withdrawHistoryModel.value.data!.isEmpty ||
            withdrawHistoryModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isTransactionsLoading.value = false;
    }
  }

  Future<void> loadMoreWithdrawHistory() async {
    if (!hasMorePages.value || isPageLoading.value) return;
    isPageLoading.value = true;
    currentPage.value++;
    try {
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}&type=Withdraw, Withdraw Auto');

      if (transactionIdController.text.isNotEmpty) {
        queryParams.add(
          'transaction_id=${Uri.encodeComponent(transactionIdController.text)}',
        );
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      final endpoint =
          '${ApiPath.transactionsEndpoint}?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        final newWithdrawHistory = WithdrawHistoryModel.fromJson(
          response.data!,
        );

        if (newWithdrawHistory.data!.isEmpty) {
          hasMorePages.value = false;
        } else {
          withdrawHistoryModel.value.data!.addAll(newWithdrawHistory.data!);
          withdrawHistoryModel.refresh();
          if (newWithdrawHistory.data!.length < itemsPerPage.value) {
            hasMorePages.value = false;
          }
        }
      }
    } catch (e) {
      currentPage.value--;
    } finally {
      isPageLoading.value = false;
    }
  }

  void resetFields() {
    isFilter.value = false;
    dateRangeController.clear();
    transactionIdController.clear();
    startDateController.clear();
    endDateController.clear();
    currentPage.value = 1;
    hasMorePages.value = true;
  }
}
