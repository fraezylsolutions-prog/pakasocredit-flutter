import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // For animations

class CommonNoDataFound extends StatefulWidget {
  final String? message;
  final String? subMessage;
  final bool showTryAgainButton;
  final VoidCallback? onTryAgain;

  const CommonNoDataFound({
    super.key,
    this.message,
    this.subMessage,
    this.showTryAgainButton = false,
    this.onTryAgain,
  });

  @override
  State<CommonNoDataFound> createState() => _CommonNoDataFoundState();
}

class _CommonNoDataFoundState extends State<CommonNoDataFound>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Center(
      child: FadeTransition(
        opacity: _animation,
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                themeController.isDarkMode.value
                    ? "assets/others/loading/dark_empty_box.json"
                    : 'assets/others/loading/empty_box.json',
                width: 180,
                height: 180,
                repeat: true,
              ),
              const SizedBox(height: 16),
              Text(
                widget.message ?? "common.noDataFound.noDataFound".trns(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  widget.subMessage ??
                      "common.noDataFound.refreshingText".trns(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextTertiary
                            : AppColors.textTertiary,
                    height: 1.4,
                  ),
                ),
              ),
              if (widget.showTryAgainButton) ...[
                const SizedBox(height: 20),
                CommonElevatedButton(
                  width: 86,
                  height: 36,
                  buttonName: "common.noDataFound.tryAgainButtonText".trns(),
                  onPressed: widget.onTryAgain!,
                  borderRadius: 8,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
