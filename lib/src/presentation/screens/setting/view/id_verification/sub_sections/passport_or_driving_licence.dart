import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassportOrDrivingLicence extends StatelessWidget {
  const PassportOrDrivingLicence({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              SizedBox(height: 16),
              CommonAppBar(
                padding: 0,
                title: "id_verification.passport_or_driving.title".trns(),
                isPopEnabled: false,
                showRightSideIcon: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      CommonTextInputField(
                        hintText:
                            "id_verification.passport_or_driving.name_label"
                                .trns(),
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 20),
                      _buildUploadSection(
                        title:
                            "id_verification.passport_or_driving.front_page"
                                .trns(),
                      ),
                      SizedBox(height: 20),
                      _buildUploadSection(
                        title:
                            "id_verification.passport_or_driving.back_page"
                                .trns(),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 30,
                  top: 20,
                ),
                child: CommonElevatedButton(
                  buttonName:
                      "id_verification.passport_or_driving.submit_button"
                          .trns(),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection({required String title}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          PngAssets.commonAttachFile,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Column(
          children: [
            Image.asset(
              PngAssets.commonUploadIcon,
              width: 18,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
