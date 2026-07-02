import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/model/help_and_support/ticket_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketHistoryController extends GetxController {
  final RxBool isInitialDataLoaded = false.obs;
  RxList<DateTime?> selectedDates = <DateTime?>[null, null].obs;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isTicketsLoading = false.obs;
  final RxBool isFilter = false.obs;
  final Rx<TicketHistoryModel> ticketHistoryModel = TicketHistoryModel().obs;
  final dateRangeController = TextEditingController();
  final subjectController = TextEditingController();
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
    subjectController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        hasMorePages.value &&
        !isPageLoading.value) {
      loadMoreTickets();
    }
  }

  Future<void> fetchTickets() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;

      final response = await Get.find<NetworkService>().get(
        endpoint: '${ApiPath.ticketEndpoint}?page=$currentPage',
      );

      if (response.status == Status.completed) {
        ticketHistoryModel.value = TicketHistoryModel.fromJson(response.data!);
        if (ticketHistoryModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDynamicTickets() async {
    try {
      isTicketsLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');
      if (subjectController.text.isNotEmpty) {
        queryParams.add(
          'subject=${Uri.encodeComponent(subjectController.text)}',
        );
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      final endpoint = '${ApiPath.ticketEndpoint}?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        ticketHistoryModel.value = TicketHistoryModel.fromJson(response.data!);
        if (ticketHistoryModel.value.data!.isEmpty ||
            ticketHistoryModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isTicketsLoading.value = false;
    }
  }

  Future<void> loadMoreTickets() async {
    if (!hasMorePages.value || isPageLoading.value) return;
    isPageLoading.value = true;
    currentPage.value++;
    try {
      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');

      if (subjectController.text.isNotEmpty) {
        queryParams.add(
          'subject=${Uri.encodeComponent(subjectController.text)}',
        );
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      final endpoint = '${ApiPath.ticketEndpoint}?${queryParams.join('&')}';
      final response = await Get.find<NetworkService>().get(endpoint: endpoint);
      if (response.status == Status.completed) {
        final newTickets = TicketHistoryModel.fromJson(response.data!);

        if (newTickets.data!.isEmpty) {
          hasMorePages.value = false;
        } else {
          ticketHistoryModel.value.data!.addAll(newTickets.data!);
          ticketHistoryModel.refresh();
          if (newTickets.data!.length < itemsPerPage.value) {
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
    subjectController.clear();
    startDateController.clear();
    endDateController.clear();
    currentPage.value = 1;
    hasMorePages.value = true;
  }
}
