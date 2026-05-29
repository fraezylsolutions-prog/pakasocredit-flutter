import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/model/fdr_plan_list_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FdrPlanListController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isInitialDataLoaded = false.obs;
  final RxBool isTransactionsLoading = false.obs;
  final RxBool isFilter = false.obs;
  final fdrIdController = TextEditingController();
  final dateRangeController = TextEditingController();
  final Rx<FdrPlanListModel> fdrPlanListModel = FdrPlanListModel().obs;
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

  Future<void> fetchFdrPlanLists() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final response = await Get.find<NetworkService>().get(
        endpoint: '${ApiPath.fdrEndpoint}/history?page=$currentPage',
      );
      if (response.status == Status.completed) {
        fdrPlanListModel.value = FdrPlanListModel.fromJson(response.data!);
        if (fdrPlanListModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreFdrPlanLists() async {
    if (!hasMorePages.value || isPageLoading.value) return;
    isPageLoading.value = true;
    currentPage.value++;
    try {
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');

      if (fdrIdController.text.isNotEmpty) {
        queryParams.add('fdr_id=${Uri.encodeComponent(fdrIdController.text)}');
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      final endpoint =
          '${ApiPath.fdrEndpoint}/history?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        final newFdrPlanLists = FdrPlanListModel.fromJson(response.data!);

        if (newFdrPlanLists.data!.isEmpty) {
          hasMorePages.value = false;
        } else {
          fdrPlanListModel.value.data!.addAll(newFdrPlanLists.data!);
          fdrPlanListModel.refresh();
          if (newFdrPlanLists.data!.length < itemsPerPage.value) {
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

  Future<void> fetchDynamicFdrPlanLists() async {
    try {
      isTransactionsLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');
      if (fdrIdController.text.isNotEmpty) {
        queryParams.add('fdr_id=${Uri.encodeComponent(fdrIdController.text)}');
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      final endpoint =
          '${ApiPath.fdrEndpoint}/history?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        fdrPlanListModel.value = FdrPlanListModel.fromJson(response.data!);
        if (fdrPlanListModel.value.data!.isEmpty ||
            fdrPlanListModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isTransactionsLoading.value = false;
    }
  }

  Future<void> deleteFdr({required String fdrId}) async {
    try {
      final response = await Get.find<NetworkService>().delete(
        endpoint: "${ApiPath.fdrEndpoint}/$fdrId",
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchFdrPlanLists();
      }
    } finally {}
  }

  void resetFields() {
    isFilter.value = false;
    dateRangeController.clear();
    fdrIdController.clear();
    startDateController.clear();
    endDateController.clear();
    currentPage.value = 1;
    hasMorePages.value = true;
  }
}
