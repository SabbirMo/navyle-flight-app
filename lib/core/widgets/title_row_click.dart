import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class TitleRowClick extends StatelessWidget {
  const TitleRowClick({
    super.key,
    this.onTap,
    this.isEnable = false,
    required this.title,
    this.subTitle = "",
  });

  final VoidCallback? onTap;
  final bool isEnable;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: StyleManager.interSemiBold12(
            AppColors.black,
          ).copyWith(fontSize: 14.sp),
        ),
        isEnable
            ? InkWell(
                onTap: onTap,
                child: Text(
                  subTitle,
                  style: StyleManager.interMedium12(AppColors.primaryColor),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
