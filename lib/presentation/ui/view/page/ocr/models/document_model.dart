// File: ocr_page/models/document_model.dart

import 'dart:io';

import 'package:flutter/material.dart';

class DocumentData {
  final String filePath;
  final String type;
  final Map<String, String> extractedFields;

  DocumentData({
    required this.filePath,
    required this.type,
    required this.extractedFields,
  });
}

class DocumentProvider with ChangeNotifier {
  final List<DocumentData> _documents = [];

  List<DocumentData> get documents => _documents;

  void addDocument(DocumentData doc) {
    _documents.add(doc);
    notifyListeners();
  }

  void removeDocument(int index) {
    final file = File(_documents[index].filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
    _documents.removeAt(index);
    notifyListeners();
  }

  void clearAll() {
    for (final doc in _documents) {
      final file = File(doc.filePath);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    _documents.clear();
    notifyListeners();
  }
}
