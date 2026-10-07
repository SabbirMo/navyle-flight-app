import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/feature/ai_chat/provider/chat_notifier.dart';
import 'package:navyla_flight_app/feature/ai_chat/widget/chat_app_bar.dart';
import 'package:navyla_flight_app/feature/ai_chat/widget/chat_input_bar.dart';
import 'package:navyla_flight_app/feature/ai_chat/widget/chat_message_bubble.dart';

class AIChatScreen extends ConsumerStatefulWidget {
  const AIChatScreen({super.key});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);
    final messages = chatState.messages;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen(chatNotifierProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length ||
          previous?.isGenerating != next.isGenerating) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020617) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top App Bar
            Container(
              color: isDark ? const Color(0xFF020617) : Colors.white,
              child: Column(
                children: [
                  const ChatAppBar(),
                  if (isDark)
                    Divider(
                      height: 1,
                      thickness: 0.8,
                      color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                    ),
                ],
              ),
            ),

            // 2. Chat Area with Doodle Travel Background
            Expanded(
              child: Stack(
                children: [
                  if (!isDark) ...[
                    // Light mode: Subtle sky blue wash at top fading to clean background
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFEAF2FD),
                              Color(0xFFF7FAFD),
                              Color.fromARGB(255, 245, 238, 238),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomLeft,
                            stops: [0.0, 0.28, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Travel Doodle Art
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.13,
                        child: Image.asset(
                          ImageAssets.askNavyla,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ] else ...[
                    // Dark mode: ask_navyla.png in background, then black color with opacity overlay on top
                    Positioned.fill(
                      child: Image.asset(
                        ImageAssets.askNavyla,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.90),
                      ),
                    ),
                  ],

                  // Chat Messages List with Scrollable Timestamp Header
                  ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: 20.h,
                    ),
                    itemCount: messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 12.h),
                            child: Text(
                              'TODAY, 10:45 AM',
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.lightBlueGray
                                    : AppColors.lightGray,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        );
                      }
                      return ChatMessageBubble(message: messages[index - 1]);
                    },
                  ),
                ],
              ),
            ),

            // 4. Bottom Input Bar
            ChatInputBar(
              isGenerating: chatState.isGenerating,
              onSend: (text) {
                ref.read(chatNotifierProvider.notifier).sendMessage(text);
                _scrollToBottom();
              },
            ),
          ],
        ),
      ),
    );
  }
}
