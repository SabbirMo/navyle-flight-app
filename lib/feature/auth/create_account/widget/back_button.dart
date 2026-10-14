import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.icon = Icons.arrow_back_ios_new_rounded,
    this.title = '',
    this.image = '',
    this.isImage = false,
    this.subTitle = '',
    this.size,
    this.onTap,
    this.imageSize,
    this.isBorder = false,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subTitle;
  final String? image;
  final bool isImage;
  final double? size;
  final VoidCallback? onTap;
  final double? imageSize;
  final bool isBorder;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final btnSize = size ?? 36.w;
    final button = GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.white.withValues(alpha: 0.2)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: !isBorder
              ? Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.white.withValues(alpha: 0.5)
                      : Colors.transparent,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackShadow.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: (btnSize * 0.44).clamp(14.0, 18.0).sp,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.white
                : AppColors.black,
          ),
        ),
      ),
    );

    final hasTitle = title.trim().isNotEmpty;
    final hasImage =
        image != null &&
        image!.trim().isNotEmpty &&
        (isImage || image!.isNotEmpty);

    if (!hasTitle && !hasImage) {
      return button;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          button,
          Expanded(
            child: Center(
              child: hasImage
                  ? Image.asset(
                      image!,
                      width: imageSize ?? 140.w,
                      fit: BoxFit.contain,
                    )
                  : Column(
                      children: [
                        Text(
                          title,
                          style:
                              StyleManager.sfProSemiBold16(
                                isDark
                                    ? AppColors.white
                                    : AppColors.blackShadow,
                              ).copyWith(
                                letterSpacing: 1,
                                fontWeight: FontWeight.w900,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        if (subTitle != null && subTitle!.isNotEmpty)
                          Text(
                            subTitle!,
                            style: StyleManager.interMedium12(
                              isDark
                                  ? AppColors.white.withValues(alpha: 0.7)
                                  : AppColors.blackShadow,
                            ).copyWith(fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
            ),
          ),
          trailing != null
              ? SizedBox(
                  width: btnSize,
                  height: btnSize,
                  child: Center(child: trailing),
                )
              : SizedBox(width: btnSize),
        ],
      ),
    );
  }
}
