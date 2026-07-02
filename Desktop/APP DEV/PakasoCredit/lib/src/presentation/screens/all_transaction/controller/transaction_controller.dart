import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/presentation/screens/all_transaction/model/transaction_type_model.dart';
import 'package:pakaso_credit/src/presentation/screens/all_transaction/model/transactions_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TransactionController extends GetxController {
  final TokenService tokenService = Get.find<TokenService>();
  final RxBool isInitialDataLoaded = false.obs;
  final RxBool isTransactionDownload = false.obs;
  RxList<DateTime?> selectedDates = <DateTime?>[null, null].obs;
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isTransactionsLoading = false.obs;
  final RxBool isFilter = false.obs;
  final RxString transactionType = "".obs;
  final RxString transactionTypeValue = "".obs;
  final Rx<TransactionTypeModel> transactionTypeModel =
      TransactionTypeModel().obs;
  final Rx<TransactionsModel> transactionsModel = TransactionsModel().obs;
  final transactionTypeController = TextEditingController();
  final dateRangeController = TextEditingController();
  final transactionIdController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

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
    transactionTypeController.dispose();
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
      loadMoreTransactions();
    }
  }

  Future<void> fetchTransactionType() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.transactionTypeEndpoint,
      );
      if (response.status == Status.completed) {
        transactionTypeModel.value = TransactionTypeModel.fromJson(
          response.data!,
        );
      }
    } finally {}
  }

  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      hasMorePages.value = true;

      final response = await Get.find<NetworkService>().get(
        endpoint: '${ApiPath.transactionsEndpoint}?page=$currentPage',
      );

      if (response.status == Status.completed) {
        transactionsModel.value = TransactionsModel.fromJson(response.data!);
        if (transactionsModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDynamicTransactions() async {
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
      if (transactionTypeValue.value.isNotEmpty) {
        queryParams.add(
          'type=${Uri.encodeComponent(transactionTypeValue.value)}',
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
        transactionsModel.value = TransactionsModel.fromJson(response.data!);
        if (transactionsModel.value.data!.isEmpty ||
            transactionsModel.value.data!.length < itemsPerPage.value) {
          hasMorePages.value = false;
        }
      }
    } finally {
      isTransactionsLoading.value = false;
    }
  }

  Future<void> loadMoreTransactions() async {
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
      if (transactionTypeValue.value.isNotEmpty) {
        queryParams.add(
          'type=${Uri.encodeComponent(transactionTypeValue.value)}',
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
        final newTransactions = TransactionsModel.fromJson(response.data!);

        if (newTransactions.data!.isEmpty) {
          hasMorePages.value = false;
        } else {
          transactionsModel.value.data!.addAll(newTransactions.data!);
          transactionsModel.refresh();
          if (newTransactions.data!.length < itemsPerPage.value) {
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

  Future<void> transactionDownloadCsvFile() async {
    final dio = Dio();
    isTransactionDownload.value = true;
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 29) {
          if (!await _requestStoragePermission()) {
            return;
          }
        } else {
          if (!await _requestStoragePermission()) {
            return;
          }
        }
      } else if (Platform.isIOS) {
        if (!await _requestStoragePermission()) {
          return;
        }
      }

      final queryParams = <String>[];
      queryParams.add('page=${currentPage.value}');

      if (transactionIdController.text.isNotEmpty) {
        queryParams.add(
          'transaction_id=${Uri.encodeComponent(transactionIdController.text)}',
        );
      }
      if (transactionTypeValue.value.isNotEmpty) {
        queryParams.add(
          'type=${Uri.encodeComponent(transactionTypeValue.value)}',
        );
      }
      if (startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        queryParams.add('from_date=${startDateController.text}');
        queryParams.add('to_date=${endDateController.text}');
      }
      queryParams.add('export=true');
      final url =
          '${ApiPath.baseUrl}${ApiPath.transactionsEndpoint}?${queryParams.join('&')}';

      Directory directory;
      if (Platform.isAndroid) {
        directory = (await getExternalStorageDirectory())!;

        if (!await directory.exists()) {
          directory = (await getDownloadsDirectory())!;
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/transactions_$timestamp.csv';

      await dio.download(
        url,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          headers: {
            'Content-Type': 'text/csv',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenService.accessToken.value}',
          },
        ),
      );

      Fluttertoast.showToast(
        msg: "File downloaded to: $filePath",
        backgroundColor: AppColors.success,
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Download failed: ${e.toString()}",
        backgroundColor: AppColors.error,
      );
    } finally {
      isTransactionDownload.value = false;
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 30) {
        if (!await Permission.manageExternalStorage.request().isGranted) {
          openAppSettings();
          return false;
        }
      } else {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          openAppSettings();
          return false;
        }
      }
    } else if (Platform.isIOS) {
      var status = await Permission.photos.request();
      if (!status.isGranted) {
        openAppSettings();
        return false;
      }
    }
    return true;
  }

  void resetFields() {
    isFilter.value = false;
    transactionType.value = "";
    transactionTypeValue.value = "";
    transactionTypeController.clear();
    dateRangeController.clear();
    transactionIdController.clear();
    startDateController.clear();
    endDateController.clear();
    currentPage.value = 1;
    hasMorePages.value = true;
  }
}
