import 'dart:convert';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/app_strings.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/country_controller.dart';
import 'package:pakaso_credit/src/common/controller/register_fields_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_country_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/sign_up/controller/sign_up_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final signUpController = Get.find<SignUpController>();
  final registerFieldsController = Get.find<RegisterFieldsController>();
  final countryController = Get.find<CountryController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    signUpController.isLoading.value = true;
    await registerFieldsController.fetchRegisterFields();
    if (registerFieldsController.registerFields["country_show"] == "1") {
      await countryController.fetchCountries();
      _setSelectedCountry();
    }

    if (registerFieldsController.registerFields.containsKey(
      "register_custom_fields",
    )) {
      try {
        signUpController.customFields.value = Map<String, dynamic>.from(
          jsonDecode(
            registerFieldsController.registerFields["register_custom_fields"]!,
          ),
        );

        signUpController.customFieldControllers.clear();
        for (String key in signUpController.customFields.keys) {
          signUpController.customFieldControllers[key] =
              TextEditingController();
        }
      } finally {}
    }

    signUpController.isLoading.value = false;
  }

  void _setSelectedCountry() {
    final selectedCountry = countryController.countryList.firstWhereOrNull(
      (country) => country.selected == true,
    );

    if (selectedCountry != null) {
      signUpController.countryController.text = selectedCountry.name ?? "";
      signUpController.countryCode.value = selectedCountry.code ?? "";
      signUpController.countryDialCode.value = selectedCountry.dialCode ?? "";
      signUpController.country.value = selectedCountry.name ?? "";
    }
  }

  Widget _buildCustomField(String key, dynamic field) {
    final name = field['name'] ?? '';
    final type = field['type'] ?? 'text';
    final isRequired = field['validation'] == 'required';
    final controller = signUpController.customFieldControllers[key];

    if (type == 'textarea') {
      return Column(
        children: [
          SizedBox(height: 20),
          CommonRequiredLabelAndDynamicField(
            labelText: name,
            isLabelRequired: isRequired,
            dynamicField: CommonTextInputField(
              height: null,
              validator:
                  isRequired
                      ? (value) {
                        if (value == null || value.isEmpty) {
                          return "signUp.validation.required".trns();
                        }
                        return null;
                      }
                      : null,
              controller: controller,
              hintText: "",
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 20),
          CommonRequiredLabelAndDynamicField(
            labelText: name,
            isLabelRequired: isRequired,
            dynamicField: CommonTextInputField(
              height: null,
              validator:
                  isRequired
                      ? (value) {
                        if (value == null || value.isEmpty) {
                          return "signUp.validation.required".trns();
                        }
                        return null;
                      }
                      : null,
              controller: controller,
              hintText: "",
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: AppColors.white.withValues(alpha: 0.1),
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.white.withValues(alpha: 0.18),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Image.asset(
                                PngAssets.commonBackArrowIcon,
                                width: 20,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "signUp.haveAccountText".trns(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: AppColors.white,
                              ),
                            ),
                            SizedBox(width: 6),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8.5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(
                                    alpha: 0.16,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "signUp.loginButton".trns(),
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
                                  signUpController.isLoading.value
                                      ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                                    "signUp.title".trns(),
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
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          CommonRequiredLabelAndDynamicField(
                                                            labelText:
                                                                "signUp.fields.email"
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
                                                                  return "signUp.validation.required"
                                                                      .trns();
                                                                }
                                                                return null;
                                                              },
                                                              controller:
                                                                  signUpController
                                                                      .emailController,
                                                              hintText: "",
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible:
                                                                registerFieldsController
                                                                    .registerFields["country_show"] ==
                                                                "1",
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                CommonRequiredLabelAndDynamicField(
                                                                  labelText:
                                                                      "signUp.fields.country"
                                                                          .trns(),
                                                                  isLabelRequired:
                                                                      registerFieldsController.registerFields["country_validation"] ==
                                                                              "1"
                                                                          ? true
                                                                          : false,
                                                                  dynamicField: CommonTextInputField(
                                                                    height:
                                                                        null,
                                                                    validator:
                                                                        registerFieldsController.registerFields["country_validation"] ==
                                                                                "1"
                                                                            ? (
                                                                              value,
                                                                            ) {
                                                                              if (value ==
                                                                                      null ||
                                                                                  value.isEmpty) {
                                                                                return "signUp.validation.required".trns();
                                                                              }
                                                                              return null;
                                                                            }
                                                                            : null,
                                                                    textFontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    controller:
                                                                        signUpController
                                                                            .countryController,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .none,
                                                                    readOnly:
                                                                        true,
                                                                    onTap: () {
                                                                      Get.bottomSheet(
                                                                        CommonCountryDropdownBottomSheet(
                                                                          countryDialCode:
                                                                              countryController.countryList
                                                                                  .map(
                                                                                    (
                                                                                      item,
                                                                                    ) =>
                                                                                        item.dialCode ??
                                                                                        "",
                                                                                  )
                                                                                  .toList(),
                                                                          controller:
                                                                              signUpController,
                                                                          countryCode:
                                                                              countryController.countryList
                                                                                  .map(
                                                                                    (
                                                                                      item,
                                                                                    ) =>
                                                                                        item.code ??
                                                                                        "",
                                                                                  )
                                                                                  .toList(),
                                                                          countryImage:
                                                                              countryController.countryList
                                                                                  .map(
                                                                                    (
                                                                                      item,
                                                                                    ) =>
                                                                                        item.flag ??
                                                                                        "",
                                                                                  )
                                                                                  .toList(),
                                                                          title:
                                                                              "signUp.countrySheet.title".trns(),
                                                                          dropdownItems:
                                                                              countryController.countryList
                                                                                  .map(
                                                                                    (
                                                                                      item,
                                                                                    ) =>
                                                                                        item.name ??
                                                                                        "",
                                                                                  )
                                                                                  .toList(),
                                                                          selectedItem:
                                                                              signUpController.country,
                                                                          textController:
                                                                              signUpController.countryController,
                                                                          bottomSheetHeight:
                                                                              450,
                                                                        ),
                                                                      );
                                                                    },
                                                                    hintText:
                                                                        "signUp.countrySheet.title"
                                                                            .trns(),
                                                                    showSuffixIcon:
                                                                        true,
                                                                    suffixIcon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down_rounded,
                                                                      size: 20,
                                                                      color:
                                                                          themeController.isDarkMode.value
                                                                              ? AppColors.darkTextPrimary
                                                                              : AppColors.textPrimary,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible:
                                                                registerFieldsController
                                                                    .registerFields["phone_validation"] ==
                                                                "1",
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                CommonRequiredLabelAndDynamicField(
                                                                  labelText:
                                                                      "signUp.fields.phone"
                                                                          .trns(),
                                                                  isLabelRequired:
                                                                      registerFieldsController.registerFields["phone_show"] ==
                                                                              "1"
                                                                          ? true
                                                                          : false,
                                                                  dynamicField: Row(
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              14,
                                                                        ),
                                                                        height:
                                                                            45,
                                                                        alignment:
                                                                            Alignment.center,
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              themeController.isDarkMode.value
                                                                                  ? AppColors.transparent
                                                                                  : AppColors.white,
                                                                          borderRadius: const BorderRadius.horizontal(
                                                                            left: Radius.circular(
                                                                              10,
                                                                            ),
                                                                          ),
                                                                          border: BorderDirectional(
                                                                            top: BorderSide(
                                                                              color:
                                                                                  themeController.isDarkMode.value
                                                                                      ? Color(
                                                                                        0xFF5D6765,
                                                                                      )
                                                                                      : AppColors.black.withValues(
                                                                                        alpha:
                                                                                            0.20,
                                                                                      ),
                                                                            ),
                                                                            start: BorderSide(
                                                                              color:
                                                                                  themeController.isDarkMode.value
                                                                                      ? Color(
                                                                                        0xFF5D6765,
                                                                                      )
                                                                                      : AppColors.black.withValues(
                                                                                        alpha:
                                                                                            0.20,
                                                                                      ),
                                                                            ),
                                                                            bottom: BorderSide(
                                                                              color:
                                                                                  themeController.isDarkMode.value
                                                                                      ? Color(
                                                                                        0xFF5D6765,
                                                                                      )
                                                                                      : AppColors.black.withValues(
                                                                                        alpha:
                                                                                            0.20,
                                                                                      ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child: Text(
                                                                          signUpController
                                                                              .countryDialCode
                                                                              .value,
                                                                          style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                themeController.isDarkMode.value
                                                                                    ? AppColors.darkTextPrimary
                                                                                    : AppColors.textPrimary,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: CommonTextInputField(
                                                                          topLeftBorderRadius:
                                                                              0,
                                                                          bottomLeftBorderRadius:
                                                                              0,
                                                                          controller:
                                                                              signUpController.phoneController,
                                                                          hintText:
                                                                              "",
                                                                          keyboardType:
                                                                              TextInputType.phone,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible:
                                                                registerFieldsController
                                                                    .registerFields["referral_code_show"] ==
                                                                "1",
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                CommonRequiredLabelAndDynamicField(
                                                                  labelText:
                                                                      "signUp.fields.referralCode"
                                                                          .trns(),
                                                                  isLabelRequired:
                                                                      registerFieldsController.registerFields["referral_code_validation"] ==
                                                                              "1"
                                                                          ? true
                                                                          : false,
                                                                  dynamicField: CommonTextInputField(
                                                                    height:
                                                                        null,
                                                                    validator:
                                                                        registerFieldsController.registerFields["referral_code_validation"] ==
                                                                                "1"
                                                                            ? (
                                                                              value,
                                                                            ) {
                                                                              if (value ==
                                                                                      null ||
                                                                                  value.isEmpty) {
                                                                                return "signUp.validation.required".trns();
                                                                              }
                                                                              return null;
                                                                            }
                                                                            : null,
                                                                    controller:
                                                                        signUpController
                                                                            .referralCodeController,
                                                                    hintText:
                                                                        "",
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    onChanged: (
                                                                      value,
                                                                    ) {
                                                                      if (value
                                                                          .contains(
                                                                            'invite=',
                                                                          )) {
                                                                        final uri =
                                                                            Uri.tryParse(
                                                                              value,
                                                                            );
                                                                        if (uri !=
                                                                                null &&
                                                                            uri.hasQuery) {
                                                                          final inviteCode =
                                                                              uri.queryParameters['invite'];
                                                                          if (inviteCode !=
                                                                                  null &&
                                                                              inviteCode.isNotEmpty) {
                                                                            signUpController.referralCodeController.text =
                                                                                inviteCode;
                                                                            signUpController.referralCodeController.selection = TextSelection.fromPosition(
                                                                              TextPosition(
                                                                                offset:
                                                                                    inviteCode.length,
                                                                              ),
                                                                            );
                                                                          }
                                                                        }
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Obx(
                                                            () => CommonRequiredLabelAndDynamicField(
                                                              labelText:
                                                                  "signUp.fields.password"
                                                                      .trns(),
                                                              isLabelRequired:
                                                                  true,
                                                              dynamicField: CommonTextInputField(
                                                                validator: (
                                                                  value,
                                                                ) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return "signUp.validation.required"
                                                                        .trns();
                                                                  }
                                                                  return null;
                                                                },
                                                                height: null,
                                                                controller:
                                                                    signUpController
                                                                        .passwordController,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .text,
                                                                obscureText:
                                                                    signUpController
                                                                        .isPasswordVisible
                                                                        .value,
                                                                hintText: "",
                                                                showSuffixIcon:
                                                                    true,
                                                                suffixIcon: IconButton(
                                                                  onPressed: () {
                                                                    signUpController
                                                                            .isPasswordVisible
                                                                            .value =
                                                                        !signUpController
                                                                            .isPasswordVisible
                                                                            .value;
                                                                  },
                                                                  icon: Image.asset(
                                                                    !signUpController
                                                                            .isPasswordVisible
                                                                            .value
                                                                        ? PngAssets
                                                                            .commonRawHideEyeIcon
                                                                        : PngAssets
                                                                            .commonRawEyeIcon,
                                                                    width: 18,
                                                                    color:
                                                                        themeController.isDarkMode.value
                                                                            ? AppColors.darkTextPrimary
                                                                            : AppColors.textPrimary,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          if (signUpController
                                                              .customFields
                                                              .isNotEmpty)
                                                            ...signUpController
                                                                .customFields
                                                                .entries
                                                                .map(
                                                                  (
                                                                    entry,
                                                                  ) => _buildCustomField(
                                                                    entry.key,
                                                                    entry.value,
                                                                  ),
                                                                ),
                                                          SizedBox(height: 50),
                                                          CommonElevatedButton(
                                                            fontSize: 16,
                                                            buttonName:
                                                                "signUp.nextButton"
                                                                    .trns(),
                                                            onPressed: () {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                if (signUpController
                                                                    .phoneController
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  signUpController
                                                                      .submitSignUpFirstStep();
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                    msg:
                                                                        "signUp.validation.phoneRequired"
                                                                            .trns(),
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .error,
                                                                  );
                                                                }
                                                              }
                                                            },
                                                            fontFamily: "Inter",
                                                            rightIcon: Image.asset(
                                                              PngAssets
                                                                  .commonArrowLeftIcon,
                                                              fit:
                                                                  BoxFit
                                                                      .contain,
                                                              width: 20,
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
                                                          SizedBox(height: 50),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
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
                visible: signUpController.isSubmitLoading.value,
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
}
