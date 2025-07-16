import 'package:flutter/material.dart';

class ExpandableSectionTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ExpandableSectionTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: Colors.blue.shade50,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
