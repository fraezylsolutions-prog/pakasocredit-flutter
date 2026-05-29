import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/transfer_history_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransferHistoryFilterPopUp extends StatefulWidget {
  const TransferHistoryFilterPopUp({super.key});

  @override
  State<TransferHistoryFilterPopUp> createState() =>
      _TransferHistoryFilterPopUpState();
}

class _TransferHistoryFilterPopUpState
    extends State<TransferHistoryFilterPopUp> {
  final ThemeController themeController = Get.find<ThemeController>();
  final transferHistoryController = Get.find<TransferHistoryController>();

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _updateDateRangeText(TransferHistoryController controller) {
    if (controller.startDate.value != null &&
        controller.endDate.value != null) {
      final startDateFormatted = formatDate(controller.startDate.value!);
      final endDateFormatted = formatDate(controller.endDate.value!);
      controller.dateRangeController.text =
          "$startDateFormatted - $endDateFormatted";
      controller.startDateController.text = DateFormat(
        "yyyy-MM-dd",
      ).format(controller.startDate.value!);
      controller.endDateController.text = DateFormat(
        "yyyy-MM-dd",
      ).format(controller.endDate.value!);
    } else {
      controller.dateRangeController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      height: MediaQuery.of(context).size.height * 0.35,
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            themeController.isDarkMode.value
                ? AppColors.darkSecondary
                : AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "fundTransfer.transferHistory.filterDialog.filterText".trns(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
                Transform.translate(
                  offset: Offset(8, 0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      Get.back();
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          themeController.isDarkMode.value
                              ? AppColors.white.withValues(alpha: 0.05)
                              : AppColors.black.withValues(alpha: 0.05),
                      child: Image.asset(
                        PngAssets.commonCancelIcon,
                        width: 14,
                        fit: BoxFit.contain,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.white
                                : AppColors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextInputField(
                    controller: transferHistoryController.dateRangeController,
                    hintText:
                        "fundTransfer.transferHistory.filterDialog.dateLabel"
                            .trns(),
                    keyboardType: TextInputType.none,
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDialog<List<DateTime?>>(
                        context: context,
                        builder: (context) {
                          final initial = [
                            transferHistoryController.startDate.value,
                            transferHistoryController.endDate.value,
                          ];
                          List<DateTime?> selected = [...initial];

                          return AlertDialog(
                            insetPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 24,
                            ),
                            backgroundColor:
                                themeController.isDarkMode.value
                                    ? AppColors.darkSecondary
                                    : AppColors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            titlePadding: const EdgeInsets.fromLTRB(
                              20,
                              20,
                              20,
                              0,
                            ),
                            title: Text(
                              'fundTransfer.transferHistory.filterDialog.dateRange'
                                  .trns(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textPrimary,
                              ),
                            ),
                            content: SizedBox(
                              height: 350,
                              width: 350,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CalendarDatePicker2(
                                      config: CalendarDatePicker2Config(
                                        calendarType:
                                            CalendarDatePicker2Type.range,
                                        selectedDayHighlightColor:
                                            themeController.isDarkMode.value
                                                ? AppColors.darkPrimary
                                                : AppColors.primary,
                                        weekdayLabelTextStyle: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        dayTextStyle: const TextStyle(
                                          fontSize: 14,
                                        ),
                                        controlsTextStyle: TextStyle(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                        ),
                                      ),
                                      value: selected,
                                      onValueChanged: (dates) {
                                        selected = dates;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CommonElevatedButton(
                                          width: 90,
                                          height: 35,
                                          backgroundColor: AppColors.error,
                                          textColor: AppColors.white,
                                          borderRadius: 30,
                                          buttonName:
                                              "fundTransfer.transferHistory.filterDialog.dateRangeCancelButtonText"
                                                  .trns(),
                                          onPressed: () {
                                            Navigator.pop(context, null);
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        CommonElevatedButton(
                                          width: 90,
                                          height: 35,
                                          borderRadius: 30,
                                          buttonName:
                                              "fundTransfer.transferHistory.filterDialog.dateRangeApplyButtonText"
                                                  .trns(),
                                          onPressed:
                                              () => Navigator.pop(
                                                context,
                                                selected,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      if (picked != null &&
                          picked.isNotEmpty &&
                          picked[0] != null) {
                        final start = picked[0]!;
                        final end =
                            (picked.length > 1 && picked[1] != null)
                                ? picked[1]!
                                : picked[0]!;

                        transferHistoryController.startDate.value = start;
                        transferHistoryController.endDate.value = end;
                        _updateDateRangeText(transferHistoryController);
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              transferHistoryController.isFilter.value = false;
                              transferHistoryController.transactionIdController
                                  .clear();
                              transferHistoryController.dateRangeController
                                  .clear();
                              transferHistoryController.startDate.value = null;
                              transferHistoryController.endDate.value = null;
                              transferHistoryController.startDateController
                                  .clear();
                              transferHistoryController.endDateController
                                  .clear();
                              transferHistoryController
                                  .fetchDynamicTransferHistory();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color:
                                    themeController.isDarkMode.value
                                        ? Color(0xFF1C2E24)
                                        : AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkCardBorder
                                          : AppColors.textPrimary.withValues(
                                            alpha: 0.10,
                                          ),
                                ),
                              ),
                              child: Text(
                                "fundTransfer.transferHistory.filterDialog.resetButtonText"
                                    .trns(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkTextPrimary
                                              .withValues(alpha: 0.60)
                                          : AppColors.textPrimary.withValues(
                                            alpha: 0.60,
                                          ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              transferHistoryController.isFilter.value = true;
                              transferHistoryController
                                  .fetchDynamicTransferHistory();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkPrimary
                                        : AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "fundTransfer.transferHistory.filterDialog.searchButtonText"
                                    .trns(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.black
                                          : AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
