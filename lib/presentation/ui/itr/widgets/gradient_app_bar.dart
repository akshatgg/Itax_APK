import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;
  final List<Widget>? actionWidgets;

  const GradientAppBar({
    super.key,
    required this.title,
    required this.onBack,
    this.actionWidgets,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: actionWidgets != null && actionWidgets!.isNotEmpty
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: actionWidgets!,
                ),
              ),
            ]
          : null,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFFEF4444)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
