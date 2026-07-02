import 'dart:async';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/helo_and_support/ticket_history_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/model/help_and_support/ticket_history_model.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/help_and_support/replay_ticket/replay_ticket.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/help_and_support/sub_sections/open_new_ticket_dialog_section.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/help_and_support/sub_sections/ticket_history_filter_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport>
    with WidgetsBindingObserver {
  final ThemeController themeController = Get.find<ThemeController>();
  late TicketHistoryController ticketHistoryController;
  late ScrollController _scrollController;

  Timer? _debounce;
  final Duration debounceDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ticketHistoryController = Get.put(TicketHistoryController());
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_scrollListener);
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> refreshData() async {
    ticketHistoryController.isLoading.value = true;
    await ticketHistoryController.fetchTickets();
    ticketHistoryController.isLoading.value = false;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        ticketHistoryController.hasMorePages.value &&
        !ticketHistoryController.isPageLoading.value) {
      ticketHistoryController.loadMoreTickets();
    }
  }

  Future<void> loadData() async {
    if (!ticketHistoryController.isInitialDataLoaded.value) {
      ticketHistoryController.isLoading.value = true;
      await ticketHistoryController.fetchTickets();
      ticketHistoryController.isLoading.value = false;
      ticketHistoryController.isInitialDataLoaded.value = true;
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(debounceDuration, () {
      ticketHistoryController.fetchDynamicTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        ticketHistoryController.resetFields();
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Obx(
          () => Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 16),
                  CommonAppBar(
                    title: "help_and_support.title".trns(),
                    isPopEnabled: false,
                    showRightSideIcon: true,
                    rightSideIcon: PngAssets.commonAddCircleIcon,
                    onPressed: () => showOpenNewTicketDialog(),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: RefreshIndicator(
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                      onRefresh: () => refreshData(),
                      child:
                          ticketHistoryController.isLoading.value
                              ? CommonLoading()
                              : Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkSecondary
                                              : AppColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CommonTextInputField(
                                            onChanged: _onSearchChanged,
                                            borderRadius: 8,
                                            controller:
                                                ticketHistoryController
                                                    .subjectController,
                                            hintText:
                                                "help_and_support.search_field_hint"
                                                    .trns(),
                                            keyboardType: TextInputType.text,
                                            showPrefixIcon: true,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(
                                                13.0,
                                              ),
                                              child: Image.asset(
                                                PngAssets.commonSearchIcon,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors
                                                            .darkTextPrimary
                                                        : AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Material(
                                          color: AppColors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            onTap: () {
                                              Get.bottomSheet(
                                                TicketHistoryFilterPopUp(),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(11),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? Color(0xFF5D6765)
                                                          : AppColors
                                                              .textPrimary
                                                              .withValues(
                                                                alpha: 0.10,
                                                              ),
                                                ),
                                              ),
                                              child: Image.asset(
                                                PngAssets.commonFilterIcon,
                                                width: 20,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors.white
                                                        : AppColors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ticketHistoryController
                                          .ticketHistoryModel
                                          .value
                                          .data!
                                          .isEmpty
                                      ? Expanded(
                                        child: SingleChildScrollView(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          child: SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.5,
                                            child: CommonNoDataFound(
                                              message:
                                                  "help_and_support.no_tickets"
                                                      .trns(),
                                              showTryAgainButton: true,
                                              onTryAgain: () => refreshData(),
                                            ),
                                          ),
                                        ),
                                      )
                                      : Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.separated(
                                                physics:
                                                    AlwaysScrollableScrollPhysics(),
                                                controller: _scrollController,
                                                padding: EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  bottom: 20,
                                                ),
                                                itemBuilder: (context, index) {
                                                  final TicketHistoryData
                                                  ticket =
                                                      ticketHistoryController
                                                          .ticketHistoryModel
                                                          .value
                                                          .data![index];

                                                  return TicketCard(
                                                    ticketUid:
                                                        ticket.uuid.toString(),
                                                    title:
                                                        ticket.title ?? "N/A",
                                                    message:
                                                        ticket.message ?? "N/A",
                                                    date:
                                                        ticket.createdAt ??
                                                        "N/A",
                                                    priority:
                                                        ticket.priority ??
                                                        "N/A",
                                                    status:
                                                        ticket.status ?? "N/A",
                                                    statusColor:
                                                        ticket.status == "Open"
                                                            ? AppColors.success
                                                                .withValues(
                                                                  alpha: 0.15,
                                                                )
                                                            : ticket.status ==
                                                                "Closed"
                                                            ? AppColors.error
                                                                .withValues(
                                                                  alpha: 0.15,
                                                                )
                                                            : AppColors
                                                                .transparent,
                                                    statusTextColor:
                                                        ticket.status == "Open"
                                                            ? AppColors.success
                                                            : ticket.status ==
                                                                "Closed"
                                                            ? AppColors.error
                                                            : AppColors
                                                                .transparent,
                                                    priorityColor:
                                                        themeController
                                                                .isDarkMode
                                                                .value
                                                            ? Color(0xFF1C2E24)
                                                            : Color(0xFFE2D8FB),
                                                  );
                                                },
                                                separatorBuilder: (
                                                  context,
                                                  index,
                                                ) {
                                                  return SizedBox(height: 10);
                                                },
                                                itemCount:
                                                    ticketHistoryController
                                                        .ticketHistoryModel
                                                        .value
                                                        .data!
                                                        .length,
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
              Visibility(
                visible:
                    ticketHistoryController.isTicketsLoading.value ||
                    ticketHistoryController.isPageLoading.value,
                child: Container(
                  color: AppColors.textPrimary.withValues(alpha: 0.3),
                  child: CommonLoading(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showOpenNewTicketDialog() {
    Get.dialog(OpenNewTicketDialogSection());
  }
}

class TicketCard extends StatelessWidget {
  final String ticketUid;
  final String title;
  final String message;
  final String date;
  final String priority;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final Color priorityColor;

  const TicketCard({
    super.key,
    required this.title,
    required this.message,
    required this.date,
    required this.priority,
    required this.status,
    required this.statusColor,
    required this.priorityColor,
    required this.statusTextColor,
    required this.ticketUid,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:
            themeController.isDarkMode.value
                ? AppColors.darkSecondary
                : AppColors.white,
        border: Border.all(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkCardBorder
                  : Color(0xFFE0E0E0).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 12,
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextTertiary
                      : AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag,
                          size: 14,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.darkTextPrimary
                                  : Color(0xFF6C3BEC),
                        ),
                        SizedBox(width: 4),
                        Text(
                          priority,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : Color(0xFF6C3BEC),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CommonElevatedButton(
                borderRadius: 8,
                fontSize: 11,
                buttonName: "help_and_support.view_button".trns(),
                onPressed: () {
                  Get.find<NavigationController>().pushPage(
                    ReplayTicket(ticketUid: ticketUid),
                  );
                },
                width: 65,
                height: 27,
                iconSpacing: 3,
                leftIcon: Image.asset(
                  PngAssets.commonEyeIcon,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.black
                          : AppColors.white,
                  width: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
