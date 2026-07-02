import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/virtual_card/controller/create_new_card_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardHolderTabSection extends StatelessWidget {
  final CreateNewCardController createNewCardController;

  const CardHolderTabSection({
    super.key,
    required this.createNewCardController,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color:
            themeController.isDarkMode.value
                ? Color(0xFF1C2E24)
                : Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () => Row(
          children: [
            _buildTabItem(
              label: "virtualCard.create_card.holder.tabs.existing".trns(),
              isSelected: createNewCardController.selectedTab.value,
              onTap: () => createNewCardController.selectedTab.value = true,
            ),
            _buildTabItem(
              label: "virtualCard.create_card.holder.tabs.new".trns(),
              isSelected: !createNewCardController.selectedTab.value,
              onTap: () => createNewCardController.selectedTab.value = false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          overlayColor:
              themeController.isDarkMode.value
                  ? AppColors.darkPrimary
                  : AppColors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide.none,
          backgroundColor:
              isSelected
                  ? themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.white
                  : AppColors.transparent,
        ),
        onPressed: onTap,
        child: Text(
          textAlign: TextAlign.center,
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11.5,
            color:
                themeController.isDarkMode.value
                    ? isSelected
                        ? AppColors.black
                        : AppColors.white
                    : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
