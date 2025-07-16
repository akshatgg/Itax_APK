import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../models/invoice/invoice_model.dart';
import '../models/items/item_model.dart';

class InActiveItem {
  String formatDateRange(DateTime range) {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    String startDate = formatter.format(range);
    return startDate;
  }

  Future<void> generateInactiveItemsPDF({
    required List<InvoiceModel> invoiceData,
    required List<ItemModel> itemData,
  }) async {
    // Request storage permission
    if (await Permission.storage.request().isDenied) {
      await Permission.storage.request();
    }

    // Create a PDF document
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
    final poppinsRegular = pw.Font.ttf(fontData);
    final boldFontData = await rootBundle.load('assets/fonts/Poppins-Bold.ttf');
    final poppinsBold = pw.Font.ttf(boldFontData);

    final headerStyle = pw.TextStyle(
      fontSize: 14,
      font: poppinsBold,
      fontWeight: pw.FontWeight.bold,
    );

    final textStyle = pw.TextStyle(
      font: poppinsRegular,
      fontSize: 14,
      fontWeight: pw.FontWeight.normal,
    );

    DateTime today = DateTime.now();

    // Map each item's last sold date
    Map<String, DateTime> lastSoldDates = {};
    for (var invoice in invoiceData) {
      for (var item in invoice.invoiceItems) {
        String itemId = item.itemId.toString();
        DateTime invoiceDate = invoice.invoiceDate;
        if (!lastSoldDates.containsKey(itemId) ||
            invoiceDate.isAfter(lastSoldDates[itemId]!)) {
          lastSoldDates[itemId] = invoiceDate;
        }
      }
    }

    // Filter inactive items (last sale more than 30 days ago)
    List<ItemModel> inactiveItems = itemData.where((item) {
      if (lastSoldDates.containsKey(item.id)) {
        return today.difference(lastSoldDates[item.id]!).inDays == 0;
      }
      return true; // If item has no sales, mark it as inactive
    }).toList();

    // Create PDF content
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Inactive Item List', style: headerStyle),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(3),
                  2: const pw.FlexColumnWidth(3),
                  3: const pw.FlexColumnWidth(3),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Sr No', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Item Name', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Current Stock', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Last Sales Date', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Inactive Days', style: headerStyle),
                      ),
                    ],
                  ),
                  ...inactiveItems.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    ItemModel item = entry.value;
                    DateTime lastSalesDate = lastSoldDates[item.id] ?? today;
                    int inactiveDays = today.difference(lastSalesDate).inDays;

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(index.toString(), style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(item.itemName, style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(item.closingStock.toString(),
                              style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                              DateFormat('d MMM yyyy').format(lastSalesDate),
                              style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child:
                              pw.Text('$inactiveDays days', style: textStyle),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Save and Open PDF
    Directory? directory = await getDownloadsDirectory();
    String filePath = '${directory?.path}/inactive_items.pdf';
    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(filePath);
  }
}
