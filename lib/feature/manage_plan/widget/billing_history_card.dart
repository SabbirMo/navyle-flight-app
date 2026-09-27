import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class BillingHistoryItem {
  final String title;
  final String dateAndInvoice;
  final String amount;

  const BillingHistoryItem({
    required this.title,
    required this.dateAndInvoice,
    required this.amount,
  });
}

class BillingHistoryCard extends StatelessWidget {
  final List<BillingHistoryItem>? items;

  const BillingHistoryCard({super.key, this.items});

  static const List<BillingHistoryItem> defaultItems = [
    BillingHistoryItem(
      title: "Monthly",
      dateAndInvoice: "Apr 14, 2026 · INV-204",
      amount: "\$9.99",
    ),
    BillingHistoryItem(
      title: "Monthly",
      dateAndInvoice: "Mar 14, 2026 · INV-188",
      amount: "\$9.99",
    ),
    BillingHistoryItem(
      title: "Monthly",
      dateAndInvoice: "Feb 14, 2026 · INV-172",
      amount: "\$9.99",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final list = items ?? defaultItems;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.lightGray.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: List.generate(list.length, (index) {
          final item = list[index];
          final isLast = index == list.length - 1;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          style: StyleManager.sfProSemiBold16(AppColors.black),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.dateAndInvoice,
                          style: StyleManager.interMedium12(
                            AppColors.lightGray,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      item.amount,
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8A817A),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Divider(
                    height: 1,
                    thickness: 0.8,
                    color: AppColors.lightGray.withValues(alpha: 0.2),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
