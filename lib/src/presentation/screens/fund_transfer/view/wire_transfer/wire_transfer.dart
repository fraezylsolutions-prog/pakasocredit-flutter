import 'dart:convert';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_enter_amount_text_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/wire_transfer_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class WireTransfer extends StatefulWidget {
  const WireTransfer({super.key});

  @override
  State<WireTransfer> createState() => _WireTransferState();
}

class _WireTransferState extends State<WireTransfer> {
  final WireTransferController wireTransferController = Get.put(
    WireTransferController(),
  );
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );
  final Map<String, TextEditingController> textControllers = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    wireTransferController.amountController.clear();
    loadData();
  }

  Future<void> loadData() async {
    wireTransferController.isLoading.value = true;
    await wireTransferController.fetchWireTransferSettings();
    await wireTransferController.loadSiteCurrency();
    await passcodeController.loadPasscodeStatus(
      passcodeType: "fund_transfer_passcode_status",
    );
    wireTransferController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              gradient: AppStyles.linearGradient(),
              boxShadow: AppStyles.boxShadow(),
            ),
            child: Obx(() {
              if (wireTransferController.isLoading.value) {
                return const CommonLoading();
              }

              if (wireTransferController.wireTransferSettingsModel.value.data ==
                  null) {
                return const CommonLoading();
              }

              final Map<String, dynamic> parsedFields = jsonDecode(
                wireTransferController
                    .wireTransferSettingsModel
                    .value
                    .data!
                    .fieldOptions!,
              );

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => CommonEnterAmountTextField(
                                keyboardType: TextInputType.number,
                                currencyCode:
                                    wireTransferController.siteCurrency.value,
                                controller:
                                    wireTransferController.amountController,
                                hintText:
                                    "fundTransfer.wireTransfer.form.enterAmount"
                                        .trns(),
                              ),
                            ),
                            Obx(() {
                              final data =
                                  wireTransferController
                                      .wireTransferSettingsModel
                                      .value
                                      .data;
                              if (data?.minimumTransfer?.isNotEmpty == true &&
                                  data?.maximumTransfer?.isNotEmpty == true) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 4,
                                  ),
                                  child: Text(
                                    "fundTransfer.wireTransfer.form.minMaxNote"
                                        .trnsFormat({
                                          "min_range":
                                              "${data!.minimumTransfer} ${wireTransferController.siteCurrency.value}",
                                          "max_range":
                                              "${data.maximumTransfer} ${wireTransferController.siteCurrency.value}",
                                        }),

                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.error,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox();
                            }),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...parsedFields.entries.map((entry) {
                          final field = entry.value;
                          final String name = field["name"];
                          final String type = field["type"];
                          final bool isRequired =
                              field["validation"] == "required";

                          if (type == "text") {
                            textControllers[name] ??= TextEditingController();
                            return Column(
                              children: [
                                CommonTextInputField(
                                  height: null,
                                  controller: textControllers[name],
                                  hintText: name,
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    wireTransferController.setFormData(
                                      name,
                                      value,
                                    );
                                  },
                                  validator: (value) {
                                    if (isRequired &&
                                        (value == null || value.isEmpty)) {
                                      return "fundTransfer.wireTransfer.form.fieldRequired"
                                          .trnsFormat({"field_name": name});
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                        const SizedBox(height: 20),
                        CommonElevatedButton(
                          buttonName:
                              "fundTransfer.wireTransfer.button.submit".trns(),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (wireTransferController
                                  .amountController
                                  .text
                                  .isNotEmpty) {
                                final homeCtrl = Get.find<HomeController>();
                                final userPasscode =
                                    homeCtrl.userModel.value.passcode;

                                if (userPasscode == null) {
                                  await wireTransferController
                                      .submitWireTransfer();
                                  clearAllFields();
                                  return;
                                }

                                final needsPasscode =
                                    passcodeController.passcodeStatus.value ==
                                        "1" ||
                                    passcodeController.passcodeStatus.value ==
                                        "null";

                                if (needsPasscode) {
                                  Get.dialog(
                                    ConfirmPasscodePopUp(
                                      controller:
                                          passcodeController.passcodeController,
                                      onPressed: () async {
                                        final ok =
                                            await passcodeController
                                                .submitPasscodeVerify();
                                        if (!ok) return;
                                        Get.back();
                                        await wireTransferController
                                            .submitWireTransfer();
                                        clearAllFields();
                                      },
                                    ),
                                  );
                                } else {
                                  await wireTransferController
                                      .submitWireTransfer();
                                  clearAllFields();
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg:
                                      "fundTransfer.wireTransfer.form.amountRequiredToast"
                                          .trns(),
                                  backgroundColor: AppColors.error,
                                );
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          Obx(
            () => Visibility(
              visible: wireTransferController.isWireTransferLoading.value,
              child: CommonLoading(),
            ),
          ),
        ],
      ),
    );
  }

  void clearAllFields() {
    wireTransferController.amountController.clear();
    for (var controller in textControllers.values) {
      controller.clear();
    }
    wireTransferController.formData.clear();
  }

  @override
  void dispose() {
    for (var controller in textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
