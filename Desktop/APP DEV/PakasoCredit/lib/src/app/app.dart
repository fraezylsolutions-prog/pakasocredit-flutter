import 'package:pakaso_credit/src/app/bindings/initial_binding.dart';
import 'package:pakaso_credit/src/app/config/theme/dark_theme.dart';
import 'package:pakaso_credit/src/app/config/theme/light_theme.dart';
import 'package:pakaso_credit/src/app/constants/app_strings.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/app/routes/routes_handler.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PakasoCreditApp extends StatelessWidget {
  const PakasoCreditApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        initialBinding: InitialBinding(),
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        defaultTransition: Transition.fade,
        transitionDuration: const Duration(milliseconds: 300),
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        theme: LightTheme().lightTheme(context),
        darkTheme: DarkTheme().darkTheme(context),
        getPages: routesHandler,
        initialRoute: BaseRoute.splash,
      ),
    );
  }
}
