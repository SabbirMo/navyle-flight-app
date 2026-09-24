import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/feed/screen/feed_screen.dart';
import 'package:navyla_flight_app/feature/home/screen/home_screen.dart';
import 'package:navyla_flight_app/feature/more/screen/more_screen.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/feature/navbar/widget/custom_bottom_navbar.dart';
import 'package:navyla_flight_app/feature/scan/screen/scan_screen.dart';
import 'package:navyla_flight_app/feature/ticket/screen/ticket_screen.dart';

class NavbarScreen extends ConsumerWidget {
  const NavbarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navbarNotifierProvider);

    final screens = const [
      HomeScreen(),
      TicketScreen(),
      ScanScreen(),
      FeedScreen(),
      MoreScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: SmoothFadeIndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navbarNotifierProvider.notifier).setIndex(index);
        },
      ),
    );
  }
}

/// High-performance iOS-style smooth crossfade indexed stack
class SmoothFadeIndexedStack extends StatelessWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const SmoothFadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List.generate(children.length, (i) {
        final isActive = i == index;
        return IgnorePointer(
          ignoring: !isActive,
          child: AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.0,
            duration: duration,
            curve: Curves.easeOutCubic,
            child: children[i],
          ),
        );
      }),
    );
  }
}
