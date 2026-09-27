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

    ref.listen(chatNotifierProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length ||
          previous?.isGenerating != next.isGenerating) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top App Bar with Solid White Background
            Container(
              color: Colors.white,
              child: ChatAppBar(
                onInfoTap: () {
                  // _showFlightInfoModal(context);
                },
              ),
            ),

            // 2. Chat Area with Doodle Travel Background & Subtle Sky Glow
            Expanded(
              child: Stack(
                children: [
                  // Subtle sky blue wash at top fading to clean background
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

                  // Travel Doodle Art from assets/images/ask_navyla.png
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.13,
                      child: Image.asset(
                        ImageAssets.askNavyla,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

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
                            padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
                            child: Text(
                              'TODAY, 10:45 AM',
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.lightGray,
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

            // 4. Bottom Input Bar with Pure White Container
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

  // void _showFlightInfoModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: EdgeInsets.all(20.w),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Center(
  //               child: Container(
  //                 width: 40.w,
  //                 height: 4.h,
  //                 decoration: BoxDecoration(
  //                   color: const Color(0xFFE2E8F0),
  //                   borderRadius: BorderRadius.circular(2.r),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 16.h),
  //             Text(
  //               'Flight Assistant Details',
  //               style: GoogleFonts.inter(
  //                 fontSize: 16.sp,
  //                 fontWeight: FontWeight.bold,
  //                 color: const Color(0xFF0F172A),
  //               ),
  //             ),
  //             SizedBox(height: 12.h),
  //             _buildInfoRow('Flight', 'British Airways BA 0215'),
  //             _buildInfoRow('Route', 'London (LHR) -> New York (JFK)'),
  //             _buildInfoRow('Departure', '11:55 AM, Terminal 5'),
  //             _buildInfoRow('Gate', 'Gate B22 (Boarding at 11:15 AM)'),
  //             SizedBox(height: 16.h),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildInfoRow(String label, String value) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 4.h),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: GoogleFonts.inter(
  //             fontSize: 13.sp,
  //             color: const Color(0xFF64748B),
  //           ),
  //         ),
  //         Text(
  //           value,
  //           style: GoogleFonts.inter(
  //             fontSize: 13.sp,
  //             fontWeight: FontWeight.w600,
  //             color: const Color(0xFF0F172A),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
