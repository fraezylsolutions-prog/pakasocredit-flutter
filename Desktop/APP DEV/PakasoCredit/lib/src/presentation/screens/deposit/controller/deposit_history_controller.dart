import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/model/deposit_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepositHistoryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isInitialDataLoaded = false.obs;
  final RxBool isTransactionsLoading = false.obs;
  final RxBool isFilter = false.obs;
  final transactionIdController = TextEditingController();
  final dateRangeController = TextEditingController();
  final Rx<DepositHistoryModel> depositHistoryModel = DepositHistoryModel().obs;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);

  // Pagination properties
  final RxInt currentPage = 1.obs;
  final RxBool hasMorePages = true.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxBool isPageLoading = false.obs;
  final ScrollController scrollController = ScrollController();

  Future<void> fetchDepositHistories() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;

      final response = await Get.find<NetworkService>().get(
        endpoint:
            '${ApiPath.transactionsEndpoint}?page=$currentPage&type=Deposit, Manual Deposit',
      );

      if (response.status == Status.completed) {
        depositHistoryModel.value = DepositHistoryModel.fromJson(
          response.data!,
        );
        if (depositHistoryModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreDepositHistories() async {
    if (!hasMorePages.value || isPageLoading.value) return;
    isPageLoading.value = true;
    currentPage.value++;
    try {
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}&type=Deposit, Manual Deposit');

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
        final newDepositHistories = DepositHistoryModel.fromJson(
          response.data!,
        );

        if (newDepositHistories.data!.isEmpty) {
          hasMorePages.value = false;
        } else {
          depositHistoryModel.value.data!.addAll(newDepositHistories.data!);
          depositHistoryModel.refresh();
          if (newDepositHistories.data!.length < itemsPerPage.value) {
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

  Future<void> fetchDynamicDepositHistory() async {
    try {
      isTransactionsLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}&type=Deposit, Manual Deposit');
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
        depositHistoryModel.value = DepositHistoryModel.fromJson(
          response.data!,
        );
        if (depositHistoryModel.value.data!.isEmpty ||
            depositHistoryModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isTransactionsLoading.value = false;
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
