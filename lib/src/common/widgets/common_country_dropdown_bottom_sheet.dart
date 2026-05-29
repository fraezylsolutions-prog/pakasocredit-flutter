import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/gif/gif_assets.dart';
import 'package:pakaso_credit/src/app/responsive/responsive_utils.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonCountryDropdownBottomSheet extends StatefulWidget {
  final String title;
  final double bottomSheetHeight;
  final List<String> dropdownItems;
  final RxString selectedItem;
  final TextEditingController textController;
  final List<String>? countryImage;
  final List<String>? countryCode;
  final List<String>? countryDialCode;
  final dynamic controller;

  const CommonCountryDropdownBottomSheet({
    super.key,
    required this.dropdownItems,
    required this.selectedItem,
    required this.textController,
    required this.title,
    required this.bottomSheetHeight,
    this.countryImage,
    this.countryCode,
    this.controller,
    this.countryDialCode,
  });

  @override
  State<CommonCountryDropdownBottomSheet> createState() =>
      _CommonCountryDropdownBottomSheetState();
}

class _CommonCountryDropdownBottomSheetState
    extends State<CommonCountryDropdownBottomSheet> {
  final ThemeController themeController = Get.find<ThemeController>();
  late TextEditingController _searchController;
  late List<MapEntry<int, String>> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.dropdownItems.asMap().entries.toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems =
          widget.dropdownItems
              .asMap()
              .entries
              .where(
                (entry) =>
                    entry.value.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColorTop =
        themeController.isDarkMode.value
            ? AppColors.darkSecondary
            : AppColors.white;
    final Color backgroundColorBottom =
        themeController.isDarkMode.value
            ? AppColors.darkSecondary
            : AppColors.white;
    final Color textColor =
        themeController.isDarkMode.value
            ? AppColors.darkTextPrimary
            : AppColors.black;
    final Color subTextColor =
        themeController.isDarkMode.value
            ? AppColors.darkTextTertiary
            : Colors.grey[700]!;
    final Color searchTextColor =
        themeController.isDarkMode.value
            ? AppColors.darkTextPrimary
            : AppColors.black;
    final Color selectedColor =
        themeController.isDarkMode.value
            ? AppColors.darkPrimary.withValues(alpha: 0.05)
            : AppColors.textPrimary.withValues(alpha: 0.05);
    final Color selectedBorderColor =
        themeController.isDarkMode.value
            ? AppColors.darkPrimary.withValues(alpha: 0.1)
            : AppColors.textPrimary.withValues(alpha: 0.1);
    final Color selectedTextColor =
        themeController.isDarkMode.value
            ? AppColors.darkTextPrimary
            : AppColors.textPrimary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuart,
      height: widget.bottomSheetHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColorTop.withValues(alpha: 0.95),
            backgroundColorBottom.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveUtil.scaleSize(context, 28)),
          topRight: Radius.circular(ResponsiveUtil.scaleSize(context, 28)),
        ),
        border: Border.all(
          color:
              themeController.isDarkMode.value
                  ? AppColors.white.withValues(alpha: 0.20)
                  : AppColors.white.withValues(alpha: 0.10),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.4),
            blurRadius: ResponsiveUtil.scaleSize(context, 30),
            spreadRadius: ResponsiveUtil.scaleSize(context, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveUtil.scaleSize(context, 28)),
          topRight: Radius.circular(ResponsiveUtil.scaleSize(context, 28)),
        ),
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: ResponsiveUtil.scaleSize(context, 12)),
                Center(
                  child: Container(
                    width: ResponsiveUtil.scaleSize(context, 60),
                    height: ResponsiveUtil.scaleSize(context, 5),
                    decoration: BoxDecoration(
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.white.withValues(alpha: 0.16)
                              : AppColors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtil.scaleSize(context, 4),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: ResponsiveUtil.scaleSize(context, 16),
                          color: textColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.darkTextPrimary
                                  : AppColors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                        splashRadius: ResponsiveUtil.scaleSize(context, 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtil.scaleSize(context, 24),
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.05),
                      spreadRadius: 0,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterItems,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: subTextColor, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(
                                Icons.close,
                                size: ResponsiveUtil.scaleSize(context, 20),
                                color: subTextColor,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _filterItems('');
                              },
                            )
                            : null,
                    filled: true,
                    fillColor:
                        themeController.isDarkMode.value
                            ? AppColors.darkSecondary.withValues(alpha: 0.95)
                            : AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: searchTextColor, fontSize: 13),
                ),
              ),
            ),
            _filteredItems.isEmpty
                ? _buildEmptyState(textColor, subTextColor)
                : _buildItemsList(
                  textColor,
                  selectedColor,
                  selectedBorderColor,
                  selectedTextColor,
                  themeController,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(
    Color textColor,
    Color selectedColor,
    Color selectedBorderColor,
    Color selectedTextColor,
    ThemeController themeController,
  ) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: ResponsiveUtil.scaleSize(context, 8),
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: ResponsiveUtil.scaleSize(context, 20),
          right: ResponsiveUtil.scaleSize(context, 20),
        ),
        itemBuilder: (context, index) {
          final entry = _filteredItems[index];
          final item = entry.value;
          final originalIndex = entry.key;
          final isSelected = widget.selectedItem.value == item;
          final flag =
              widget.countryImage != null &&
                      originalIndex < widget.countryImage!.length
                  ? widget.countryImage![originalIndex]
                  : null;

          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            margin: EdgeInsets.only(
              bottom: ResponsiveUtil.scaleSize(context, 4),
            ),
            decoration: BoxDecoration(
              color: isSelected ? selectedColor : AppColors.transparent,
              borderRadius: BorderRadius.circular(
                ResponsiveUtil.scaleSize(context, 8),
              ),
              border:
                  isSelected
                      ? Border.all(color: selectedBorderColor, width: 1)
                      : null,
            ),
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  ResponsiveUtil.scaleSize(context, 8),
                ),
                splashColor: selectedTextColor.withValues(alpha: 0.1),
                highlightColor: AppColors.transparent,
                onTap: () {
                  toggleWalletSelection(item, originalIndex);
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtil.scaleSize(
                      context,
                      isSelected ? 10 : 10,
                    ),
                    vertical: ResponsiveUtil.scaleSize(context, 12),
                  ),
                  child: Row(
                    children: [
                      if (flag != null) ...[
                        FadeInImage(
                          placeholder: AssetImage(
                            themeController.isDarkMode.value
                                ? GifAssets.darkLoading
                                : GifAssets.loadingGif,
                          ),
                          image: NetworkImage(flag),
                          width: 24,
                          height: 18,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.error,
                              size: 20,
                              color: Colors.grey,
                            );
                          },
                        ),
                        SizedBox(width: ResponsiveUtil.scaleSize(context, 12)),
                      ],
                      Expanded(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: ResponsiveUtil.scaleSize(context, 14),
                            color: isSelected ? selectedTextColor : textColor,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_rounded,
                          color: selectedTextColor,
                          size: ResponsiveUtil.scaleSize(context, 20),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: _filteredItems.length,
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color subTextColor) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: ResponsiveUtil.scaleSize(context, 60),
            color: subTextColor,
          ),
          SizedBox(height: ResponsiveUtil.scaleSize(context, 16)),
          Text(
            "No country found",
            style: TextStyle(
              fontSize: ResponsiveUtil.scaleSize(context, 18),
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: ResponsiveUtil.scaleSize(context, 8)),
          Text(
            "Try a different search term",
            style: TextStyle(
              fontSize: ResponsiveUtil.scaleSize(context, 14),
              color: subTextColor,
            ),
          ),
        ],
      ),
    );
  }

  void toggleWalletSelection(String item, int index) {
    if (widget.selectedItem.value == item) {
      widget.selectedItem.value = "";
      widget.textController.clear();
    } else {
      widget.selectedItem.value = item;
      widget.textController.text = item;
      if ((widget.countryCode != null && index < widget.countryCode!.length) &&
          (widget.countryDialCode != null &&
              index < widget.countryDialCode!.length)) {
        widget.controller.countryCode.value = widget.countryCode![index];
        widget.controller.countryDialCode.value =
            widget.countryDialCode![index];
      }
    }
  }
}
