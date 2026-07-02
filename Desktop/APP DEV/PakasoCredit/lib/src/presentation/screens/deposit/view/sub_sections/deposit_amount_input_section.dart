import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/widgets/common_enter_amount_text_field.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/controller/deposit_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepositAmountInputSection extends StatelessWidget {
  const DepositAmountInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    final DepositController depositController = Get.find<DepositController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonEnterAmountTextField(
          hintText: "Enter Amount",
          onChanged: (value) {
            depositController.amount.value = value;
            depositController.onAmountChange();
          },
          currencyCode: depositController.copyCurrencyCode.value,
          controller: depositController.amountController,
          keyboardType: TextInputType.number,
        ),
        Obx(
          () => Visibility(
            visible: depositController.gateway.value.isNotEmpty,
            child: Text(
              "deposit.amount.limit".trnsFormat({
                "min_range":
                    "${depositController.minimumDeposit.value} ${depositController.copyCurrencyCode.value}",
                "max_range":
                    "${depositController.maximumDeposit.value} ${depositController.copyCurrencyCode.value}",
              }),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.error,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
