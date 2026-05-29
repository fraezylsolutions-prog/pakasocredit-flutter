import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/app_strings.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/branches_controller.dart';
import 'package:pakaso_credit/src/common/controller/register_fields_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/finish_up_account/controller/finish_up_account_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FinishUpAccountScreen extends StatefulWidget {
  const FinishUpAccountScreen({super.key});

  @override
  State<FinishUpAccountScreen> createState() => _FinishUpAccountScreenState();
}

class _FinishUpAccountScreenState extends State<FinishUpAccountScreen> {
  final finishUpAccountController = Get.find<FinishUpAccountController>();
  final registerFieldsController = Get.find<RegisterFieldsController>();
  final branchController = Get.find<BranchesController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    finishUpAccountController.isLoading.value = true;
    await registerFieldsController.fetchRegisterFields();
    if (registerFieldsController.registerFields["branch_show"] == "1") {
      await branchController.fetchBranches();
    }
    finishUpAccountController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          surfaceTintColor:
              themeController.isDarkMode.value
                  ? AppColors.darkBackground
                  : AppColors.primary,
          backgroundColor:
              themeController.isDarkMode.value
                  ? AppColors.darkBackground
                  : AppColors.primary,
        ),
        body: ColoredBox(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkBackground
                  : AppColors.primary,
          child: Obx(
            () => Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset(
                    themeController.isDarkMode.value
                        ? PngAssets.signInDarkShadow
                        : PngAssets.signInShadow,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "finishUpAccount.existingAccount.text".trns(),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => Get.offNamed(BaseRoute.signIn),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8.5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "finishUpAccount.existingAccount.loginButton.text"
                                      .trns(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Image.asset(
                      themeController.isDarkMode.value
                          ? AppStrings.darkAppLogo
                          : AppStrings.appLogo,
                      height: 38,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 50),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 28),
                            decoration: BoxDecoration(
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.white.withValues(alpha: 0.10)
                                      : AppColors.white.withValues(alpha: 0.20),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 14,
                            right: 16,
                            bottom: 0,
                            left: 16,
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkSecondary
                                        : AppColors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                width: double.infinity,
                                child:
                                    finishUpAccountController.isLoading.value
                                        ? SizedBox(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.7,
                                          child: CommonLoading(),
                                        )
                                        : Column(
                                          children: [
                                            SizedBox(height: 6),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 30),
                                                    Text(
                                                      "finishUpAccount.mainContent.title"
                                                          .trns(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 24,
                                                        color:
                                                            themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? AppColors
                                                                    .darkTextPrimary
                                                                : AppColors
                                                                    .textPrimary,
                                                      ),
                                                    ),
                                                    SizedBox(height: 30),
                                                    Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        children: [
                                                          Visibility(
                                                            visible:
                                                                registerFieldsController
                                                                    .registerFields["username_show"] ==
                                                                "1",
                                                            child: Column(
                                                              children: [
                                                                CommonRequiredLabelAndDynamicField(
                                                                  labelText:
                                                                      "finishUpAccount.mainContent.form.username.label"
                                                                          .trns(),
                                                                  isLabelRequired:
                                                                      registerFieldsController.registerFields["username_validation"] ==
                                                                              "1"
                                                                          ? true
                                                                          : false,
                                                                  dynamicField: CommonTextInputField(
                                                                    height:
                                                                        null,
                                                                    validator:
                                                                        registerFieldsController.registerFields["username_validation"] ==
                                                                                "1"
                                                                            ? (
                                                                              value,
                                                                            ) {
                                                                              if (value ==
                                                                                      null ||
                                                                                  value.isEmpty) {
                                                                                return "finishUpAccount.mainContent.form.username.validation.errorMessage".trns();
                                                                              }
                                                                              return null;
                                                                            }
                                                                            : null,
                                                                    hintText:
                                                                        "",
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .name,
                                                                    controller:
                                                                        finishUpAccountController
                                                                            .userNameController,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          CommonRequiredLabelAndDynamicField(
                                                            labelText:
                                                                "finishUpAccount.mainContent.form.firstName.label"
                                                                    .trns(),
                                                            isLabelRequired:
                                                                true,
                                                            dynamicField: CommonTextInputField(
                                                              height: null,
                                                              validator: (
                                                                value,
                                                              ) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "finishUpAccount.mainContent.form.firstName.validation.errorMessage"
                                                                      .trns();
                                                                }
                                                                return null;
                                                              },
                                                              controller:
                                                                  finishUpAccountController
                                                                      .firstNameController,
                                                              hintText: "",
                                                              keyboardType:
                                                                  TextInputType
                                                                      .name,
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          CommonRequiredLabelAndDynamicField(
                                                            labelText:
                                                                "finishUpAccount.mainContent.form.lastName.label"
                                                                    .trns(),
                                                            isLabelRequired:
                                                                true,
                                                            dynamicField: CommonTextInputField(
                                                              height: null,
                                                              validator: (
                                                                value,
                                                              ) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return "finishUpAccount.mainContent.form.lastName.validation.errorMessage"
                                                                      .trns();
                                                                }
                                                                return null;
                                                              },
                                                              controller:
                                                                  finishUpAccountController
                                                                      .lastNameController,
                                                              hintText: "",
                                                              keyboardType:
                                                                  TextInputType
                                                                      .name,
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible:
                                                                registerFieldsController
                                                                    .registerFields["gender_show"] ==
                                                                "1",
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                CommonRequiredLabelAndDynamicField(
                                                                  labelText:
                                                                      "finishUpAccount.mainContent.form.gender.label"
                                                                          .trns(),
                                                                  isLabelRequired:
                                                                      registerFieldsController.registerFields["gender_validation"] ==
                                                                              "1"
                                                                          ? true
                                                                          : false,
                                                                  dynamicField: CommonTextInputField(
                                                                    height:
                                                                        null,
                                                                    validator:
                                                                        registerFieldsController.registerFields["gender_validation"] ==
                                                                                "1"
                                                                            ? (
                                                                              value,
                                                                            ) {
                                                                              if (value ==
                                                                                      null ||
                                                                                  value.isEmpty) {
                                                                                return "finishUpAccount.mainContent.form.gender.validation.errorMessage".trns();
                                                                              }
                                                                              return null;
                                                                            }
                                                                            : null,
                                                                    textFontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    controller:
                                                                        finishUpAccountController
                                                                            .genderController,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .none,
                                                                    readOnly:
                                                                        true,
                                                                    onTap: () {
                                                                      Get.bottomSheet(
                                                                        CommonDropdownBottomSheet(
                                                                          currentlySelectedValue:
                                                                              finishUpAccountController.gender.value,
                                                                          title:
                                                                              "finishUpAccount.mainContent.form.gender.placeholder".trns(),
                                                                          dropdownItems: [
                                                                            "Male",
                                                                            "Female",
                                                                            "Other",
                                                                          ],
                                                                          selectedItem:
                                                                              finishUpAccountController.gender,
                                                                          textController:
                                                                              finishUpAccountController.genderController,
                                                                          bottomSheetHeight:
                                                                              300,
                                                                        ),
                                                                      );
                                                                    },
                                                                    hintText:
                                                                        "finishUpAccount.mainContent.form.gender.placeholder"
                                                                            .trns(),
                                                                    showSuffixIcon:
                                                                        true,
                                                                    suffixIcon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down_rounded,
                                                                      size: 20,
                                                                      color: Color(
                                                                        0xFF68686A,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible:
                                                                registerFieldsController
                                                                    .registerFields["branch_show"] ==
                                                                "1",
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                CommonRequiredLabelAndDynamicField(
                                                                  labelText:
                                                                      "finishUpAccount.mainContent.form.branch.label"
                                                                          .trns(),
                                                                  isLabelRequired:
                                                                      registerFieldsController.registerFields["branch_validation"] ==
                                                                              "1"
                                                                          ? true
                                                                          : false,
                                                                  dynamicField: CommonTextInputField(
                                                                    height:
                                                                        null,
                                                                    validator:
                                                                        registerFieldsController.registerFields["branch_validation"] ==
                                                                                "1"
                                                                            ? (
                                                                              value,
                                                                            ) {
                                                                              if (value ==
                                                                                      null ||
                                                                                  value.isEmpty) {
                                                                                return "finishUpAccount.mainContent.form.branch.validation.errorMessage".trns();
                                                                              }
                                                                              return null;
                                                                            }
                                                                            : null,
                                                                    textFontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    controller:
                                                                        finishUpAccountController
                                                                            .branchController,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .none,
                                                                    readOnly:
                                                                        true,
                                                                    onTap: () {
                                                                      Get.bottomSheet(
                                                                        CommonDropdownBottomSheet(
                                                                          currentlySelectedValue:
                                                                              finishUpAccountController.branch.value,
                                                                          onValueSelected: (
                                                                            value,
                                                                          ) {
                                                                            finishUpAccountController.branchId.value =
                                                                                value;
                                                                          },
                                                                          selectedValue:
                                                                              branchController.branchesList
                                                                                  .map(
                                                                                    (
                                                                                      item,
                                                                                    ) =>
                                                                                        item.id.toString(),
                                                                                  )
                                                                                  .toList(),
                                                                          title:
                                                                              "finishUpAccount.mainContent.form.branch.placeholder".trns(),
                                                                          dropdownItems:
                                                                              branchController.branchesList
                                                                                  .map(
                                                                                    (
                                                                                      item,
                                                                                    ) =>
                                                                                        item.name ??
                                                                                        "",
                                                                                  )
                                                                                  .toList(),
                                                                          selectedItem:
                                                                              finishUpAccountController.branch,
                                                                          textController:
                                                                              finishUpAccountController.branchController,
                                                                          bottomSheetHeight:
                                                                              450,
                                                                        ),
                                                                      );
                                                                    },
                                                                    hintText:
                                                                        "finishUpAccount.mainContent.form.branch.placeholder"
                                                                            .trns(),
                                                                    showSuffixIcon:
                                                                        true,
                                                                    suffixIcon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down_rounded,
                                                                      size: 20,
                                                                      color: Color(
                                                                        0xFF68686A,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 6),
                                                          GestureDetector(
                                                            onTap: () {
                                                              finishUpAccountController
                                                                      .isAgreeChecked
                                                                      .value =
                                                                  !finishUpAccountController
                                                                      .isAgreeChecked
                                                                      .value;
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Obx(
                                                                  () => Transform.scale(
                                                                    scale: 1.1,
                                                                    child: Checkbox(
                                                                      side: BorderSide(
                                                                        color:
                                                                            themeController.isDarkMode.value
                                                                                ? Color(
                                                                                  0xFF5D6765,
                                                                                )
                                                                                : Color(
                                                                                  0xFF68686A,
                                                                                ).withValues(
                                                                                  alpha:
                                                                                      0.2,
                                                                                ),
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      splashRadius:
                                                                          0,
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              4,
                                                                            ),
                                                                      ),
                                                                      checkColor:
                                                                          Colors
                                                                              .white,
                                                                      activeColor:
                                                                          themeController.isDarkMode.value
                                                                              ? AppColors.darkPrimary
                                                                              : AppColors.primary,
                                                                      materialTapTargetSize:
                                                                          MaterialTapTargetSize
                                                                              .shrinkWrap,
                                                                      visualDensity:
                                                                          VisualDensity
                                                                              .compact,
                                                                      value:
                                                                          finishUpAccountController
                                                                              .isAgreeChecked
                                                                              .value,
                                                                      onChanged: (
                                                                        bool?
                                                                        value,
                                                                      ) {
                                                                        finishUpAccountController
                                                                            .isAgreeChecked
                                                                            .value = !finishUpAccountController.isAgreeChecked.value;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text.rich(
                                                                  TextSpan(
                                                                    children: [
                                                                      TextSpan(
                                                                        text:
                                                                            "finishUpAccount.mainContent.termsAgreement.text".trns(),
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              themeController.isDarkMode.value
                                                                                  ? AppColors.darkTextTertiary
                                                                                  : Color(
                                                                                    0xFF030306,
                                                                                  ),
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            "finishUpAccount.mainContent.termsAgreement.link".trns(),
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              themeController.isDarkMode.value
                                                                                  ? AppColors.darkPrimary
                                                                                  : AppColors.primary,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 40),
                                                          CommonElevatedButton(
                                                            fontSize: 16,
                                                            buttonName:
                                                                "finishUpAccount.mainContent.submitButton.text"
                                                                    .trns(),
                                                            onPressed: () {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                finishUpAccountController
                                                                    .submitSignUpSecondStep();
                                                              }
                                                            },
                                                            fontFamily: "Inter",
                                                            rightIcon: Image.asset(
                                                              PngAssets
                                                                  .commonTickDoubleIcon,
                                                              width: 20,
                                                              fit:
                                                                  BoxFit
                                                                      .contain,
                                                              color:
                                                                  themeController
                                                                          .isDarkMode
                                                                          .value
                                                                      ? AppColors
                                                                          .black
                                                                      : AppColors
                                                                          .white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 50),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: finishUpAccountController.isSubmitLoading.value,
                  child: Container(
                    color: AppColors.textPrimary.withValues(alpha: 0.3),
                    child: CommonLoading(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
