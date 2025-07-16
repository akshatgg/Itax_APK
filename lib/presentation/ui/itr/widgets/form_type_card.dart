import 'package:flutter/material.dart';

class FormTypeCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;
  final String? subtitle; // optional

  const FormTypeCard({
    super.key,
    required this.label,
    required this.imagePath,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Image.asset(
                  imagePath,
                  height: 60,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
