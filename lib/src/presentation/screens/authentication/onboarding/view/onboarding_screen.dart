import 'package:carousel_slider/carousel_slider.dart';
import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/onboarding/controller/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final OnboardingController controller = Get.put(OnboardingController());
  CarouselSliderController carouselController = CarouselSliderController();

  final List<Map<String, String>> _staticContent = [
    {
      "title": "Fund Transfer",
      "subTitle": "Transfer funds securely and instantly with Pakaso Credit.",
    },
    {
      "title": "Easy Deposits",
      "subTitle": "Add money to your wallet effortlessly.",
    },
    {
      "title": "Virtual Cards",
      "subTitle": "Generate virtual cards for safe online shopping.",
    },
  ];

  @override
  void initState() {
    super.initState();
    controller.fetchOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor:
            themeController.isDarkMode.value
                ? AppColors.darkBackground
                : AppColors.primary,
      ),
      body: ColoredBox(
        color:
            themeController.isDarkMode.value
                ? AppColors.darkBackground
                : AppColors.background,
        child: Obx(
          () =>
              controller.isLoading.value
                  ? CommonLoading()
                  : Stack(
                    children: [
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Image.asset(
                          PngAssets.welcomeShapeFive,
                          color:
                              themeController.isDarkMode.value
                                  ? Color(0xFF1C2E24)
                                  : Color(0xFFF2EAFF),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Image.asset(
                          themeController.isDarkMode.value
                              ? PngAssets.welcomeDarkShapeSix
                              : PngAssets.welcomeShapeSix,
                        ),
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: CarouselSlider.builder(
                              carouselController: carouselController,
                              itemCount: _staticContent.length,
                              itemBuilder: (context, index, realIndex) {
                                final imageUrl = (controller.onboardingModel.value.data != null && index < controller.onboardingModel.value.data!.length) 
                                    ? controller.onboardingModel.value.data![index] 
                                    : "";
                                
                                final staticData = _staticContent[index];
                                return onBoardingPage(
                                  imageUrl: imageUrl,
                                  title: staticData["title"]!,
                                  subTitle: staticData["subTitle"]!,
                                  themeController: themeController,
                                );
                              },
                              options: CarouselOptions(
                                height: MediaQuery.of(context).size.height * 0.6,
                                viewportFraction: 1.0,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  controller.currentPage.value = index;
                                },
                                autoPlay: false,
                                enlargeCenterPage: false,
                              ),
                            ),
                          ),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _staticContent.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    controller.currentPage.value = index;
                                    carouselController.animateToPage(index);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: controller.currentPage.value == index
                                          ? (themeController.isDarkMode.value ? AppColors.darkPrimary : AppColors.primary)
                                          : AppColors.grey.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          CommonElevatedButton(
                            fontSize: 16,
                            buttonName: "Get Started",
                            onPressed: () => Get.toNamed(BaseRoute.signIn),
                            width: 200,
                            fontFamily: "Inter",
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget onBoardingPage({
    required String imageUrl,
    required String title,
    required String subTitle,
    required ThemeController themeController,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imageUrl.isNotEmpty) Image.network(imageUrl, height: 200, errorBuilder: (_, __, ___) => Icon(Icons.account_balance, size: 100, color: AppColors.primary)),
        SizedBox(height: 40),
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: themeController.isDarkMode.value ? AppColors.darkPrimary : AppColors.primary,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
