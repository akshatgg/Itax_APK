import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/custom_bottom_nav_itr.dart';
import '../widgets/form_type_card.dart';
import '../widgets/gradient_app_bar.dart';

class SelectForm16Page extends StatelessWidget {
  const SelectForm16Page({super.key});

  void _openBottomSheet(BuildContext context, String sourceType) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // needed for floating icon effect
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Bottom Sheet Content - 50% height
            Container(
              height: screenHeight * 0.5,
              margin: const EdgeInsets.only(top: 30), // space for close icon
              decoration: const BoxDecoration(
                color: Color(0xF4FFFFFF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$sourceType Document Upload',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              FormTypeCard(
                                label: 'PAN Card',
                                subtitle: 'PDF, JPG, PNG allowed',
                                imagePath: 'assets/images/pan_card.png',
                                onTap: () =>
                                    _openDocumentDialog(context, 'PAN Card'),
                              ),
                              const SizedBox(height: 16),
                              FormTypeCard(
                                label: 'Aadhaar Card',
                                subtitle: 'PDF, JPG, PNG allowed',
                                imagePath: 'assets/images/aadhar_card.webp',
                                onTap: () => _openDocumentDialog(
                                    context, 'Aadhaar Card'),
                              ),
                              const SizedBox(height: 16),
                              FormTypeCard(
                                label: 'GSTR Certificate',
                                subtitle: 'PDF only',
                                imagePath: 'assets/images/gstr_file_icon.png',
                                onTap: () => _openDocumentDialog(
                                    context, 'GSTR Certificate'),
                              ),
                              const SizedBox(height: 16),
                              FormTypeCard(
                                label: 'Bank Statement',
                                subtitle: 'PDF or Excel',
                                imagePath: 'assets/images/bank_statement.webp',
                                onTap: () => _openDocumentDialog(
                                    context, 'Bank Statement'),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Floating Close Button
            Positioned(
              top: -20,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openDocumentDialog(BuildContext context, String docType) async {
    File? selectedFile;

    if (docType == 'PAN Card' || docType == 'Aadhaar Card') {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        selectedFile = File(pickedFile.path);
      }
    } else {
      // Show confirmation dialog before selecting file
      final allowedExtensions =
          docType == 'GSTR Certificate' ? ['pdf'] : ['pdf', 'xlsx', 'xls'];

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Upload $docType'),
            content: const Text('Select a document file to upload.'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close dialog first

                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    withData: false,
                    // Let user select any file; filter later
                    type: FileType.any,
                  );

                  if (result != null && result.files.isNotEmpty) {
                    final file = result.files.first;
                    final path = file.path!;
                    final extension = path.split('.').last.toLowerCase();

                    if (allowedExtensions.contains(extension)) {
                      selectedFile = File(path);

                      // Show success snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$docType uploaded: ${selectedFile!.path.split('/').last}',
                          ),
                        ),
                      );
                    } else {
                      // Invalid extension warning
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Invalid file type. Please upload: ${allowedExtensions.join(", ")}',
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Select File'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildSelectionCard({
    required String label,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Image.asset(imagePath, height: 60),
              const SizedBox(height: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF4FFFFFF),
      appBar: GradientAppBar(
        title: 'Upload Form 16',
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose how you want to upload your Form 16 documents.',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Source',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Provided by IT Department
              _buildSelectionCard(
                label: 'Provided by IT Department',
                imagePath: 'assets/images/it_department.png', // Add this image
                onTap: () => _openBottomSheet(context, 'IT Department'),
              ),
              const SizedBox(height: 20),

              // Custom Upload
              _buildSelectionCard(
                label: 'Custom',
                imagePath:
                    'assets/images/custom_tax_filling.jpg', // Add this image
                onTap: () => _openBottomSheet(context, 'Custom'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavBarItr(
          currentIndex: 0,
          onItemSelected: (index) {
            // Handle navigation
          },
        ),
      ),
    );
  }
}
