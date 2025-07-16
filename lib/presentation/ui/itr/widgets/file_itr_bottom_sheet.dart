import 'package:flutter/material.dart';

import '../pages/manually_fill_itr_page.dart';
import '../pages/select_form16_page.dart';

class FileItrBottomSheet extends StatelessWidget {
  const FileItrBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Bottom Sheet Body
        Container(
          margin: const EdgeInsets.only(top: 20), // space for close button
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle Bar
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'File ITR',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Options
                _buildOption(context, 'Upload Form-16'),
                const SizedBox(height: 12),
                _buildOption(context, 'File Manually'),
                const SizedBox(height: 12),
                _buildOption(context, 'Challan Entry'),
              ],
            ),
          ),
        ),

        // Close Button Outside the Sheet
        Positioned(
          top: -20,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black26,
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds an option tile and handles navigation based on label
  Widget _buildOption(BuildContext context, String label) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.pop(context); // Close the bottom sheet

          if (label == 'Upload Form-16') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SelectForm16Page()),
            );
          } else if (label == 'File Manually') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManuallyFillItrPage()),
            );
          }
          // Add navigation for Challan Entry if needed
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
