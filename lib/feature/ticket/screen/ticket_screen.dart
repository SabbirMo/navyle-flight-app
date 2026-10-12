import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/utils/app_share_helper.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/ticket/model/saved_ticket_model.dart';
import 'package:navyla_flight_app/feature/ticket/provider/saved_tickets_provider.dart';
import 'package:navyla_flight_app/feature/ticket/widget/add_boarding_pass_view.dart';
import 'package:navyla_flight_app/feature/ticket/widget/delete_ticket_bottom_sheet.dart';
import 'package:navyla_flight_app/feature/ticket/widget/ticket_boarding_pass.dart';
import 'package:navyla_flight_app/feature/ticket/widget/ticket_options_dialog.dart';
import 'package:navyla_flight_app/feature/ticket/widget/original_ticket_viewer_dialog.dart';
import 'package:navyla_flight_app/feature/ticket/widget/download_ticket_dialog.dart';

class TicketScreen extends ConsumerStatefulWidget {
  const TicketScreen({super.key});

  @override
  ConsumerState<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends ConsumerState<TicketScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialIndex = ref.read(savedTicketsProvider).selectedIndex;
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(
    BuildContext context,
    SavedTicketModel selectedTicket,
  ) {
    DeleteTicketBottomSheet.show(
      context,
      flightNumber: selectedTicket.flightNumber,
      originCode: selectedTicket.originCode,
      destinationCode: selectedTicket.destinationCode,
      onDelete: () {
        final ticketIndexToDelete = ref
            .read(savedTicketsProvider)
            .selectedIndex;
        ref
            .read(savedTicketsProvider.notifier)
            .removeTicket(ticketIndexToDelete);

        final updatedTickets = ref.read(savedTicketsProvider).tickets;
        if (updatedTickets.isNotEmpty) {
          final newIndex = ref.read(savedTicketsProvider).selectedIndex;
          final nextTicket = updatedTickets[newIndex];

          if (_pageController.hasClients &&
              _pageController.page?.round() != newIndex) {
            _pageController.jumpToPage(newIndex);
          }

          // Sync active flight journey to the newly selected remaining ticket
          ref
              .read(flightJourneyNotifierProvider.notifier)
              .addBoardingPass(
                flightNumber: nextTicket.flightNumber,
                originCode: nextTicket.originCode,
                originCity: nextTicket.originCity,
                destinationCode: nextTicket.destinationCode,
                destinationCity: nextTicket.destinationCity,
                terminal: nextTicket.terminal,
                gate: nextTicket.gate,
                seat: nextTicket.seat,
                flightDate: nextTicket.displayDate,
              );
        } else {
          // If all tickets were deleted, remove active flight journey so empty state appears
          ref.read(flightJourneyNotifierProvider.notifier).removeBoardingPass();
        }
      },
    );
  }

  void _showTicketOptionsMenu(BuildContext context) {
    final ticketsState = ref.read(savedTicketsProvider);
    final selectedTicket = ticketsState.currentTicket;
    if (selectedTicket == null) return;

    TicketOptionsDialog.show(
      context,
      ticket: selectedTicket,
      onViewOriginal: () {
        Navigator.of(context).pop();
        OriginalTicketViewerDialog.show(context, selectedTicket);
      },
      onShare: () {
        Navigator.of(context).pop();
        AppShareHelper.shareBoardingPass(
          context,
          flightNumber: selectedTicket.flightNumber,
          originCode: selectedTicket.originCode,
          destinationCode: selectedTicket.destinationCode,
          airlineName: selectedTicket.airlineName,
          passengerName: selectedTicket.passengerName,
          date: selectedTicket.displayDate,
          seat: selectedTicket.seat,
          gate: selectedTicket.gate,
          terminal: selectedTicket.terminal,
        );
      },
      onDownload: () {
        Navigator.of(context).pop();
        DownloadTicketDialog.show(context, selectedTicket);
      },
      onDelete: () {
        Navigator.of(context).pop();
        _showDeleteConfirmation(context, selectedTicket);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final journey = ref.watch(flightJourneyNotifierProvider);
    final ticketsState = ref.watch(savedTicketsProvider);
    final tickets = ticketsState.tickets;
    final selectedIndex = ticketsState.selectedIndex;

    final hasPass = journey.hasActiveFlight;
    final isViewingAddPass = !hasPass || ticketsState.isViewingAddPass;

    // Listen to changes in selected ticket from outside (e.g. AddBoardingPassView)
    ref.listen<SavedTicketsState>(savedTicketsProvider, (prev, next) {
      if (next.selectedIndex != prev?.selectedIndex &&
          next.selectedIndex < tickets.length &&
          _pageController.hasClients &&
          _pageController.page?.round() != next.selectedIndex) {
        _pageController.jumpToPage(next.selectedIndex);
      }
    });
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.blackShadow : null,
          gradient: isDark ? null : AppColors.splashGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: isViewingAddPass
              ? AddBoardingPassView(
                  onBackToTicket: hasPass
                      ? () => ref
                            .read(savedTicketsProvider.notifier)
                            .hideAddPass()
                      : null,
                )
              : _buildTicketCarouselView(
                  context,
                  tickets,
                  selectedIndex,
                  bottomInset,
                ),
        ),
      ),
    );
  }

  Widget _buildTicketCarouselView(
    BuildContext context,
    List<SavedTicketModel> tickets,
    int selectedIndex,
    double bottomInset,
  ) {
    final totalCount = tickets.isEmpty ? 1 : tickets.length;
    final displayIndex = (selectedIndex < totalCount) ? selectedIndex + 1 : 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // Top Bar: '1 OF 3' on left, 'TICKET' in center, 3-dots on right (NO back button)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Center Title
                Center(
                  child: Text(
                    'TICKET',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // Top Left: '1 OF 3' Capsule Badge
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(savedTicketsProvider.notifier).showAddPass();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFFA7E23).withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        '$displayIndex OF $totalCount',
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                // Top Right: Circular 3-dots button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => _showTicketOptionsMenu(context),
                    child: Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightGray.withValues(alpha: 0.2),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.more_vert,
                          color: isDark
                              ? AppColors.white
                              : AppColors.blackShadow,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Main Swipeable Ticket Cards + Indicator
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 6.h),
                SizedBox(
                  height: 458.h,
                  child: tickets.isEmpty
                      ? const SizedBox.shrink()
                      : PageView.builder(
                          controller: _pageController,
                          itemCount: tickets.length,
                          onPageChanged: (index) {
                            ref
                                .read(savedTicketsProvider.notifier)
                                .selectTicket(index);
                            final ticket = tickets[index];
                            ref
                                .read(flightJourneyNotifierProvider.notifier)
                                .addBoardingPass(
                                  flightNumber: ticket.flightNumber,
                                  originCode: ticket.originCode,
                                  originCity: ticket.originCity,
                                  destinationCode: ticket.destinationCode,
                                  destinationCity: ticket.destinationCity,
                                  terminal: ticket.terminal,
                                  gate: ticket.gate,
                                  seat: ticket.seat,
                                  flightDate: ticket.displayDate,
                                );
                          },
                          itemBuilder: (context, index) {
                            final ticket = tickets[index];
                            return Center(
                              child: TicketBoardingPass(
                                airlineName: ticket.airlineName,
                                flightClass: ticket.flightClass,
                                flightNumber: ticket.flightNumber,
                                originCode: ticket.originCode,
                                originCity: ticket.originCity,
                                destinationCode: ticket.destinationCode,
                                destinationCity: ticket.destinationCity,
                                date: ticket.date,
                                departureTime: ticket.departureTime,
                                boardingTime: ticket.boardingTime,
                                passengerName: ticket.passengerName,
                                terminal: ticket.terminal,
                                gate: ticket.gate,
                                seat: ticket.seat,
                                luggage: ticket.luggage,
                                primaryColor: ticket.effectivePrimaryColor,
                                secondaryColor: ticket.effectiveSecondaryColor,
                                planeIconColor: ticket.effectivePlaneIconColor,
                                airlineLogoColor:
                                    ticket.effectiveAirlineLogoColor,
                                economyBgColor: ticket.effectiveEconomyBgColor,
                                economyTextColor:
                                    ticket.effectiveEconomyTextColor,
                                logoWidget: _buildTicketLogo(ticket),
                              ),
                            );
                          },
                        ),
                ),

                SizedBox(height: 10.h),

                // Page Indicator Dots (closely under card, exactly like Image 2)
                if (tickets.length > 1)
                  _buildDotsIndicator(tickets.length, selectedIndex),
              ],
            ),
          ),

          // Bottom clearance for floating CustomBottomNavBar
          SizedBox(height: 72.h + bottomInset),
        ],
      ),
    );
  }

  Widget _buildDotsIndicator(int count, int activeIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return GestureDetector(
          onTap: () {
            ref.read(savedTicketsProvider.notifier).selectTicket(index);
            if (_pageController.hasClients) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.5.w, vertical: 4.h),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              width: isActive ? 8.w : 7.w,
              height: isActive ? 8.w : 7.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? const Color(0xFF007AFF)
                    : const Color(0xFF475569),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: const Color(0xFF007AFF).withValues(alpha: 0.4),
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTicketLogo(SavedTicketModel ticket) {
    final logoBg =
        ticket.airlineLogoColor ??
        (ticket.airlineName == 'LUFTHANSA'
            ? const Color(0xFF0B1B3D)
            : ticket.airlineName == 'WIZZ AIR'
            ? const Color(0xFF9A84F8)
            : const Color(0xff2563EB));

    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: logoBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Transform.rotate(
          angle: 0.785398,
          child: Icon(Icons.flight, color: Colors.white, size: 16.sp),
        ),
      ),
    );
  }
}
