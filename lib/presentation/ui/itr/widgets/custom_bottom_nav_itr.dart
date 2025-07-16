import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomBottomNavBarItr extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBarItr({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
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
          _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
          _buildNavItem(icon: Icons.build, label: 'Tools', index: 1),
          _buildNavItem(icon: Icons.article_outlined, label: 'Blogs', index: 2),
          _buildNavItem(icon: Icons.grid_view, label: 'More', index: 3),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool selected = currentIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => onItemSelected(index),
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
                  borderRadius: BorderRadius.circular(12),
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
