import 'package:flutter/material.dart';

class DocumentPickerDialog extends StatefulWidget {
  final List<String> files;
  final String title;
  final void Function(List<String> selectedFiles) onConfirm;

  const DocumentPickerDialog({
    super.key,
    required this.files,
    required this.title,
    required this.onConfirm,
  });

  @override
  State<DocumentPickerDialog> createState() => _DocumentPickerDialogState();
}

class _DocumentPickerDialogState extends State<DocumentPickerDialog> {
  final Set<String> _selectedFiles = {};

  void _toggleSelection(String file) {
    setState(() {
      if (_selectedFiles.contains(file)) {
        _selectedFiles.remove(file);
      } else {
        _selectedFiles.add(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: widget.files.map((file) {
                    final isSelected = _selectedFiles.contains(file);
                    return GestureDetector(
                      onTap: () => _toggleSelection(file),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected ? Colors.blue : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.picture_as_pdf,
                                color: Colors.red, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              file,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _OutlinedActionButton(
                      label: 'Cancel',
                      onTap: () => Navigator.pop(context),
                    ),
                    _OutlinedActionButton(
                      label: 'Ok',
                      onTap: () {
                        widget.onConfirm(_selectedFiles.toList());
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Positioned cross icon
        Positioned(
          top: -20,
          right: -20,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _OutlinedActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlinedActionButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        side: const BorderSide(color: Colors.blue),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }
}
