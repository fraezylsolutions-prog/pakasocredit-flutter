import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/reward/model/redeem_summery_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardSummeryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isInitialDataLoaded = false.obs;
  final RxBool isTransactionsLoading = false.obs;
  final Rx<RedeemSummeryModel> redeemSummeryModel = RedeemSummeryModel().obs;

  // Pagination properties
  final RxInt currentPage = 1.obs;
  final RxBool hasMorePages = true.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxBool isPageLoading = false.obs;
  final ScrollController scrollController = ScrollController();

  Future<void> fetchRedeemSummery() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;

      final response = await Get.find<NetworkService>().get(
        endpoint:
            '${ApiPath.transactionsEndpoint}?page=$currentPage&type=Reward Redeem',
      );

      if (response.status == Status.completed) {
        redeemSummeryModel.value = RedeemSummeryModel.fromJson(response.data!);
        if (redeemSummeryModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreRedeemSummery() async {
    if (!hasMorePages.value || isPageLoading.value) return;
    isPageLoading.value = true;
    currentPage.value++;
    try {
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}&type=Reward Redeem');
      final endpoint =
          '${ApiPath.transactionsEndpoint}?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        final newRedeemSummery = RedeemSummeryModel.fromJson(response.data!);

        if (newRedeemSummery.data!.isEmpty) {
          hasMorePages.value = false;
        } else {
          redeemSummeryModel.value.data!.addAll(newRedeemSummery.data!);
          redeemSummeryModel.refresh();
          if (newRedeemSummery.data!.length < itemsPerPage.value) {
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
    currentPage.value = 1;
    hasMorePages.value = true;
  }
}
