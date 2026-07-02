import 'package:pakaso_credit/src/common/controller/currencies_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/controller/create_new_wallet_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateNewWallet extends StatefulWidget {
  const CreateNewWallet({super.key});

  @override
  State<CreateNewWallet> createState() => _CreateNewWalletState();
}

class _CreateNewWalletState extends State<CreateNewWallet> {
  final CreateNewWalletController createNewWalletController = Get.put(
    CreateNewWalletController(),
  );
  final CurrenciesController currenciesController = Get.put(
    CurrenciesController(),
  );

  @override
  void initState() {
    super.initState();
    createNewWalletController.currencyController.clear();
    createNewWalletController.currency.value = "";
    createNewWalletController.currencyId.value = "";
    loadData();
  }

  Future<void> loadData() async {
    createNewWalletController.isLoading.value = true;
    await currenciesController.fetchCurrencies();
    createNewWalletController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  CommonAppBar(
                    padding: 0,
                    title: "wallet.create_wallet.title".trns(),
                    showRightSideIcon: false,
                    isPopEnabled: false,
                  ),
                  SizedBox(height: 35),
                  Obx(() {
                    if (createNewWalletController.isLoading.value) {
                      return const CommonLoading();
                    }

                    return CommonTextInputField(
                      textFontWeight: FontWeight.w600,
                      controller: createNewWalletController.currencyController,
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      onTap: () {
                        Get.bottomSheet(
                          CommonDropdownBottomSheet(
                            title:
                                "wallet.create_wallet.currency.select_title"
                                    .trns(),
                            onValueSelected: (value) {
                              createNewWalletController.currencyId.value =
                                  value;
                            },
                            selectedValue:
                                currenciesController.currenciesList
                                    .map((item) => item.id.toString())
                                    .toList(),
                            dropdownItems:
                                currenciesController.currenciesList
                                    .map((item) => item.name!)
                                    .toList(),
                            selectedItem: createNewWalletController.currency,
                            textController:
                                createNewWalletController.currencyController,
                            currentlySelectedValue:
                                createNewWalletController.currency.value,
                            bottomSheetHeight: 400,
                          ),
                        );
                      },
                      hintText: "wallet.create_wallet.currency.hint".trns(),
                      showSuffixIcon: true,
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: Color(0xFF68686A),
                      ),
                    );
                  }),
                  Spacer(),
                  CommonElevatedButton(
                    buttonName: "wallet.create_wallet.button.create".trns(),
                    onPressed: () => createNewWalletController.createWallet(),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Obx(
              () => Visibility(
                visible: createNewWalletController.isCreateWalletLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
