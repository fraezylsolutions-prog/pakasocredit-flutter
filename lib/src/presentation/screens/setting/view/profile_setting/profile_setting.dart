import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/image_picker/image_picker_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/bottom_sheet/image_picker_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_single_date_picker.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/profile_settings/profile_settings_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final ThemeController themeController = Get.find<ThemeController>();
  final ProfileSettingsController controller = Get.put(
    ProfileSettingsController(),
  );
  final ImagePickerController imagePickerController = Get.put(
    ImagePickerController(),
  );

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await controller.fetchUser();
    _populateFormFields();
  }

  void _populateFormFields() {
    final userData = controller.userModel.value;
    controller.firstNameController.text = userData.firstName ?? "";
    controller.lastNameController.text = userData.lastName ?? "";
    controller.userNameController.text = userData.username ?? "";
    controller.genderController.text =
        userData.gender != null
            ? userData.gender![0].toUpperCase() +
                userData.gender!.substring(1).toLowerCase()
            : "";
    controller.gender.value =
        userData.gender != null
            ? userData.gender![0].toUpperCase() +
                userData.gender!.substring(1).toLowerCase()
            : "";
    controller.dateOfBirth.value = userData.dateOfBirth ?? "";
    controller.emailController.text = userData.email ?? "";
    controller.phoneController.text = userData.phone ?? "";
    controller.countryController.text = userData.country ?? "";
    controller.cityController.text = userData.city ?? "";
    controller.zipController.text = userData.zipCode ?? "";
    controller.joiningDateController.text = userData.createdAt ?? "";
    controller.addressController.text = userData.address ?? "";
    controller.avatar.value = userData.avatarPath ?? "";
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
            Column(
              children: [
                SizedBox(height: 16),
                CommonAppBar(
                  title: "profileSettings.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: false,
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const CommonLoading();
                    }

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.only(left: 18, right: 18, top: 18),
                      decoration: BoxDecoration(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkSecondary
                                : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        gradient: AppStyles.linearGradient(),
                        boxShadow: AppStyles.boxShadow(),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildUpdateAvatarSection(),
                            SizedBox(height: 24),
                            _buildSectionTitle(
                              "profileSettings.personalInfo".trns(),
                            ),
                            SizedBox(height: 20),
                            _buildFirstAndLastNameSection(),
                            SizedBox(height: 16),
                            _buildUsernameAndGenderSection(),
                            SizedBox(height: 16),
                            _buildDateOfBirthAndEmailAddressSection(),
                            SizedBox(height: 30),
                            _buildSectionTitle(
                              "profileSettings.contactDetails".trns(),
                            ),
                            SizedBox(height: 20),
                            _buildPhoneAndCountrySection(),
                            SizedBox(height: 16),
                            _buildCityAndZipSection(),
                            SizedBox(height: 20),
                            _buildAddressAndJoiningDateSection(),
                            SizedBox(height: 30),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: CommonElevatedButton(
                                buttonName:
                                    "profileSettings.buttons.saveChanges"
                                        .trns(),
                                onPressed: () {
                                  controller.submitUpdateProfile();
                                },
                                borderRadius: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: controller.isProfileUpdateLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkPrimary
                    : AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressAndJoiningDateSection() {
    return Column(
      children: [
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.joiningDate".trns(),
          dynamicField: CommonTextInputField(
            controller: controller.joiningDateController,
            readOnly: true,
            hintText: "",
            keyboardType: TextInputType.datetime,
            prefixIcon: Icon(Icons.event_outlined, size: 20),
          ),
        ),
        SizedBox(height: 20),
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.address".trns(),
          dynamicField: CommonTextInputField(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            controller: controller.addressController,
            hintText: "",
            keyboardType: TextInputType.streetAddress,
            maxLines: 4,
            prefixIcon: Icon(Icons.location_on_outlined, size: 20),
            height: null,
          ),
        ),
      ],
    );
  }

  Widget _buildCityAndZipSection() {
    return Column(
      children: [
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.city".trns(),
          dynamicField: CommonTextInputField(
            controller: controller.cityController,
            hintText: "",
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Icons.location_city_outlined, size: 20),
          ),
        ),
        SizedBox(height: 16),
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.zip".trns(),
          dynamicField: CommonTextInputField(
            controller: controller.zipController,
            hintText: "",
            keyboardType: TextInputType.number,
            prefixIcon: Icon(Icons.map_outlined, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneAndCountrySection() {
    return Column(
      children: [
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.phone".trns(),
          dynamicField: CommonTextInputField(
            controller: controller.phoneController,
            hintText: "",
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(Icons.phone_outlined, size: 20),
          ),
        ),
        SizedBox(height: 16),
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.country".trns(),
          dynamicField: CommonTextInputField(
            controller: controller.countryController,
            readOnly: true,
            hintText: "",
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Icons.public_outlined, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthAndEmailAddressSection() {
    return Column(
      children: [
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.dateOfBirth".trns(),
          dynamicField: CommonSingleDatePicker(
            hintText: "profileSettings.formFields.selectDate".trns(),
            initialDate:
                controller.userModel.value.dateOfBirth != null
                    ? _getValidInitialDate()
                    : null,
            onDateSelected: (DateTime value) {
              controller.dateOfBirth.value = DateFormat(
                'yyyy-MM-dd',
              ).format(value);
            },
          ),
        ),
        SizedBox(height: 16),
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.email".trns(),
          dynamicField: CommonTextInputField(
            controller: controller.emailController,
            readOnly: true,
            hintText: "",
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email_outlined, size: 20),
          ),
        ),
      ],
    );
  }

  DateTime _getValidInitialDate() {
    try {
      if (controller.dateOfBirth.value.isNotEmpty) {
        DateTime parsedDate = DateTime.parse(controller.dateOfBirth.value);
        DateTime minDate = DateTime(1900);
        DateTime maxDate = DateTime.now();
        if (parsedDate.isAfter(minDate) &&
            parsedDate.isBefore(maxDate.add(Duration(days: 1)))) {
          return parsedDate;
        }
      }
    } finally {}
    return DateTime.now().subtract(Duration(days: 25 * 365));
  }

  Widget _buildUsernameAndGenderSection() {
    return Column(
      children: [
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.username".trns(),
          dynamicField: CommonTextInputField(
            controller: controller.userNameController,
            hintText: "",
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Icons.person_outline, size: 20),
          ),
        ),
        SizedBox(height: 16),
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.gender".trns(),
          isLabelRequired: false,
          dynamicField: CommonTextInputField(
            textFontWeight: FontWeight.w600,
            controller: controller.genderController,
            keyboardType: TextInputType.none,
            readOnly: true,
            onTap: () {
              Get.bottomSheet(
                CommonDropdownBottomSheet(
                  title: "profileSettings.formFields.selectGender".trns(),
                  dropdownItems: [
                    "profileSettings.genderOptions.male".trns(),
                    "profileSettings.genderOptions.female".trns(),
                    "profileSettings.genderOptions.other".trns(),
                  ],
                  selectedItem: controller.gender,
                  textController: controller.genderController,
                  currentlySelectedValue: controller.gender.value,
                  bottomSheetHeight: 300,
                ),
              );
            },
            hintText: "profileSettings.formFields.selectGender".trns(),
            showSuffixIcon: true,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: Colors.grey.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFirstAndLastNameSection() {
    return Column(
      children: [
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.firstName".trns(),
          dynamicField: CommonTextInputField(
            controller: controller.firstNameController,
            hintText: "",
            keyboardType: TextInputType.name,
            prefixIcon: Icon(Icons.badge_outlined, size: 20),
          ),
        ),
        SizedBox(height: 16),
        CommonRequiredLabelAndDynamicField(
          labelText: "profileSettings.formFields.lastName".trns(),
          dynamicField: CommonTextInputField(
            controller: controller.lastNameController,
            hintText: "",
            keyboardType: TextInputType.name,
            prefixIcon: Icon(Icons.badge_outlined, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateAvatarSection() {
    return Column(
      children: [
        Obx(
          () => Stack(
            children: [
              GestureDetector(
                onTap: () {
                  showImageSourceSheet();
                },
                child: Obx(
                  () => Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFE0E7FF), Color(0xFFF5F7FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkCardBorder
                                : AppColors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.white.withValues(alpha: 0.1)
                                  : AppColors.black.withValues(alpha: 0.1),
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                      image:
                          imagePickerController.selectedImage.value != null
                              ? DecorationImage(
                                image: FileImage(
                                  imagePickerController.selectedImage.value!,
                                ),
                                fit: BoxFit.cover,
                              )
                              : controller.avatar.value.isNotEmpty
                              ? DecorationImage(
                                image: NetworkImage(controller.avatar.value),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                    child:
                        imagePickerController.selectedImage.value == null &&
                                controller.avatar.value.isEmpty
                            ? Center(
                              child: Text(
                                "${controller.userModel.value.firstName!.trim().isNotEmpty ? controller.userModel.value.firstName!.trim()[0].toUpperCase() : ''}"
                                "${controller.userModel.value.lastName!.trim().isNotEmpty ? controller.userModel.value.lastName!.trim()[0].toUpperCase() : ''}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 32,
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkPrimary
                                          : AppColors.primary,
                                ),
                              ),
                            )
                            : null,
                  ),
                ),
              ),
              if (imagePickerController.selectedImage.value == null &&
                  controller.avatar.value.isEmpty)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          "${controller.userModel.value.firstName} ${controller.userModel.value.lastName}",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          controller.userModel.value.email ?? "N/A",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextTertiary
                    : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  void showImageSourceSheet() {
    Get.bottomSheet(ImagePickerDropdownBottomSheet());
  }
}
