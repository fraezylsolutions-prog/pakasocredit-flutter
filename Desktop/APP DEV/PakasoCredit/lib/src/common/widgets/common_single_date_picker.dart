import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommonSingleDatePicker extends StatefulWidget {
  final String? hintText;
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;

  const CommonSingleDatePicker({
    super.key,
    this.hintText,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  State<CommonSingleDatePicker> createState() => _CommonSingleDatePickerState();
}

class _CommonSingleDatePickerState extends State<CommonSingleDatePicker> {
  final ThemeController themeController = Get.find<ThemeController>();
  late DateTime _selectedDay;
  late TextEditingController _dateController;

  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate ?? DateTime.now();
    _dateController = TextEditingController(
      text:
          widget.initialDate != null
              ? dateFormat.format(widget.initialDate!)
              : '',
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        color:
            (themeController.isDarkMode.value
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      controller: _dateController,
      onTap: () {
        _selectDate(context, _selectedDay, _dateController);
      },
      readOnly: true,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.date_range_outlined,
          size: 18,
          color: Colors.grey.shade400,
        ),
        contentPadding: const EdgeInsets.only(left: 16, right: 16),
        fillColor:
            themeController.isDarkMode.value
                ? AppColors.transparent
                : AppColors.white,
        filled: true,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkTextTertiary
                  : AppColors.textTertiary,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color:
                themeController.isDarkMode.value
                    ? Color(0xFF5D6765)
                    : AppColors.black.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color:
                themeController.isDarkMode.value
                    ? Color(0xFF5D6765)
                    : AppColors.black.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color:
                themeController.isDarkMode.value
                    ? Color(0xFF5D6765)
                    : AppColors.black.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime selectedDate,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showRoundedDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.utc(1900, 1, 1),
      lastDate: DateTime.now(),
      borderRadius: 6,
      height: MediaQuery.of(context).size.height * 0.4,
      theme: ThemeData(
        colorScheme:
            themeController.isDarkMode.value
                ? ColorScheme.dark(
                  primary: AppColors.darkPrimary,
                  surface: AppColors.darkBackground,
                )
                : ColorScheme.light(
                  primary: AppColors.primary,
                  surface: AppColors.white,
                ),
      ),
      styleDatePicker: MaterialRoundedDatePickerStyle(
        textStyleYearButton: TextStyle(
          color:
              themeController.isDarkMode.value
                  ? AppColors.black
                  : AppColors.white,
          fontSize: 20,
        ),
        textStyleDayButton: TextStyle(
          color:
              themeController.isDarkMode.value
                  ? AppColors.black
                  : AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        textStyleButtonPositive: TextStyle(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkPrimary
                  : AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textStyleButtonNegative: TextStyle(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkPrimary
                  : AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        backgroundHeader:
            themeController.isDarkMode.value
                ? AppColors.darkPrimary
                : AppColors.primary,
        textStyleDayOnCalendarSelected: TextStyle(
          color:
              themeController.isDarkMode.value
                  ? AppColors.black
                  : AppColors.white,
        ),
      ),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        _selectedDay = picked;
        widget.onDateSelected(picked);
        controller.text = dateFormat.format(picked);
      });
    }
  }
}
