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
  });

  final IconData icon;
  final String title;
  final String? subTitle;
  final String? image;
  final bool isImage;
  final double? size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final btnSize = size ?? 32.w;
    final button = GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
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
            color: AppColors.black,
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

    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          button,
          Expanded(
            child: Center(
              child: hasImage
                  ? Image.asset(image!, width: 140.w, fit: BoxFit.contain)
                  : Column(
                      children: [
                        Text(
                          title,
                          style: StyleManager.sfProSemiBold16(
                            AppColors.blackShadow,
                          ).copyWith(letterSpacing: 1),
                          textAlign: TextAlign.center,
                        ),
                        if (subTitle != null && subTitle!.isNotEmpty)
                          Text(
                            subTitle!,
                            style: StyleManager.interMedium12(
                              AppColors.blackShadow,
                            ).copyWith(fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
            ),
          ),
          SizedBox(width: btnSize),
        ],
      ),
    );
  }
}
