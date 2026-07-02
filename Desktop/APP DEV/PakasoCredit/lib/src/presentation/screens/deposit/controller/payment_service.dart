import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:get/get.dart';

class PaymentService {
  Future<Map<String, dynamic>> makeDeposit({
    required String gatewayCode,
    required String amount,
    required String walletType,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "gateway_code": gatewayCode,
        "amount": amount,
        "wallet_type": walletType,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.depositEndpoint,
        data: requestBody,
      );

      if (response.status == Status.completed) {
        if (response.data != null &&
            response.data!['data'] != null &&
            response.data!['data']['redirect_url'] != null) {
          return {
            'success': true,
            'redirect_url': response.data!['data']['redirect_url'],
          };
        } else {
          return {'success': false, 'error': 'Invalid response data structure'};
        }
      } else {
        return {
          'success': false,
          'error': response.message ?? 'Deposit request failed',
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
