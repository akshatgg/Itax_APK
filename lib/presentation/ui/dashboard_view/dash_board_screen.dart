import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../features/blog/blog_screen.dart';
import '../../features/items/screens/item_screen.dart';
import '../../features/more_screen/more_screen.dart';
import '../../features/parties/screens/parties_screen.dart';
import '../../features/tools/tools_screen.dart';
import 'dashboard_view.dart';

class DashBoardScreen extends StatefulHookWidget {
  const DashBoardScreen({super.key, this.navigationShell});

  final StatefulNavigationShell? navigationShell;

  @override
  State<DashBoardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashBoardScreen> {
/*  final List<String> _screens = [
    AppRoutes.dashboardView.name,
    AppRoutes.partyView.name,
    AppRoutes.itemView.name,
    AppRoutes.reportView.name,
    AppRoutes.moreView.name,
  ];*/
  int currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardView(),
    const ToolsView(),
    const BlogView(),
    const MoreView(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDark ? Colors.lightBlueAccent : Colors.blue;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final unselectedColor = isDark ? Colors.grey[400] : Colors.grey.shade500;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(child: _screens[currentIndex]),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 6.px, horizontal: 8.px),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildNavItem(icon: Icons.home, label: 'Home', index: 0),
              buildNavItem(icon: Icons.build, label: 'Tools', index: 1),
              buildNavItem(
                  icon: Icons.article_outlined, label: 'Blogs', index: 2),
              buildNavItem(icon: Icons.grid_view, label: 'More', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool selected = currentIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => setState(() => currentIndex = index),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.px),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: 4.px, horizontal: 12.px),
                decoration: BoxDecoration(
                  color:
                      selected ? const Color(0xFFE5F0FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: Icon(
                  icon,
                  size: 22.px,
                  color: selected ? Colors.blue : Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 2.px),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: selected ? Colors.blue : Colors.grey.shade500,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
