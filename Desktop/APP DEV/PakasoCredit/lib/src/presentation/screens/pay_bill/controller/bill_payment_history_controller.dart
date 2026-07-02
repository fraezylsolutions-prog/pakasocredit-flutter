import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/model/bill_payment_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillPaymentHistoryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString siteCurrency = "".obs;
  final RxBool isInitialDataLoaded = false.obs;
  final RxBool isTransactionsLoading = false.obs;
  final transactionIdController = TextEditingController();
  final dateRangeController = TextEditingController();
  final RxBool isFilter = false.obs;
  final Rx<BillPaymentHistoryModel> billPaymentHistoryModel =
      BillPaymentHistoryModel().obs;
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
      loadMoreBillPaymentHistories();
    }
  }

  Future<void> fetchBillPaymentHistories() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;

      final response = await Get.find<NetworkService>().get(
        endpoint: '${ApiPath.payBillEndpoint}/history?page=$currentPage',
      );

      if (response.status == Status.completed) {
        billPaymentHistoryModel.value = BillPaymentHistoryModel.fromJson(
          response.data!,
        );
        if (billPaymentHistoryModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> loadMoreBillPaymentHistories() async {
    if (!hasMorePages.value || isPageLoading.value) return;
    isPageLoading.value = true;
    currentPage.value++;
    try {
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');
      final endpoint =
          '${ApiPath.payBillEndpoint}/history?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        final newBillPaymentHistories = BillPaymentHistoryModel.fromJson(
          response.data!,
        );

        if (newBillPaymentHistories.data!.isEmpty) {
          hasMorePages.value = false;
        } else {
          billPaymentHistoryModel.value.data!.addAll(
            newBillPaymentHistories.data!,
          );
          billPaymentHistoryModel.refresh();
          if (newBillPaymentHistories.data!.length < itemsPerPage.value) {
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
