import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'home_page.dart';
import 'settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final _navKeys = [GlobalKey<NavigatorState>(), GlobalKey<NavigatorState>()];

  final List<Widget> _pages = [const HomePage(), const Settings()];

  Widget _tab(int i) => Navigator(
    key: _navKeys[i],
    onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => _pages[i]),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        final nav = _navKeys[currentIndex].currentState!;
        if (nav.canPop()) nav.pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: IndexedStack(index: currentIndex, children: [_tab(0), _tab(1)]),
        bottomNavigationBar: Container(
          color: Colors.black,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1B22),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: GNav(
              selectedIndex: currentIndex,
              onTabChange: (value) {
                if (value == currentIndex) {
                  _navKeys[value].currentState!.popUntil((r) => r.isFirst);
                }
                setState(() => currentIndex = value);
              },
              gap: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.white54,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.deepPurple.withValues(alpha: 0.35),
              tabBorderRadius: 16,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              tabs: const [
                GButton(icon: Icons.home_rounded, text: 'Home'),
                GButton(icon: Icons.settings_rounded, text: 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
