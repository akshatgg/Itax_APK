import 'package:flutter/material.dart';

class HeadlineSection extends StatelessWidget {
  const HeadlineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Existing the tax filling process with AI',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Upload your ITR form 16 to get started quickly!',
            style: TextStyle(fontSize: 16, color: Colors.blue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
