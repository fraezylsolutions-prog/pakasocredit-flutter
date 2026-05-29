import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/controller/fdr_details_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/view/fdr_plan_list/fdr_details/fdr_installment_list/fdr_installment_list.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/view/fdr_plan_list/fdr_details/sub_sections/fdr_decrease_pop_up.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/view/fdr_plan_list/fdr_details/sub_sections/fdr_increase_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FdrDetails extends StatefulWidget {
  final String fdrId;

  const FdrDetails({super.key, required this.fdrId});

  @override
  State<FdrDetails> createState() => _FdrDetailsState();
}

class _FdrDetailsState extends State<FdrDetails> {
  final ThemeController themeController = Get.find<ThemeController>();
  final FdrDetailsController fdrDetailsController = Get.put(
    FdrDetailsController(),
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    fdrDetailsController.isLoading.value = true;
    await fdrDetailsController.fetchFdrDetails(fdrId: widget.fdrId);
    await fdrDetailsController.loadSiteCurrency();
    fdrDetailsController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
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
              title: "fdrPlan.fdrPlanList.fdrDetails.title".trns(),
              isPopEnabled: false,
              showRightSideIcon: true,
              rightSideIcon: PngAssets.commonClockIcon,
              onPressed: () {
                Get.find<NavigationController>().pushPage(
                  FdrInstallmentList(fdrId: widget.fdrId),
                );
              },
            ),
            SizedBox(height: 30),
            Expanded(
              child: Obx(() {
                final fdrData = fdrDetailsController.fdrDetailsModel.value.data;

                if (fdrDetailsController.isLoading.value) {
                  return const CommonLoading();
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Visibility(
                          visible: fdrData?.status == "running",
                          child: _buildActionButtons(),
                        ),
                        if (fdrData?.status == "running") SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkSecondary
                                    : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkCardBorder
                                      : Color(0xFFE6E6E6),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildDetailsValueSection(
                                title:
                                    "fdrPlan.fdrPlanList.fdrDetails.fields.planName"
                                        .trns(),
                                value: fdrData?.fdrName ?? "N/A",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "fdrPlan.fdrPlanList.fdrDetails.fields.fdrId"
                                        .trns(),
                                value: fdrData?.fdrId ?? "N/A",
                                valueColor: AppColors.error,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "fdrPlan.fdrPlanList.fdrDetails.fields.status"
                                        .trns(),
                                value:
                                    fdrData?.status == "running"
                                        ? "fdrPlan.fdrPlanList.fdrDetails.status.running"
                                            .trns()
                                        : fdrData?.status == "completed"
                                        ? "fdrPlan.fdrPlanList.fdrDetails.status.completed"
                                            .trns()
                                        : fdrData?.status == "closed"
                                        ? "fdrPlan.fdrPlanList.fdrDetails.status.closed"
                                            .trns()
                                        : "N/A",
                                valueColor:
                                    fdrData?.status == "running"
                                        ? themeController.isDarkMode.value
                                            ? AppColors.darkPrimary
                                            : AppColors.primary
                                        : fdrData?.status == "completed"
                                        ? AppColors.success
                                        : fdrData?.status == "closed"
                                        ? AppColors.error
                                        : null,
                                isValueRadius: true,
                                radiusColor:
                                    fdrData?.status == "running"
                                        ? themeController.isDarkMode.value
                                            ? AppColors.darkPrimary.withValues(
                                              alpha: 0.1,
                                            )
                                            : AppColors.primary.withValues(
                                              alpha: 0.1,
                                            )
                                        : fdrData?.status == "completed"
                                        ? AppColors.success.withValues(
                                          alpha: 0.1,
                                        )
                                        : fdrData?.status == "closed"
                                        ? AppColors.error.withValues(alpha: 0.1)
                                        : null,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "fdrPlan.fdrPlanList.fdrDetails.fields.amount"
                                        .trns(),
                                value: fdrData?.amount ?? "N/A",
                                valueColor: AppColors.error,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "fdrPlan.fdrPlanList.fdrDetails.fields.profit"
                                        .trns(),
                                value:
                                    "${fdrData?.profit ?? "N/A"} (${fdrData!.profitPeriod ?? "N/A"})",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "fdrPlan.fdrPlanList.fdrDetails.fields.totalReturns"
                                        .trns(),
                                value: fdrData.totalReturns ?? "N/A",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "fdrPlan.fdrPlanList.fdrDetails.fields.returnReceive"
                                        .trns(),
                                value: fdrData.givenReturns ?? "N/A",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "fdrPlan.fdrPlanList.fdrDetails.fields.nextReceive"
                                        .trns(),
                                value: fdrData.nextReceiveDate ?? "N/A",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "fdrPlan.fdrPlanList.fdrDetails.fields.totalProfit"
                                        .trns(),
                                value: fdrData.totalProfit ?? "N/A",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDividerSection() {
    return Column(
      children: [
        SizedBox(height: 16),
        Divider(
          height: 0,
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkCardBorder
                  : Color(0xFF030306).withValues(alpha: 0.06),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDetailsValueSection({
    required String title,
    required String value,
    Color? valueColor,
    bool? isValueRadius,
    Color? radiusColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title:",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
          ),
        ),
        Container(
          padding:
              isValueRadius == true
                  ? EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                  : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isValueRadius == true ? 30 : 0),
            color: isValueRadius == true ? radiusColor : null,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color:
                  valueColor ??
                  (themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Obx(() {
      final fdrData = fdrDetailsController.fdrDetailsModel.value.data;
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: fdrData?.isIncrease == true,
            child: CommonElevatedButton(
              width: 100,
              height: 32,
              fontSize: 12,
              buttonName:
                  "fdrPlan.fdrPlanList.fdrDetails.buttons.increase".trns(),
              borderRadius: 8,
              onPressed: () {
                Get.dialog(FdrIncreasePopUp());
              },
              leftIcon: Icon(
                Icons.add,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.black
                        : AppColors.white,
              ),
              iconSpacing: 4,
            ),
          ),
          SizedBox(width: 10),
          Visibility(
            visible: fdrData?.isDecrease == true,
            child: CommonElevatedButton(
              width: 100,
              height: 32,
              fontSize: 12,
              buttonName:
                  "fdrPlan.fdrPlanList.fdrDetails.buttons.decrease".trns(),
              borderRadius: 8,
              onPressed: () {
                Get.dialog(FdrDecreasePopUp());
              },
              leftIcon: Icon(Icons.remove, color: AppColors.white),
              iconSpacing: 4,
              backgroundColor: AppColors.error,
              textColor: AppColors.white,
            ),
          ),
        ],
      );
    });
  }
}
