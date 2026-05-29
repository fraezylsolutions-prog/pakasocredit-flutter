import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/controller/dps_details_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/view/dps_plan_list/dps_details/installments_list/installments_list.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/view/dps_plan_list/dps_details/sub_sections/dps_decrease_pop_up.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/view/dps_plan_list/dps_details/sub_sections/dps_increase_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DpsDetails extends StatefulWidget {
  final String dpsId;

  const DpsDetails({super.key, required this.dpsId});

  @override
  State<DpsDetails> createState() => _DpsDetailsState();
}

class _DpsDetailsState extends State<DpsDetails> {
  final ThemeController themeController = Get.find<ThemeController>();
  final DpsDetailsController dpsDetailsController = Get.put(
    DpsDetailsController(),
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    dpsDetailsController.isLoading.value = true;
    await dpsDetailsController.fetchDpsDetails(dpsId: widget.dpsId);
    await dpsDetailsController.loadSiteCurrency();
    dpsDetailsController.isLoading.value = false;
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
              title: "dpsPlan.dpsPlanList.dpsDetails.title".trns(),
              isPopEnabled: false,
              showRightSideIcon: true,
              rightSideIcon: PngAssets.commonClockIcon,
              onPressed: () {
                Get.find<NavigationController>().pushPage(
                  InstallmentsList(dpsId: widget.dpsId),
                );
              },
            ),
            SizedBox(height: 30),
            Expanded(
              child: Obx(() {
                final dpsData = dpsDetailsController.dpsDetailsModel.value.data;

                if (dpsDetailsController.isLoading.value) {
                  return const CommonLoading();
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Visibility(
                          visible:
                              dpsData?.status == "running" ||
                              dpsData?.status == "due",
                          child: _buildActionButtons(),
                        ),
                        if (dpsData?.status == "running" ||
                            dpsData?.status == "due")
                          SizedBox(height: 20),
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
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.planName"
                                        .trns(),
                                value: dpsData?.planName ?? "N/A",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.dpsId"
                                        .trns(),
                                value: dpsData?.dpsId ?? "N/A",
                                valueColor: AppColors.error,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.status"
                                        .trns(),
                                value:
                                    dpsData?.status == "running"
                                        ? "dpsPlan.dpsPlanList.dpsDetails.status.running"
                                            .trns()
                                        : dpsData?.status == "due"
                                        ? "dpsPlan.dpsPlanList.dpsDetails.status.due"
                                            .trns()
                                        : dpsData?.status == "closed"
                                        ? "dpsPlan.dpsPlanList.dpsDetails.status.closed"
                                            .trns()
                                        : dpsData?.status == "mature"
                                        ? "dpsPlan.dpsPlanList.dpsDetails.status.mature"
                                            .trns()
                                        : "N/A",
                                valueColor:
                                    dpsData?.status == "running"
                                        ? themeController.isDarkMode.value
                                            ? AppColors.darkPrimary
                                            : AppColors.primary
                                        : dpsData?.status == "due"
                                        ? AppColors.warning
                                        : dpsData?.status == "closed"
                                        ? AppColors.error
                                        : dpsData?.status == "mature"
                                        ? AppColors.success
                                        : null,
                                isValueRadius: true,
                                radiusColor:
                                    dpsData?.status == "running"
                                        ? themeController.isDarkMode.value
                                            ? AppColors.darkPrimary.withValues(
                                              alpha: 0.1,
                                            )
                                            : AppColors.primary.withValues(
                                              alpha: 0.1,
                                            )
                                        : dpsData?.status == "due"
                                        ? AppColors.warning.withValues(
                                          alpha: 0.1,
                                        )
                                        : dpsData?.status == "closed"
                                        ? AppColors.error.withValues(alpha: 0.1)
                                        : dpsData?.status == "mature"
                                        ? AppColors.success.withValues(
                                          alpha: 0.1,
                                        )
                                        : null,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.interestRate"
                                        .trns(),
                                value: "${dpsData?.interestRate ?? 0} %",
                                valueColor: AppColors.error,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.perInstallment"
                                        .trns(),
                                value:
                                    "${dpsData?.perInstallment ?? "N/A"} (${"dpsPlan.dpsPlanList.dpsDetails.fields.everyText".trns()} ${dpsData?.installmentInterval ?? 0} ${"dpsPlan.dpsPlanList.dpsDetails.fields.daysText".trns()})",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.totalInstallments"
                                        .trns(),
                                value:
                                    "${dpsData?.totalInstallment ?? 0} ${"dpsPlan.dpsPlanList.dpsDetails.fields.timesText".trns()}",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.givenInstallments"
                                        .trns(),
                                value:
                                    dpsData!.givenInstallment?.toString() ??
                                    "0",
                                isValueRadius: true,
                                radiusColor:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkPrimary.withValues(
                                          alpha: 0.1,
                                        )
                                        : AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.nextInstallment"
                                        .trns(),
                                value: dpsData.nextInstallment ?? "N/A",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.defermentCharge"
                                        .trns(),
                                value:
                                    "${dpsData.defermentCharge ?? "N/A"} / ${dpsData.defermentDays ?? 0} ${dpsData.defermentDays! > 1 ? "dpsPlan.dpsPlanList.dpsDetails.fields.daysText".trns() : "dpsPlan.dpsPlanList.dpsDetails.fields.dayText".trns()}",
                                valueColor: AppColors.error,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.profitAmount"
                                        .trns(),
                                value: dpsData.profitAmount ?? "N/A",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "dpsPlan.dpsPlanList.dpsDetails.fields.maturedAmount"
                                        .trns(),
                                value: dpsData.totalMatureAmount ?? "N/A",
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
      final dpsData = dpsDetailsController.dpsDetailsModel.value.data;
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: dpsData?.isIncrease == true,
            child: CommonElevatedButton(
              width: 100,
              height: 32,
              fontSize: 12,
              buttonName:
                  "dpsPlan.dpsPlanList.dpsDetails.actions.increase".trns(),
              borderRadius: 8,
              onPressed: () {
                Get.dialog(DpsIncreasePopUp());
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
          if (dpsData?.isDecrease == true) SizedBox(width: 10),
          Visibility(
            visible: dpsData?.isDecrease == true,
            child: CommonElevatedButton(
              width: 100,
              height: 32,
              fontSize: 12,
              buttonName:
                  "dpsPlan.dpsPlanList.dpsDetails.actions.decrease".trns(),
              borderRadius: 8,
              onPressed: () {
                Get.dialog(DpsDecreasePopUp());
              },
              textColor: AppColors.white,
              leftIcon: Icon(Icons.remove, color: AppColors.white),
              iconSpacing: 4,
              backgroundColor: AppColors.error,
            ),
          ),
        ],
      );
    });
  }
}
