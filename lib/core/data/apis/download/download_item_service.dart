import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../models/items/item_model.dart';

class ItemServices {
  Future<void> generateAndDownloadExcel({required ItemModel itemData}) async {
    // Request storage permission
    if (await Permission.storage.request().isDenied) {
      await Permission.storage.request();
    }

    var excel = Excel.createExcel();
    Sheet sheet = excel[itemData.itemName];

    CellStyle boldStyle = CellStyle(
      bold: true,
      fontSize: 12,
      fontFamily: getFontFamily(FontFamily.Arial),
    );

    CellStyle normalStyle = CellStyle(
      fontSize: 12,
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    int rowIndex = 0; // Track row index

    // Set width of the first column (column index 0)
    sheet.setColumnWidth(0, 20.0); // Adjust the width as needed
    sheet.setColumnWidth(1, 20.0);
    sheet.setColumnWidth(2, 20.0);
    // 1️⃣ Add customer details with bold style
    sheet.appendRow(
        [TextCellValue('Item Name:'), TextCellValue(itemData.itemName)]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;
    sheet.appendRow([TextCellValue('')]);
    rowIndex++;
    sheet.appendRow([
      TextCellValue('Sales Price:'),
      TextCellValue(itemData.price.toString())
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;
    sheet.appendRow([TextCellValue('')]);
    rowIndex++;
    sheet.appendRow([
      TextCellValue('Purchase Price'),
      TextCellValue('Current Stock'),
      TextCellValue('Stock Value'),
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    rowIndex++;
    sheet.appendRow([
      TextCellValue(itemData.purchasePrice.toString()),
      TextCellValue(itemData.closingStock.toString()),
      TextCellValue(
          '₹ ${(itemData.closingStock * itemData.price).toStringAsFixed(2)}'),
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;
    sheet.appendRow([TextCellValue('')]);
    rowIndex++;
    sheet.appendRow([
      TextCellValue('Item Details'),
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    rowIndex++;
    sheet.appendRow([
      TextCellValue('Item Type :'),
      TextCellValue(itemData.itemType.name.toString())
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;
    sheet.appendRow([
      TextCellValue('Item Unit :'),
      TextCellValue(itemData.unit.name.toString())
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;
    sheet.appendRow([
      TextCellValue('HSN/SAC Code :'),
      TextCellValue(itemData.hsnCode.toString())
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;
    sheet.appendRow(
        [TextCellValue('Tax Rate :'), TextCellValue(itemData.gst.toString())]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;
    sheet.appendRow([
      TextCellValue('Description :'),
      TextCellValue(itemData.description ?? 'N/A')
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;
    for (int i = 0; i <= rowIndex; i++) {
      sheet.setRowHeight(i, 25); // Adjust height as needed
    }
    // 4️⃣ Encode Excel file
    List<int>? excelBytes = excel.encode();
    if (excelBytes == null) return;

    // 5️⃣ Get writable directory
    Directory? directory = await getDownloadsDirectory();
    if (directory == null) {
      return;
    }
    String filePath = '${directory.path}/${itemData.itemName}_detail.xlsx';

    // 6️⃣ Save file
    File file = File(filePath);
    await file.writeAsBytes(excelBytes);
    PermissionStatus status = await Permission.manageExternalStorage.request();

    // 7️⃣ Open file
    if (status.isGranted) {
      OpenFilex.open(filePath);
    } else {}
  }

  Future<void> generateAndDownloadPDF({required ItemModel item}) async {
    // Request storage permission
    if (await Permission.storage.request().isDenied) {
      await Permission.storage.request();
    }
    // Create a PDF document
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
    final poppinsRegular = pw.Font.ttf(fontData);
    final pw.EdgeInsets padding = const pw.EdgeInsets.all(10);
    final boldFontData = await rootBundle.load('assets/fonts/Poppins-Bold.ttf');
    final poppinsBold = pw.Font.ttf(boldFontData);

    final headerStyle = pw.TextStyle(
      fontSize: 14,
      font: poppinsBold,
      fontWeight: pw.FontWeight.bold,
    );
    final textStyle = pw.TextStyle(
        font: poppinsRegular, fontSize: 14, fontWeight: pw.FontWeight.normal);
    pw.Widget mainTableHeader({required String title}) {
      return pw.Padding(
          padding: padding,
          child:
              pw.Text(title, textAlign: pw.TextAlign.left, style: headerStyle));
    }

    pw.Widget mainTableData({required String title}) {
      return pw.Padding(
          padding: padding,
          child:
              pw.Text(title, textAlign: pw.TextAlign.left, style: textStyle));
    }

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Padding(
                    padding: padding,
                    child: pw.Row(children: [
                      pw.Text('Item Name : ', style: headerStyle),
                      pw.Text(item.itemName, style: textStyle),
                    ]),
                  ),
                  pw.Padding(
                    padding: padding,
                    child: pw.Row(children: [
                      pw.Text('Sales Price : ', style: headerStyle),
                      pw.Text('₹ ${item.price}', style: textStyle),
                    ]),
                  ),
                  pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.black),
                      children: [
                        pw.TableRow(children: [
                          mainTableHeader(title: 'Purchase Price'),
                          mainTableHeader(title: 'Current Stock'),
                          mainTableHeader(title: 'Stock Value'),
                        ]),
                        pw.TableRow(children: [
                          mainTableData(title: item.purchasePrice.toString()),
                          mainTableData(title: item.closingStock.toString()),
                          mainTableData(
                              title:
                                  '₹ ${(item.closingStock * item.price).toStringAsFixed(2)}')
                        ])
                      ]),
                  mainTableHeader(title: 'Item Detail : '),
                  pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.black),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(2),
                        1: const pw.FixedColumnWidth(3),
                      },
                      children: [
                        pw.TableRow(children: [
                          mainTableHeader(title: 'Item Type'),
                          mainTableData(title: item.itemType.name)
                        ]),
                        pw.TableRow(children: [
                          mainTableHeader(title: 'Item Unit'),
                          mainTableData(title: item.unit.name)
                        ]),
                        pw.TableRow(children: [
                          mainTableHeader(title: 'HSN/SAC Code'),
                          mainTableData(title: item.hsnCode ?? 'N/A')
                        ]),
                        pw.TableRow(children: [
                          mainTableHeader(title: 'Tax Rate'),
                          mainTableData(title: item.gst.toString())
                        ]),
                        pw.TableRow(children: [
                          mainTableHeader(title: 'Description'),
                          mainTableData(title: item.description ?? 'N/A')
                        ]),
                      ]),
                ],
              ));
        },
      ),
    );

    // Get writable directory
    Directory? directory = await getDownloadsDirectory();
    String filePath = '${directory?.path}/${item.itemName}_detail.pdf';

    // Save the file
    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(filePath);
  }

  Future<void> generateAndDownloadCSV({
    required ItemModel item,
  }) async {
    // Request storage permission
    // Create CSV Data
    List<List<dynamic>> csvData = [
      ['Item Name:', item.itemName], // Customer Name
      [],
      ['Sales Price', item.price], // Receivable Amount
      [],
      [
        'Purchase Price:',
        item.purchasePrice,
        'Current Stock:',
        item.closingStock,
        'Stock Value:',
        '₹ ${(item.closingStock * item.price).toStringAsFixed(2)}'
      ],
      [],
      [
        'Item Detail:',
      ],
      [],
      ['Item Type:', item.itemType.name],
      [],
      ['Item Unit:', item.unit.name],
      [],
      ['HSN/SAC Code:', item.hsnCode],
      [],
      ['Tax Rate:', item.gst],
      [],
      ['Description:', item.description],
    ];

    // Convert List to CSV format
    String csv = const ListToCsvConverter().convert(csvData);

    // Save CSV file in Download folder
    Directory? directory = await getDownloadsDirectory();
    if (directory == null) {
      return;
    }
    String filePath = '${directory.path}/${item.itemName}_detail.csv';
    File file = File(filePath);
    await file.writeAsString(csv);
    PermissionStatus status1 = await Permission.manageExternalStorage.request();
    // 7️⃣ Open file
    if (status1.isGranted) {
      OpenFilex.open(filePath);
    } else {}
  }
}
