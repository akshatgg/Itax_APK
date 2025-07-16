import 'package:flutter/material.dart';

import 'widgets/custom_bottom_nav_itr.dart';
import 'widgets/file_itr_bottom_sheet.dart';
import 'widgets/gradient_app_bar.dart';
import 'widgets/headline_section.dart';
import 'widgets/no_record_placeholder.dart';
import 'widgets/primary_button.dart';

class ItrPage extends StatelessWidget {
  const ItrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'ITR',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadlineSection(),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'File ITR',
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  // so rounded corners are visible
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (_) => const SafeArea(
                    child: FileItrBottomSheet(),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'Recent Submissions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Expanded(child: Center(child: NoRecordPlaceholder())),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavBarItr(
          currentIndex: 0,
          onItemSelected: (index) {
            // Handle tab navigation if needed
          },
        ),
      ),
    );
  }
}
