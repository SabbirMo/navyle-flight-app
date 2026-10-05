import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onCancel;

  const DeleteAccountDialog({super.key, this.onDelete, this.onCancel});

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onDelete,
    VoidCallback? onCancel,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) =>
          DeleteAccountDialog(onDelete: onDelete, onCancel: onCancel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      elevation: 0,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Delete account?",
              style: TextStyle(
                fontFamily: 'SF-Pro',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: 8.h),

            // Description
            Text(
              "This permanently deletes your profile and history. This cannot be undone.",
              style: GoogleFonts.inter(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF82888E)
                    : const Color(0xFF82888E),
                height: 1.45,
              ),
            ),
            SizedBox(height: 24.h),

            // Action Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context).pop();
                      onCancel?.call();
                    },
                    child: Container(
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF475569)
                              : const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.inter(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Delete Button
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context).pop();
                      onDelete?.call();
                    },
                    child: Container(
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFBA1A1A),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Text(
                          "Delete",
                          style: GoogleFonts.inter(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
