import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/logger.dart';
import '../models/items/item_model.dart';

class ItemListDownloadService {
  Future<void> generateAndDownloadExcel({required List<ItemModel> item}) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['ItemList'];

    // Define styles
    CellStyle headerStyle = CellStyle(
      bold: true,
      fontSize: 14,
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    CellStyle normalStyle = CellStyle(
      fontSize: 12,
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    int rowIndex = 0;
    int srNo = 1; // Sr No counter

    // 1️⃣ Add Header
    sheet.appendRow([
      TextCellValue('Sr No'),
      TextCellValue('Item Name'),
      TextCellValue('HSN/SAC Code'),
      TextCellValue('Item Unit'),
      TextCellValue('Item Type'),
      TextCellValue('Sale Price'),
      TextCellValue('Purchase Price'),
      TextCellValue('Tax Rate'),
      TextCellValue('Tax Exempted'),
      TextCellValue('Stock'),
      TextCellValue('In Stock'),
      TextCellValue('Out Stock'),
    ]);

    for (int col = 0; col < 12; col++) {
      sheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex))
          .cellStyle = headerStyle;
    }
    rowIndex++;

    // 2️⃣ Add dynamic data
    for (var items in item) {
      sheet.appendRow([
        TextCellValue(srNo.toString()), // Auto-incrementing Sr No
        TextCellValue(items.itemName),
        TextCellValue(items.hsnCode ?? ''),
        TextCellValue(items.unit.name),
        TextCellValue(items.itemType.name),
        TextCellValue('₹  ${items.price.toString()}'),
        TextCellValue('₹  ${items.purchasePrice.toString()}'),
        TextCellValue(items.gst.toString()),
        TextCellValue(items.taxExempted.toString()),
        TextCellValue(items.closingStock.toString()),
        TextCellValue(items.closingStock > 0 ? 'Yes' : 'No'),
        TextCellValue(items.closingStock <= 0 ? 'Yes' : 'No'),
      ]);

      for (int col = 0; col < 12; col++) {
        sheet.setColumnWidth(col, 20.0); // Adjust the width as needed

        sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: col, rowIndex: rowIndex))
            .cellStyle = normalStyle;
      }

      rowIndex++;
      srNo++; // Increment Sr No
    }

    List<int>? excelBytes = excel.encode();
    if (excelBytes == null) {
      logger.e('Excel file encoding failed!');
      return;
    }

    // Save to Public Downloads Folder
    Directory? directory = await getDownloadsDirectory();
    String filePath = '${directory?.path}/items.xlsx';

    try {
      File file = File(filePath);
      await file.writeAsBytes(excelBytes);
      logger.d('File saved at: $filePath');

      // Open File after Download
      PermissionStatus status =
          await Permission.manageExternalStorage.request();
      logger.d(status);
      // 7️⃣ Open file
      if (status.isGranted) {
        OpenFilex.open(filePath);
      } else {
        logger.d('dqed');
      }
    } catch (e) {
      logger.e('Error saving file: $e');
    }
  }

  Future<void> generateAndDownloadPDF({required List<ItemModel> item}) async {
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
        font: poppinsRegular, fontSize: 14, fontWeight: pw.FontWeight.normal);
    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('Item List', style: headerStyle),
              ),
              pw.SizedBox(height: 10),

              // Invoice Table
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Table Header Row
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
                        child: pw.Text('HSN/SAC Code', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Item Unit', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Item Type', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Sale Price', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Purchase Price', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Tax Rate', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Stock', style: headerStyle),
                      ),
                    ],
                  ),

                  // Table Data Rows
                  ...item.asMap().entries.map((entry) {
                    int index =
                        entry.key + 1; // Auto-incremented Sr No (1-based index)
                    var items = entry.value;

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                              index.toString(), // Auto-incremented Sr No
                              style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(items.itemName, style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(items.hsnCode ?? '', style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(items.unit.name, style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(items.itemType.name, style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('₹ ${items.price.toString()}',
                              style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('₹ ${items.purchasePrice.toString()}',
                              style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child:
                              pw.Text(items.gst.toString(), style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(items.closingStock.toString(),
                              style: textStyle),
                        ),
                      ],
                    );
                  })
                ],
              )
            ],
          );
        },
      ),
    );

    // Get writable directory
    Directory? directory = await getDownloadsDirectory();
    String filePath = '${directory?.path}/PartyList.pdf';

    // Save the file
    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(filePath);
  }

  Future<void> generateAndDownloadCSV({required List<ItemModel> item}) async {
    List<List<dynamic>> csvData = [
      [
        'Sr No',
        'Item Name',
        'HSN/SAC Code',
        'Item Unit',
        'Item Type',
        'Sale Price',
        'Purchase Price',
        'Tax Rate',
        'Tax Exempted',
        'Stock',
        'In Stock',
        'Out Stock',
      ]
    ];

    // 2️⃣ Add dynamic data
    int srNo = 1;
    for (var items in item) {
      csvData.add([
        srNo++, // Auto-incrementing Sr No
        items.itemName,
        items.hsnCode ?? '',
        items.unit.name,
        items.itemType.name,
        '₹ ${items.price.toString()}',
        '₹ ${items.purchasePrice.toString()}',
        items.gst.toString(),
        items.taxExempted.toString(),
        items.closingStock.toString(),
        items.closingStock > 0 ? 'Yes' : 'No',
        items.closingStock <= 0 ? 'Yes' : 'No',
      ]);
    }

    // 3️⃣ Convert List to CSV format
    String csv = const ListToCsvConverter().convert(csvData);

    // 4️⃣ Save CSV file in Downloads folder
    Directory? directory = await getDownloadsDirectory();
    String filePath = '${directory?.path}/items.csv';

    try {
      File file = File(filePath);
      await file.writeAsString(csv);
      logger.d('File saved at: $filePath');

      // 5️⃣ Request permission and open file
      PermissionStatus status =
          await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        OpenFilex.open(filePath);
      } else {}
    } catch (e) {
      logger.d('Error saving file: $e');
    }
  }
}
