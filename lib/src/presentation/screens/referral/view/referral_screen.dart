import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/referral/controller/referral_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final ReferralController referralController = Get.put(ReferralController());

  @override
  void initState() {
    super.initState();
    referralController.fetchReferralInfo();
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
            SingleChildScrollView(
              child: Obx(() {
                final referral =
                    referralController.referralInfoModel.value.data;

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.primary, Color(0xFFB357FF)],
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Transform.translate(
                                    offset: Offset(-05, 0),
                                    child: GestureDetector(
                                      onTap:
                                          () =>
                                              Get.find<NavigationController>()
                                                  .popPage(),
                                      child: Image.asset(
                                        PngAssets.commonAppBarBackIcon,
                                        width: 24,
                                        fit: BoxFit.contain,
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "referral.title".trns(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:
                                        () => Get.find<NavigationController>()
                                            .pushNamed(
                                              BaseRoute.referredFriends,
                                            ),
                                    child: Image.asset(
                                      PngAssets.commonClockIcon,
                                      width: 20,
                                      fit: BoxFit.contain,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 50),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "referral.referralText".trnsFormat({
                                    "referral_text": referral?.text ?? "",
                                  }),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 23),
                              Image.asset(
                                PngAssets.fiImage,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 44,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Color(
                                          0xFFFFFFFF,
                                        ).withValues(alpha: 0.20),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            referral?.link ?? "",
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            VerticalDivider(
                                              color: Color(
                                                0xFFFFFFFF,
                                              ).withValues(alpha: 0.20),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                    text: referral?.link ?? "",
                                                  ),
                                                );
                                                Fluttertoast.showToast(
                                                  msg: "referral.copied".trns(),
                                                  backgroundColor:
                                                      AppColors.success,
                                                );
                                              },
                                              child: Image.asset(
                                                PngAssets.commonCopyIcon,
                                                width: 16,
                                                color: AppColors.white,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "referral.referralJoined".trnsFormat({
                                      "referral_joined":
                                          referral?.joinedText ?? "",
                                    }),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              CommonElevatedButton(
                                backgroundColor: Color(0xFF24A1DE),
                                fontWeight: FontWeight.w600,
                                borderRadius: 100,
                                iconSpacing: 4,
                                textColor: AppColors.white,
                                width: 102,
                                height: 35,
                                buttonName: "referral.share".trns(),
                                onPressed: () {
                                  SharePlus.instance.share(
                                    ShareParams(text: referral?.link ?? ""),
                                  );
                                },
                                leftIcon: Icon(
                                  Icons.share,
                                  color: AppColors.white,
                                  size: 14,
                                ),
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Image.asset(
                            PngAssets.referralShape,
                            width: 245,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    if (referral?.isShownReferralRules == true)
                      SizedBox(height: 40),
                    if (referral?.isShownReferralRules == true)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children:
                              referral!.rules!.map((item) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(3),
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              100,
                                            ),
                                            color:
                                                item.icon == "tick"
                                                    ? AppColors.success
                                                    : AppColors.error,
                                          ),
                                          child: Image.asset(
                                            item.icon == "tick"
                                                ? PngAssets.commonTickIcon
                                                : PngAssets.commonCancelIcon,
                                            width: 12,
                                            fit: BoxFit.contain,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            item.rule ?? "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors
                                                          .darkTextPrimary
                                                      : AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    SizedBox(height: 20),
                  ],
                );
              }),
            ),
            Obx(
              () => Visibility(
                visible: referralController.isLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
