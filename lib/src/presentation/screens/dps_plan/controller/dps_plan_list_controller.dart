import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/model/dps_plan_list_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DpsPlanListController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isInitialDataLoaded = false.obs;
  final RxBool isTransactionsLoading = false.obs;
  final RxBool isFilter = false.obs;
  final dpsIdController = TextEditingController();
  final dateRangeController = TextEditingController();
  final Rx<DpsPlanListModel> dpsPlanListModel = DpsPlanListModel().obs;
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

  Future<void> fetchDpsPlanLists() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final response = await Get.find<NetworkService>().get(
        endpoint: '${ApiPath.dpsEndpoint}/history?page=$currentPage',
      );
      if (response.status == Status.completed) {
        dpsPlanListModel.value = DpsPlanListModel.fromJson(response.data!);
        if (dpsPlanListModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreDpsPlanLists() async {
    if (!hasMorePages.value || isPageLoading.value) return;
    isPageLoading.value = true;
    currentPage.value++;
    try {
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');

      if (dpsIdController.text.isNotEmpty) {
        queryParams.add('dps_id=${Uri.encodeComponent(dpsIdController.text)}');
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      final endpoint =
          '${ApiPath.dpsEndpoint}/history?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        final newDpsPlanLists = DpsPlanListModel.fromJson(response.data!);

        if (newDpsPlanLists.data!.isEmpty) {
          hasMorePages.value = false;
        } else {
          dpsPlanListModel.value.data!.addAll(newDpsPlanLists.data!);
          dpsPlanListModel.refresh();
          if (newDpsPlanLists.data!.length < itemsPerPage.value) {
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

  Future<void> fetchDynamicDpsPlanLists() async {
    try {
      isTransactionsLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');
      if (dpsIdController.text.isNotEmpty) {
        queryParams.add('dps_id=${Uri.encodeComponent(dpsIdController.text)}');
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      final endpoint =
          '${ApiPath.dpsEndpoint}/history?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        dpsPlanListModel.value = DpsPlanListModel.fromJson(response.data!);
        if (dpsPlanListModel.value.data!.isEmpty ||
            dpsPlanListModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isTransactionsLoading.value = false;
    }
  }

  Future<void> deleteDps({required String dpsId}) async {
    try {
      final response = await Get.find<NetworkService>().delete(
        endpoint: "${ApiPath.dpsEndpoint}/$dpsId",
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchDpsPlanLists();
      }
    } finally {}
  }

  void resetFields() {
    isFilter.value = false;
    dateRangeController.clear();
    dpsIdController.clear();
    startDateController.clear();
    endDateController.clear();
    currentPage.value = 1;
    hasMorePages.value = true;
  }
}
