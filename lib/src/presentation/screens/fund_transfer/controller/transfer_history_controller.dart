import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/model/transfer_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferHistoryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isInitialDataLoaded = false.obs;
  final RxBool isTransactionsLoading = false.obs;
  final transactionIdController = TextEditingController();
  final dateRangeController = TextEditingController();
  final RxBool isFilter = false.obs;
  final Rx<TransferHistoryModel> transferHistoryModel =
      TransferHistoryModel().obs;
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
      loadMoreTransferHistories();
    }
  }

  Future<void> fetchTransferHistories() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;

      final response = await Get.find<NetworkService>().get(
        endpoint: '${ApiPath.transferEndpoint}?page=$currentPage',
      );

      if (response.status == Status.completed) {
        transferHistoryModel.value = TransferHistoryModel.fromJson(
          response.data!,
        );
        if (transferHistoryModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreTransferHistories() async {
    if (!hasMorePages.value || isPageLoading.value) return;
    isPageLoading.value = true;
    currentPage.value++;
    try {
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');

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
      final endpoint = '${ApiPath.transferEndpoint}?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        final newTransferHistories = TransferHistoryModel.fromJson(
          response.data!,
        );

        if (newTransferHistories.data!.isEmpty) {
          hasMorePages.value = false;
        } else {
          transferHistoryModel.value.data!.addAll(newTransferHistories.data!);
          transferHistoryModel.refresh();
          if (newTransferHistories.data!.length < itemsPerPage.value) {
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

  Future<void> fetchDynamicTransferHistory() async {
    try {
      isTransactionsLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');
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
      final endpoint = '${ApiPath.transferEndpoint}?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        transferHistoryModel.value = TransferHistoryModel.fromJson(
          response.data!,
        );
        if (transferHistoryModel.value.data!.isEmpty ||
            transferHistoryModel.value.data!.length < itemsPerPage.value) {
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
