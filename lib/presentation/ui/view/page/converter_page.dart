import 'package:flutter/material.dart';

import '../../itr/widgets/custom_bottom_nav_itr.dart';
import '../widgets/converter_item.dart';
import '../widgets/custom_app_bar_view.dart';

class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ConverterItem> converters = [
      ConverterItem(
          label: 'Merge PDF',
          icon: Icons.call_merge,
          color: Colors.pink.shade100),
      ConverterItem(
          label: 'Split PDF',
          icon: Icons.call_split,
          color: Colors.red.shade100),
      ConverterItem(
          label: 'Compress PDF',
          icon: Icons.compress,
          color: Colors.green.shade100),
      ConverterItem(
          label: 'PDF to Word',
          icon: Icons.text_snippet,
          color: Colors.purple.shade100),
      ConverterItem(
          label: 'PDF to PPT',
          icon: Icons.slideshow,
          color: Colors.red.shade100),
      ConverterItem(
          label: 'PDF to Excel',
          icon: Icons.table_chart,
          color: Colors.amber.shade200),
      ConverterItem(
          label: 'Word to PDF',
          icon: Icons.note_alt,
          color: Colors.purple.shade100),
      ConverterItem(
          label: 'PPT to PDF',
          icon: Icons.picture_as_pdf,
          color: Colors.red.shade100),
      ConverterItem(
          label: 'Excel to PDF',
          icon: Icons.grid_on,
          color: Colors.amber.shade200),
      ConverterItem(
          label: 'Edit PDF', icon: Icons.edit, color: Colors.purple.shade100),
      ConverterItem(
          label: 'PDF to JPG',
          icon: Icons.image,
          color: Colors.yellow.shade100),
      ConverterItem(
          label: 'Image to PDF',
          icon: Icons.photo,
          color: Colors.yellow.shade100),
    ];

    return Scaffold(
      appBar: CustomTopAppBarView(
        title: 'Converter',
        onBack: () => Navigator.pop(context),
        onMore: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (_) => const Padding(
              padding: EdgeInsets.all(20),
              child: Text('More options here'),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Converter',
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: converters.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final item = converters[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Handle conversion navigation
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(item.icon, size: 30, color: Colors.black87),
                          const SizedBox(height: 8),
                          Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavBarItr(
          currentIndex: 0,
          onItemSelected: (index) {},
        ),
      ),
    );
  }
}
