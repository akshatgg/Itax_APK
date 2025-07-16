// File: ocr_page/ocr_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/document_model.dart';
import 'tabs/collection_tab.dart';
import 'tabs/scan_tab.dart';

class OCRPage extends StatefulWidget {
  const OCRPage({super.key});

  @override
  State<OCRPage> createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DocumentProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OCR Scanner'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Scan'),
              Tab(text: 'Collection'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            ScanTab(),
            CollectionTab(),
          ],
        ),
      ),
    );
  }
}
