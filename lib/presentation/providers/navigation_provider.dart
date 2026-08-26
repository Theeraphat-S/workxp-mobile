import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppTab {
  battle(0, 'Battle'),
  worldMap(1, 'World Map'),
  tavern(2, 'Tavern'),
  stats(3, 'Stats'),
  profile(4, 'Profile');

  const AppTab(this.tabIndex, this.label);
  final int tabIndex;
  final String label;
}

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setTab(int index) {
    if (index >= 0 && index < AppTab.values.length) {
      state = index;
    }
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((
  ref,
) {
  return NavigationNotifier();
});
