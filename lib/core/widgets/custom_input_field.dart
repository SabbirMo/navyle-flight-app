import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class CustomInputField extends StatelessWidget {
  final String? label;
  final bool isRequired;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final double? height;
  final double? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? prefixIconColor;
  final double? prefixIconSize;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Color? asteriskColor;
  final EdgeInsetsGeometry? contentPadding;

  const CustomInputField({
    super.key,
    this.label,
    this.isRequired = true,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.height,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.prefixIconColor,
    this.prefixIconSize,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.asteriskColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 24.r;
    final effectiveHeight = height ?? (validator == null ? 46.h : null);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Widget inputField = TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      maxLines: maxLines,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      validator: validator,
      inputFormatters: inputFormatters,
      style:
          style ??
          StyleManager.interMedium13(
            isDark ? AppColors.white : AppColors.black,
          ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor:
            fillColor ??
            (isDark ? AppColors.blackShadow : AppColors.lightBgColor),
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        hintText: hintText,
        hintStyle:
            hintStyle ?? StyleManager.interRegular13(AppColors.lightGray),
        prefixIconConstraints: (prefixIcon != null || prefixWidget != null)
            ? BoxConstraints(minWidth: 40.w, minHeight: 20.w)
            : null,
        prefixIcon:
            prefixWidget ??
            (prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(left: 14.w, right: 8.w),
                    child: Icon(
                      prefixIcon,
                      size: prefixIconSize ?? 18.sp,
                      color: prefixIconColor ?? const Color(0xFF9CA3AF),
                    ),
                  )
                : null),
        suffixIconConstraints: suffixIcon != null
            ? BoxConstraints(minWidth: 40.w, minHeight: 20.w)
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: suffixIcon,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: borderColor ?? const Color(0xFFE5E7EB),
            width: 1.1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color:
                borderColor ??
                (isDark ? Color(0xff5B5F69) : const Color(0xFFE5E7EB)),
            width: 1.1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: focusedBorderColor ?? AppColors.primaryColor,
            width: 1.3,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.3),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: (borderColor ?? const Color(0xFFE5E7EB)).withValues(
              alpha: 0.6,
            ),
            width: 1.1,
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null && label!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 6.h, left: 4.w),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style:
                        labelStyle ??
                        StyleManager.interMedium13(
                          isDark ? AppColors.white : const Color(0xFF374151),
                        ),
                  ),
                  if (isRequired)
                    TextSpan(
                      text: " *",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: asteriskColor ?? const Color(0xFFEF4444),
                      ),
                    ),
                ],
              ),
            ),
          ),
        if (effectiveHeight != null)
          SizedBox(height: effectiveHeight, child: inputField)
        else
          inputField,
      ],
    );
  }
}
