import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_plan_list_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoanPlanListController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isInitialDataLoaded = false.obs;
  final RxBool isTransactionsLoading = false.obs;
  final RxBool isFilter = false.obs;
  final loanIdController = TextEditingController();
  final dateRangeController = TextEditingController();
  final Rx<LoanPlanListModel> loanPlanListModel = LoanPlanListModel().obs;
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

  Future<void> fetchLoanPlanLists() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final response = await Get.find<NetworkService>().get(
        endpoint: '${ApiPath.loanEndpoint}/history?page=$currentPage',
      );
      if (response.status == Status.completed) {
        loanPlanListModel.value = LoanPlanListModel.fromJson(response.data!);
        if (loanPlanListModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreLoanPlanLists() async {
    if (!hasMorePages.value || isPageLoading.value) return;
    isPageLoading.value = true;
    currentPage.value++;
    try {
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');

      if (loanIdController.text.isNotEmpty) {
        queryParams.add(
          'loan_id=${Uri.encodeComponent(loanIdController.text)}',
        );
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      final endpoint =
          '${ApiPath.loanEndpoint}/history?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        final newLoanPlanLists = LoanPlanListModel.fromJson(response.data!);

        if (newLoanPlanLists.data!.isEmpty) {
          hasMorePages.value = false;
        } else {
          loanPlanListModel.value.data!.addAll(newLoanPlanLists.data!);
          loanPlanListModel.refresh();
          if (newLoanPlanLists.data!.length < itemsPerPage.value) {
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

  Future<void> fetchDynamicLoanPlanLists() async {
    try {
      isTransactionsLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');
      if (loanIdController.text.isNotEmpty) {
        queryParams.add(
          'loan_id=${Uri.encodeComponent(loanIdController.text)}',
        );
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      final endpoint =
          '${ApiPath.loanEndpoint}/history?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        loanPlanListModel.value = LoanPlanListModel.fromJson(response.data!);
        if (loanPlanListModel.value.data!.isEmpty ||
            loanPlanListModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isTransactionsLoading.value = false;
    }
  }

  Future<void> deleteLoan({required String loanId}) async {
    try {
      final Map<String, String> requestBody = {"loan_id": loanId};

      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.loanEndpoint}/cancel",
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchLoanPlanLists();
      }
    } finally {}
  }

  void resetFields() {
    isFilter.value = false;
    dateRangeController.clear();
    loanIdController.clear();
    startDateController.clear();
    endDateController.clear();
    currentPage.value = 1;
    hasMorePages.value = true;
  }
}
