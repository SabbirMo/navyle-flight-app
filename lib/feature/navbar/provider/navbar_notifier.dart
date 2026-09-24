import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavbarNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setIndex(int index) {
    if (state != index) {
      state = index;
    }
  }

  void reset() {
    state = 0;
  }
}

final navbarNotifierProvider = NotifierProvider<NavbarNotifier, int>(
  NavbarNotifier.new,
);
