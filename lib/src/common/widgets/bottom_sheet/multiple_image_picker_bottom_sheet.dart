import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/image_picker/multiple_image_picker_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultipleImagePickerBottomSheet extends StatelessWidget {
  final int attachmentId;

  const MultipleImagePickerBottomSheet({required this.attachmentId, super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final MultipleImagePickerController multipleImagePickerController =
        Get.find<MultipleImagePickerController>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuart,
      height: 230,
      decoration: BoxDecoration(
        color:
            themeController.isDarkMode.value
                ? AppColors.darkSecondary
                : AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border.all(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkCardBorder
                  : AppColors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 0,
                    height: 5,
                    decoration: BoxDecoration(
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.white.withValues(alpha: 0.3)
                              : AppColors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select Image Source",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.white
                                  : AppColors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(20, 0),
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.white
                                    : AppColors.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                          splashRadius: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap:
                      () => multipleImagePickerController.pickImageFromCamera(
                        attachmentId,
                      ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkCardBorder
                                    : AppColors.textTertiary.withValues(
                                      alpha: 0.2,
                                    ),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.asset(
                          PngAssets.cameraCommonIconTwo,
                          width: 30,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.white
                                  : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.white
                                  : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap:
                      () => multipleImagePickerController.pickImageFromGallery(
                        attachmentId,
                      ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkCardBorder
                                    : AppColors.textTertiary.withValues(
                                      alpha: 0.2,
                                    ),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.asset(
                          PngAssets.galleryCommonIcon,
                          width: 30,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.white
                                  : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.white
                                  : AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
