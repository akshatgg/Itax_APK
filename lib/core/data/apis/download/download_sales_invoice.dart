import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../models/invoice/invoice_model.dart';

class SalesInvoiceServices {
  String formatDateRange(DateTimeRange range) {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    String startDate = formatter.format(range.start);
    String endDate = formatter.format(range.end);
    return '$startDate to $endDate';
  }

  Future<void> generateAndDownloadExcel(BuildContext context,
      {required List<InvoiceModel> invoiceData}) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Invoices'];

    // Styles
    CellStyle headerStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: true,
      fontSize: 14,
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    CellStyle boldStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: false,
      italic: false,
      fontSize: 12,
      fontFamily: getFontFamily(FontFamily.Abadi_MT_Condensed_Extra_Bold),
    );

    CellStyle normalStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      fontSize: 12,
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

    int rowIndex = 0;

    // 1️⃣ Title
    sheet.appendRow([TextCellValue('Sales Invoice List')]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    rowIndex++;

    sheet.appendRow([TextCellValue('')]);
    rowIndex++;
    // 2️⃣ Headers
    sheet.appendRow([
      TextCellValue('Sr No'),
      TextCellValue('Invoice No'),
      TextCellValue('Invoice date'),
      TextCellValue('Invoice Due date'),
      TextCellValue('Invoice Type'),
      TextCellValue('Party Name'),
      TextCellValue('Total Amount'),
      TextCellValue('Financial Year'),
      TextCellValue('Remaining Amount'),
    ]);
    for (int col = 0; col < 9; col++) {
      sheet.setColumnWidth(col, 25);
      sheet.setRowHeight(rowIndex, 20);
      sheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex))
          .cellStyle = headerStyle;
    }
    rowIndex++;

    // 3️⃣ Data
    if (invoiceData.isEmpty) {
      sheet.appendRow([TextCellValue('No invoice data available.')]);

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .cellStyle = normalStyle;
      rowIndex++;
    } else {
      int serial = 1;

      for (var item in invoiceData) {
        // Invoice row
        sheet.appendRow([
          TextCellValue(serial.toString()),
          TextCellValue(item.invoiceNumber.toString()),
          TextCellValue(DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(item.invoiceDate.toString()))),
          TextCellValue(DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(item.dueDate.toString()))),
          TextCellValue(item.type.name),
          TextCellValue(item.partyName),
          TextCellValue('₹ ${item.totalAmount.toStringAsFixed(2)}'),
          TextCellValue(item.finYear),
          TextCellValue('₹ ${item.remainingBalance.toStringAsFixed(2)}'),
        ]);

        for (int col = 0; col < 9; col++) {
          sheet.setColumnWidth(col, 25);
          sheet.setRowHeight(rowIndex, 20);
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: col, rowIndex: rowIndex))
              .cellStyle = normalStyle;
        }

        rowIndex++;
        serial++;

        // 🧾 Add item table headers
        sheet.appendRow([
          TextCellValue(''),
          TextCellValue('Item Name'),
          TextCellValue('Quantity'),
          TextCellValue('Rate'),
          TextCellValue('Tax %'),
          TextCellValue('Discount'),
          TextCellValue('Place of Supply'),
          TextCellValue('Final Amount'),
          TextCellValue('Description'),
        ]);
        for (int col = 1; col <= 8; col++) {
          sheet.setColumnWidth(col, 25);
          sheet.setRowHeight(rowIndex, 20);
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: col, rowIndex: rowIndex))
              .cellStyle = boldStyle;
        }
        rowIndex++;

        // 🧾 Add item rows
        for (var invoiceItem in item.invoiceItems) {
          sheet.appendRow([
            TextCellValue(''), // Blank for serial alignment
            TextCellValue(invoiceItem.itemName),
            TextCellValue(invoiceItem.quantity.toString()),
            TextCellValue(invoiceItem.rate.toStringAsFixed(2)),
            TextCellValue(invoiceItem.taxPercent.toStringAsFixed(2)),
            TextCellValue(invoiceItem.discount.toStringAsFixed(2)),
            TextCellValue(invoiceItem.placeOfSupply),
            TextCellValue(invoiceItem.finalAmount.toStringAsFixed(2)),
            TextCellValue(invoiceItem.description),
          ]);
          for (int col = 1; col <= 8; col++) {
            sheet.setColumnWidth(col, 25);
            sheet.setRowHeight(rowIndex, 20);
            sheet
                .cell(CellIndex.indexByColumnRow(
                    columnIndex: col, rowIndex: rowIndex))
                .cellStyle = normalStyle;
          }
          rowIndex++;
        }

        // ➖ Add empty row between invoices
        sheet.appendRow([TextCellValue('')]);
        rowIndex++;
      }
    }

    // 4️⃣ Encode and Save
    List<int>? excelBytes = excel.encode();
    if (excelBytes == null) return;

    Directory? directory = Directory('/storage/emulated/0/Download');
    String filePath = '${directory.path}/sales_invoices.xlsx';
    File file = File(filePath);
    await file.writeAsBytes(excelBytes);
    PermissionStatus status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      CustomSnackBar.showSnack(
        // ignore: use_build_context_synchronously
        context: context,
        snackBarType: SnackBarType.success,
        message: 'Download successfully',
      );
      OpenFilex.open(filePath);
    } else {
      CustomSnackBar.showSnack(
        // ignore: use_build_context_synchronously
        context: context,
        snackBarType: SnackBarType.error,
        message: 'Download failed',
      );
    }
  }

// Future<void> generateAndDownloadPDF(BuildContext context,
//     {required List<InvoiceModel> invoiceData,
//       required PartyModel partyModel,
//       required DateTimeRange dateRange}) async {
//   // Request storage permission
//   if (await Permission.storage.request().isDenied) {
//     await Permission.storage.request();
//   }
//   // Create a PDF document
//   final pdf = pw.Document();
//   final fontData = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
//   final poppinsRegular = pw.Font.ttf(fontData);
//
//   final boldFontData = await rootBundle.load('assets/fonts/Poppins-Bold.ttf');
//   final poppinsBold = pw.Font.ttf(boldFontData);
//
//   final headerStyle = pw.TextStyle(
//     fontSize: 14,
//     font: poppinsBold,
//     fontWeight: pw.FontWeight.bold,
//   );
//   final textStyle = pw.TextStyle(
//       font: poppinsRegular, fontSize: 14, fontWeight: pw.FontWeight.normal);
//
//   // Add content to the PDF
//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Row(children: [
//               pw.Text('Customer Name : ', style: headerStyle),
//               pw.Text(partyModel.partyName, style: textStyle),
//             ]),
//             pw.SizedBox(height: 5),
//             pw.Row(children: [
//               pw.Text('Receivable : ', style: headerStyle),
//               pw.Text('₹ ${partyModel.outstandingBalance}', style: textStyle),
//             ]),
//             pw.SizedBox(height: 5),
//             pw.Row(children: [
//               pw.Text('Financial Year : ', style: headerStyle),
//               pw.Text(formatDateRange(dateRange), style: textStyle),
//             ]),
//             pw.SizedBox(height: 20),
//
//             // Check if invoiceData is empty
//             if (invoiceData.isEmpty)
//               pw.Text('No invoice data available.', style: textStyle)
//             else
//             // Invoice Table
//               pw.Table(
//                 border: pw.TableBorder.all(),
//                 columnWidths: {
//                   0: const pw.FlexColumnWidth(3),
//                   1: const pw.FlexColumnWidth(2),
//                   2: const pw.FlexColumnWidth(3),
//                   3: const pw.FlexColumnWidth(3),
//                 },
//                 children: [
//                   // Table Header Row
//                   pw.TableRow(
//                     decoration:
//                     const pw.BoxDecoration(color: PdfColors.grey300),
//                     children: [
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(5),
//                         child: pw.Text('Invoice No', style: headerStyle),
//                       ),
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(5),
//                         child: pw.Text('Status', style: headerStyle),
//                       ),
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(5),
//                         child: pw.Text('Date', style: headerStyle),
//                       ),
//                       pw.Padding(
//                         padding: const pw.EdgeInsets.all(5),
//                         child: pw.Text('Amount', style: headerStyle),
//                       ),
//                     ],
//                   ),
//
//                   // Table Data Rows
//                   ...invoiceData.map((item) {
//                     return pw.TableRow(
//                       children: [
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(5),
//                           child: pw.Text(item.invoiceNumber.toString(),
//                               style: textStyle),
//                         ),
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(5),
//                           child: pw.Text(item.status.name.toUpperCase(),
//                               style: textStyle),
//                         ),
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(5),
//                           child: pw.Text(
//                             DateFormat('dd/MM/yyyy').format(
//                                 DateTime.parse(item.invoiceDate.toString())),
//                             style: textStyle,
//                           ),
//                         ),
//                         pw.Padding(
//                           padding: const pw.EdgeInsets.all(5),
//                           child: pw.Text('₹ ${item.totalAmount.toString()}',
//                               style: textStyle),
//                         ),
//                       ],
//                     );
//                   })
//                 ],
//               )
//           ],
//         );
//       },
//     ),
//   );
//
//   // Get writable directory
//   Directory? directory = Directory('/storage/emulated/0/Download');
//   String filePath = '${directory.path}/${partyModel.partyName}_invoice.pdf';
//
//   // Save the file
//   File file = File(filePath);
//   await file.writeAsBytes(await pdf.save());
//   PermissionStatus status = await Permission.manageExternalStorage.request();
//   if (status.isGranted) {
//     CustomSnackBar.showSnack(
//       context: context,
//       snackBarType: SnackBarType.success,
//       message: 'Download successfully',
//     );
//     OpenFilex.open(filePath);
//   } else {
//     CustomSnackBar.showSnack(
//       context: context,
//       snackBarType: SnackBarType.error,
//       message: 'Download fail',
//     );
//   }
//   await OpenFilex.open(filePath);
// }
//
// Future<void> generateAndDownloadCSV(BuildContext context,
//     {required List<InvoiceModel> invoiceData,
//       required PartyModel partyModel,
//       required DateTimeRange dateRange}) async {
//   // Request storage permission
//   // Create CSV Data
//   List<List<dynamic>> csvData = [
//     ['Customer Name:', partyModel.partyName], // Customer Name
//     [],
//     ['Receivable:', partyModel.outstandingBalance], // Receivable Amount
//     [],
//     ['Financial Year:', formatDateRange(dateRange)], // Due Date
//     [],
//     ['Invoice No', 'Status', 'Date', 'Amount'], // Table Headers
//   ];
//
//   // Add invoice data rows
//   for (var item in invoiceData) {
//     csvData.add([
//       item.invoiceNumber.toString(),
//       item.status.name.toUpperCase(),
//       DateFormat('dd/MM/yyyy')
//           .format(DateTime.parse(item.invoiceDate.toString())), // Format date
//       '₹${item.totalAmount.toString()}',
//     ]);
//   }
//
//   // Convert List to CSV format
//   String csv = const ListToCsvConverter().convert(csvData);
//
//   // Save CSV file in Download folder
//   Directory directory = Directory('/storage/emulated/0/Download');
//   if (!directory.existsSync()) {
//     directory.createSync(recursive: true);
//   }
//   String filePath = '${directory.path}/${partyModel.partyName}_invoice.csv';
//   File file = File(filePath);
//   await file.writeAsString(csv);
//   // 7️⃣ Open file
//   PermissionStatus status = await Permission.manageExternalStorage.request();
//
//   // 8️⃣ Open file
//   if (status.isGranted) {
//     CustomSnackBar.showSnack(
//       context: context,
//       snackBarType: SnackBarType.success,
//       message: 'Download successfully',
//     );
//     OpenFilex.open(filePath);
//   } else {
//     CustomSnackBar.showSnack(
//       context: context,
//       snackBarType: SnackBarType.error,
//       message: 'Download fail',
//     );
//   }
// }
}
