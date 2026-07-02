import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/controller/deposit_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _redirectProcessed = false;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });

                if (!_redirectProcessed) {
                  if (url.contains('success')) {
                    _redirectProcessed = true;
                    _handleSuccessPayment();
                  }

                  if (url.contains('cancel') || url.contains('fail')) {
                    _redirectProcessed = true;
                    _handleFailedPayment();
                  }
                }
              },
              onUrlChange: (UrlChange change) {
                final url = change.url ?? '';
                if (!_redirectProcessed) {
                  if (url.contains('success')) {
                    _redirectProcessed = true;
                    _handleSuccessPayment();
                  }

                  if (url.contains('cancel') || url.contains('fail')) {
                    _redirectProcessed = true;
                    _handleFailedPayment();
                  }
                }
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  void _handleSuccessPayment() {
    Get.back(
      result: {'success': true, 'message': 'Payment completed successfully'},
    );
    Fluttertoast.showToast(
      msg: "Payment completed!",
      backgroundColor: AppColors.success,
    );
  }

  void _handleFailedPayment() {
    Get.back(result: {'success': false, 'message': 'Payment was cancelled'});
    Fluttertoast.showToast(
      msg: "Payment was cancelled!",
      backgroundColor: AppColors.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) async {
        Get.back();
        final depositController = Get.find<DepositController>();
        depositController.clearFields();
      },
      child: Scaffold(
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) const CommonLoading(),
          ],
        ),
      ),
    );
  }
}
