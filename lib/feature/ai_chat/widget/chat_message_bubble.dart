import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/feature/ai_chat/model/chat_message_model.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return _buildUserMessage(context);
    } else {
      return _buildAssistantMessage(context);
    }
  }

  Widget _buildAssistantMessage(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Assistant Mascot Avatar
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.aIPrimaryColor.withValues(
                    alpha: isDark ? 0.20 : 0.30,
                  ),
                  AppColors.aISecondaryColor.withValues(
                    alpha: isDark ? 0.20 : 0.30,
                  ),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.31, 0.85],
              ),
              shape: BoxShape.circle,
              border: isDark
                  ? Border.all(
                      color: AppColors.lightBlueGray.withValues(alpha: 0.35),
                      width: 1,
                    )
                  : null,
            ),
            padding: EdgeInsets.all(6.w),
            child: Image.asset(ImageAssets.navylaAi, fit: BoxFit.contain),
          ),
          SizedBox(width: 10.w),

          // Message Card
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242730) : Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                border: isDark
                    ? Border.all(
                        color: const Color(0xFF5B6069).withValues(alpha: 0.4),
                        width: 1,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _buildFormattedText(message.text, isDark),
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }

  Widget _buildFormattedText(String text, bool isDark) {
    final parts = text.split('**');
    if (parts.length == 1) {
      return Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: isDark ? Colors.white : AppColors.aIMessageColor,
          height: 1.4,
        ),
      );
    }

    final spans = <TextSpan>[];
    for (int i = 0; i < parts.length; i++) {
      final isBold = i % 2 == 1;
      spans.add(
        TextSpan(
          text: parts[i],
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isDark ? Colors.white : AppColors.aIMessageColor,
            height: 1.4,
          ),
        ),
      );
    }

    return Text.rich(TextSpan(children: spans));
  }

  Widget _buildUserMessage(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 40.w),

          // User Message Card (Deep navy blue)
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF04294F)
                    : const Color(0xFF00386C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                  bottomRight: Radius.circular(14.r),
                ),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF193F62)
                      : const Color(0xff61B0FF),
                  width: 1,
                ),
              ),
              child: Text(
                message.text,
                style: GoogleFonts.inter(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.35,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // User Avatar (Profile image)
          Container(
            width: 36.w,
            height: 36.w,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Image.asset(ImageAssets.profile, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
