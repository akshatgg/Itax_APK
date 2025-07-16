// File: ocr_page/tabs/collection_tab.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/document_model.dart';

class CollectionTab extends StatelessWidget {
  const CollectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final docs = context.watch<DocumentProvider>().documents;

    if (docs.isEmpty) {
      return const Center(
        child: Text('No scanned documents found.'),
      );
    }

    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Image.file(
              File(doc.filePath),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(doc.type),
            subtitle: Text(doc.extractedFields['Preview'] ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Provider.of<DocumentProvider>(context, listen: false)
                    .removeDocument(index);
              },
            ),
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(doc.type),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.file(File(doc.filePath)),
                      const SizedBox(height: 12),
                      Text(doc.extractedFields.entries
                          .map((e) => '${e.key}: ${e.value}')
                          .join('\n')),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
