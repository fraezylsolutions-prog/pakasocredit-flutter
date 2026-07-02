import 'package:pakaso_credit/src/app/constants/assets_path/json/json_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CommonLoading extends StatelessWidget {
  const CommonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Center(
      child: Lottie.asset(
        themeController.isDarkMode.value
            ? JsonAssets.darkLoadingJson
            : JsonAssets.loadingJson,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
        repeat: true,
      ),
    );
  }
}
