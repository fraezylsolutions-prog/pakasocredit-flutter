import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/pay_bill_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/airtime/airtime.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/bill_payment_history/bill_payment_history.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/cables/cables.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/data_bundle/data_bundle.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/electricity/electricity.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/intermet/internet.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/tool/tool.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayBillScreen extends StatelessWidget {
  const PayBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    Get.put(PayBillController());

    final List<Map<String, dynamic>> payBillList = [
      {
        "icon": PngAssets.payBillAirtimeIcon,
        "title": "payBill.airtime".trns(),
        "iconBGColor": AppColors.success.withValues(alpha: 0.10),
        "iconBGColor2": AppColors.success.withValues(alpha: 0.16),
        "pageNavigate": () {
          Get.find<NavigationController>().pushPage(Airtime(type: "airtime"));
        },
      },
      {
        "icon": PngAssets.payBillElectricityIcon,
        "title": "payBill.electricity".trns(),
        "iconBGColor": Color(0xFFFF6200).withValues(alpha: 0.10),
        "iconBGColor2": Color(0xFFFF6200).withValues(alpha: 0.16),
        "pageNavigate": () {
          Get.find<NavigationController>().pushPage(
            Electricity(type: "electricity"),
          );
        },
      },
      {
        "icon": PngAssets.payBillInternetIcon,
        "title": "payBill.internet".trns(),
        "iconBGColor": Color(0xFFEE10F2).withValues(alpha: 0.10),
        "iconBGColor2": Color(0xFFEE10F2).withValues(alpha: 0.16),
        "pageNavigate": () {
          Get.find<NavigationController>().pushPage(Internet(type: "internet"));
        },
      },
      {
        "icon": PngAssets.payBillDataBundleIcon,
        "title": "payBill.dataBundle".trns(),
        "iconBGColor": Color(0xFF2573BC).withValues(alpha: 0.10),
        "iconBGColor2": Color(0xFF2573BC).withValues(alpha: 0.16),
        "pageNavigate": () {
          Get.find<NavigationController>().pushPage(
            DataBundle(type: "data-bundle"),
          );
        },
      },
      {
        "icon": PngAssets.payBillCablesIcon,
        "title": "payBill.cables".trns(),
        "iconBGColor": Color(0xFF952097).withValues(alpha: 0.10),
        "iconBGColor2": Color(0xFF952097).withValues(alpha: 0.16),
        "pageNavigate": () {
          Get.find<NavigationController>().pushPage(Cables(type: "cables"));
        },
      },
      {
        "icon": PngAssets.payBillToolIcon,
        "title": "payBill.toll".trns(),
        "iconBGColor": Color(0xFF3120EC).withValues(alpha: 0.10),
        "iconBGColor2": Color(0xFF3120EC).withValues(alpha: 0.16),
        "pageNavigate": () {
          Get.find<NavigationController>().pushPage(Tool(type: "tool"));
        },
      },
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 16),
            CommonAppBar(
              title: "payBill.title".trns(),
              isPopEnabled: false,
              showRightSideIcon: true,
              rightSideIcon: PngAssets.commonClockIcon,
              pushPage: BillPaymentHistory(),
            ),
            SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: payBillList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final bill = payBillList[index];

                  return GestureDetector(
                    onTap: bill["pageNavigate"],
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkSecondary
                                : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: bill["iconBGColor"],
                            ),
                            child: Container(
                              margin: EdgeInsets.all(3),
                              width: 37.5,
                              height: 37.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: bill["iconBGColor2"],
                              ),
                              child: Container(
                                padding: EdgeInsets.all(7.5),
                                child: Image.asset(
                                  bill["icon"],
                                  width: 22.5,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            bill["title"],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
