import 'dart:io';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/image_picker/multiple_image_picker_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/bottom_sheet/multiple_image_picker_bottom_sheet.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/helo_and_support/replay_ticket_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ReplayTicket extends StatefulWidget {
  final String ticketUid;

  const ReplayTicket({super.key, required this.ticketUid});

  @override
  State<ReplayTicket> createState() => _ReplayTicketState();
}

class _ReplayTicketState extends State<ReplayTicket> {
  final ThemeController themeController = Get.find<ThemeController>();
  final ReplayTicketController replayTicketController = Get.put(
    ReplayTicketController(),
  );

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    replayTicketController.isLoading.value = true;
    await replayTicketController.fetchTicketMessage(
      ticketUid: widget.ticketUid,
    );
    replayTicketController.isLoading.value = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    if (replayTicketController.messageController.text.isNotEmpty) {
      await replayTicketController.submitReplayTicket(
        ticketUid: widget.ticketUid,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } else {
      Fluttertoast.showToast(
        msg: "help_and_support.replay_ticket.message_required".trns(),
        backgroundColor: AppColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Stack(
        children: [
          Obx(() {
            final isLoading = replayTicketController.isLoading.value;

            if (isLoading) {
              return const CommonLoading();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                CommonAppBar(
                  title: "help_and_support.replay_ticket.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: false,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child:
                        replayTicketController
                                    .ticketMessageModel
                                    .value
                                    .data
                                    ?.ticket
                                    ?.status ==
                                "Open"
                            ? CommonElevatedButton(
                              width: 115,
                              height: 30,
                              fontSize: 12,
                              borderRadius: 30,
                              backgroundColor: AppColors.error,
                              leftIcon: Image.asset(
                                PngAssets.commonCancelIcon,
                                width: 14,
                              ),
                              textColor: AppColors.white,
                              iconSpacing: 3,
                              buttonName:
                                  "help_and_support.replay_ticket.close_ticket"
                                      .trns(),
                              onPressed:
                                  () =>
                                      replayTicketController.submitTicketAction(
                                        ticketUid: widget.ticketUid,
                                      ),
                            )
                            : replayTicketController
                                    .ticketMessageModel
                                    .value
                                    .data
                                    ?.ticket
                                    ?.status ==
                                "Closed"
                            ? CommonElevatedButton(
                              width: 125,
                              height: 30,
                              fontSize: 12,
                              borderRadius: 30,
                              backgroundColor:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkPrimary
                                      : AppColors.primary,
                              leftIcon: Image.asset(
                                PngAssets.commonTickIcon,
                                width: 16,
                                color:
                                    themeController.isDarkMode.value
                                        ? AppColors.black
                                        : AppColors.white,
                              ),
                              iconSpacing: 3,
                              buttonName:
                                  "help_and_support.replay_ticket.reopen_ticket"
                                      .trns(),
                              onPressed:
                                  () =>
                                      replayTicketController.submitTicketAction(
                                        ticketUid: widget.ticketUid,
                                      ),
                            )
                            : SizedBox(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: RefreshIndicator(
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                      onRefresh: () => loadData(),
                      child: Obx(() {
                        final model =
                            replayTicketController.ticketMessageModel.value;
                        final messages = model.data?.messages ?? [];
                        final ticket = model.data?.ticket;

                        return SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              if (ticket != null)
                                _buildMessageBubble(
                                  context,
                                  isMe: false,
                                  name: ticket.user?.name ?? "N/a",
                                  email: ticket.user?.email ?? "N/A",
                                  message: ticket.message ?? "N/A",
                                  personAvatar: ticket.user?.avatar ?? "",
                                  attachments: ticket.attachments ?? [],
                                ),
                              SizedBox(height: 40),
                              ...messages.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 40),
                                  child: _buildMessageBubble(
                                    context,
                                    isMe: item.isAdmin ?? false,
                                    name:
                                        item.isAdmin == true
                                            ? "help_and_support.replay_ticket.admin_name"
                                                .trns()
                                            : item.name ?? "N/A",
                                    email: item.email ?? "N/A",
                                    message: item.message ?? "N/A",
                                    personAvatar: item.avatar ?? "",
                                    attachments: item.attachments ?? [],
                                  ),
                                );
                              }),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Obx(() {
                  final model = replayTicketController.ticketMessageModel.value;
                  if (model.data?.ticket?.status == "Open") {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAttachmentPreview(context),
                        _buildReplyInput(context),
                        SizedBox(height: 16),
                        _buildActionButtons(context),
                        SizedBox(height: 20),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            );
          }),
          Obx(
            () => Visibility(
              visible: replayTicketController.isTicketActionLoading.value,
              child: CommonLoading(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context, {
    required bool isMe,
    required String name,
    required String email,
    required String message,
    required String personAvatar,
    required List<String> attachments,
  }) {
    return Align(
      alignment: !isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: isMe ? 0 : 50, right: isMe ? 50 : 0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: !isMe ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    personAvatar,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(PngAssets.avatarOne);
                    },
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment:
                      !isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextTertiary
                                : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkSecondary
                        : AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(isMe ? 10 : 0),
                  topLeft: Radius.circular(isMe ? 0 : 10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                    if (attachments.isNotEmpty) ...[
                      SizedBox(height: 10),
                      Text(
                        "help_and_support.replay_ticket.attachments_label"
                            .trns(),
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          fontSize: 9,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.darkTextTertiary
                                  : AppColors.textTertiary,
                        ),
                      ),
                      SizedBox(height: 4),
                      ...attachments.map((attachmentUrl) {
                        final fileName = attachmentUrl.split('/').last;
                        return GestureDetector(
                          onTap: () {
                            Get.dialog(
                              Dialog(
                                backgroundColor:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkSecondary
                                        : AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "help_and_support.replay_ticket.attachment_preview"
                                                .trns(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors
                                                          .darkTextPrimary
                                                      : AppColors.textPrimary,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: Get.back,
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.black
                                                          .withValues(
                                                            alpha: 0.2,
                                                          )
                                                      : Colors.grey.shade100,
                                              child: Image.asset(
                                                PngAssets.commonCancelIcon,
                                                width: 14,
                                                fit: BoxFit.contain,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors.white
                                                        : AppColors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 30),
                                      InteractiveViewer(
                                        child: Image.network(
                                          attachmentUrl,
                                          loadingBuilder: (
                                            ctx,
                                            child,
                                            progress,
                                          ) {
                                            if (progress == null) return child;
                                            return CommonLoading();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Image.asset(
                                  PngAssets.albumCommonIcon,
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    fileName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkTextTertiary
                                              : AppColors.textTertiary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CommonTextInputField(
        controller: replayTicketController.messageController,
        hintText:
            ""
                    ""
                    "help_and_support.replay_ticket.write_message_placeholder"
                .trns(),
        maxLines: 4,
        height: null,
        borderRadius: 10,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
    );
  }

  Widget _buildAttachmentPreview(BuildContext context) {
    final MultipleImagePickerController multipleImagePickerController = Get.put(
      MultipleImagePickerController(),
    );

    return Obx(
      () => SizedBox(
        height: multipleImagePickerController.images.isEmpty ? 0 : 80,

        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: 8),
              ...multipleImagePickerController.images.entries.map((entry) {
                final int id = entry.key;
                final File imageFile = entry.value;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        height: 62,
                        decoration: BoxDecoration(
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.white.withValues(alpha: 0.05)
                                  : AppColors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.black.withValues(alpha: 0.10),
                          ),
                        ),
                        child: Image.file(
                          imageFile,
                          width: 46,
                          height: 46,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: -5,
                        child: GestureDetector(
                          onTap:
                              () =>
                                  multipleImagePickerController.removeImage(id),
                          child: Container(
                            padding: EdgeInsets.all(3),
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Image.asset(
                              PngAssets.commonCancelIcon,
                              width: 8,
                              height: 8,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CommonElevatedButton(
            backgroundColor: Colors.grey.shade300,
            width: 140,
            borderRadius: 30,
            height: 36,
            buttonName: "help_and_support.replay_ticket.add_attachment".trns(),
            fontSize: 13,
            textColor: AppColors.black,
            onPressed: () {
              final newId = DateTime.now().millisecondsSinceEpoch;
              Get.bottomSheet(
                MultipleImagePickerBottomSheet(attachmentId: newId),
              );
            },
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 85,
            height: 36,
            child: ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor:
                    themeController.isDarkMode.value
                        ? AppColors.darkPrimary
                        : AppColors.primary,
              ),
              child: Obx(
                () =>
                    replayTicketController.isReplayTicketLoading.value
                        ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                        : Text(
                          "help_and_support.replay_ticket.send_button".trns(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.black
                                    : AppColors.white,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
