import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/model/card_transactions_model.dart';
import 'package:get/get.dart';

class CardTransactionsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<CardTransactionsData> cardTransactionsList =
      <CardTransactionsData>[].obs;

  Future<void> fetchCardTransactions({required String cardId}) async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.virtualCardsEndpoint}/transactions/$cardId",
      );
      if (response.status == Status.completed) {
        final cardTransactionsModel = CardTransactionsModel.fromJson(
          response.data!,
        );
        cardTransactionsList.clear();
        cardTransactionsList.assignAll(cardTransactionsModel.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCardTransactionsBySync({
    required String cardId,
    required String isSync,
  }) async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint:
            "${ApiPath.virtualCardsEndpoint}/transactions/$cardId?sync=$isSync",
      );
      if (response.status == Status.completed) {
        final cardTransactionsModel = CardTransactionsModel.fromJson(
          response.data!,
        );
        cardTransactionsList.clear();
        cardTransactionsList.assignAll(cardTransactionsModel.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
