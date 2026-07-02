import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  final String? rightSideIcon;
  final Widget? pushPage;
  final bool isPopEnabled;
  final bool? showBadge;
  final bool showRightSideIcon;
  final double? padding;
  final int? selectedIndex;
  final GestureTapCallback? onPressed;
  final GestureTapCallback? backLogicFunction;
  final bool? isUtilsBackLogic;

  const CommonAppBar({
    super.key,
    required this.title,
    this.rightSideIcon,
    this.pushPage,
    required this.isPopEnabled,
    this.showBadge = false,
    this.padding = 16,
    this.selectedIndex,
    required this.showRightSideIcon,
    this.onPressed,
    this.isUtilsBackLogic = false,
    this.backLogicFunction,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding!),
      child: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Transform.translate(
              offset: Offset(-05, 0),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap:
                    selectedIndex != null
                        ? () {
                          final navigationController =
                              Get.find<NavigationController>();
                          navigationController.selectedIndex.value =
                              selectedIndex!;
                        }
                        : isUtilsBackLogic == true
                        ? backLogicFunction
                        : () => Get.find<NavigationController>().popPage(),
                child: Image.asset(
                  PngAssets.commonAppBarBackIcon,
                  width: 30,
                  fit: BoxFit.contain,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-05, 0),
              child: Text(
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
            ),
            showRightSideIcon == true
                ? GestureDetector(
                  onTap:
                      isPopEnabled == true
                          ? Get.find<NavigationController>().popPage
                          : pushPage != null
                          ? () => Get.find<NavigationController>().pushPage(
                            pushPage!,
                          )
                          : onPressed,
                  child:
                      showBadge == true
                          ? Badge(
                            smallSize: 8,
                            backgroundColor: Color(0xFFE5544F),
                            child: Image.asset(
                              rightSideIcon!,
                              width: 24,
                              fit: BoxFit.contain,
                            ),
                          )
                          : Image.asset(
                            rightSideIcon!,
                            width: 24,
                            fit: BoxFit.contain,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
