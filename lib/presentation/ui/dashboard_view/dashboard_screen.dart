import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../features/items/screens/item_screen.dart';
import '../../features/more_screen/more_screen.dart';
import '../../features/parties/screens/parties_screen.dart';
import '../itr/widgets/custom_bottom_nav_itr.dart';
import 'dashboard_view.dart';

class DashboardScreen extends StatefulHookWidget {
  const DashboardScreen(
      {super.key, required StatefulNavigationShell navigationShell});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardView(),
    PartiesView(),
    ItemView(),
    MoreView(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFCFC),
        body: _screens[currentIndex],
        bottomNavigationBar: CustomBottomNavBarItr(
          currentIndex: currentIndex,
          onItemSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
