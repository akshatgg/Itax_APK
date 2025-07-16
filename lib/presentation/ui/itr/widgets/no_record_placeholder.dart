import 'package:flutter/material.dart';

class NoRecordPlaceholder extends StatelessWidget {
  const NoRecordPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.insert_drive_file, size: 64, color: Colors.grey),
        SizedBox(height: 8),
        Text('No Record Found', style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}
