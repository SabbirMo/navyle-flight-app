import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/feed/screen/feed_screen.dart';
import 'package:navyla_flight_app/feature/home/screen/home_screen.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/feature/navbar/widget/custom_bottom_navbar.dart';
import 'package:navyla_flight_app/feature/scan/screen/scan_screen.dart';
import 'package:navyla_flight_app/feature/setting/setting/screen/setting_screen.dart';
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
      SettingScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navbarNotifierProvider.notifier).setIndex(index);
        },
      ),
    );
  }
}
