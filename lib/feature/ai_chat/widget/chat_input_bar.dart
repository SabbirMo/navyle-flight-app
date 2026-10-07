import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isGenerating;

  const ChatInputBar({
    super.key,
    required this.onSend,
    this.isGenerating = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isGenerating) return;
    _controller.clear();
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 12.h,
        bottom: 12.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF020617) : Colors.white,
        borderRadius: isDark
            ? null
            : BorderRadius.vertical(top: Radius.circular(24.r)),
        border: isDark
            ? Border(
                top: BorderSide(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                  width: 1,
                ),
              )
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B1E2E) : const Color(0xFFF4F7FB),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF2E3547).withValues(alpha: 0.6)
                  : const Color(0xFFE2E8F0).withValues(alpha: 0.6),
              width: 1,
            ),
          ),
          padding: EdgeInsets.only(left: 18.w, right: 4.w),
          child: Row(
            children: [
              // Text Field - override all theme borders and fills
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Ask anything...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF94A3B8),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),

              // Deep Navy Blue Send Button
              GestureDetector(
                onTap: _handleSend,
                behavior: HitTestBehavior.opaque,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: widget.isGenerating ? 0.6 : 1.0,
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF003D72)
                          : const Color(0xFF00386C),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
                        child: Transform.rotate(
                          angle: -math.pi / 4,
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 17.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
