// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../../utils/logger.dart';
import '../models/invoice/invoice_model.dart';
import '../models/party/party_model.dart';

class CustomerServices {
  String formatDateRange(DateTimeRange range) {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    String startDate = formatter.format(range.start);
    String endDate = formatter.format(range.end);
    return '$startDate to $endDate';
  }

  Future<void> generateAndDownloadExcel(BuildContext context,
      {required List<InvoiceModel> invoiceData,
      required PartyModel partyModel,
      required DateTimeRange dateRange}) async {
    // Request storage permission
    var excel = Excel.createExcel();
    Sheet sheet = excel['Invoices'];

    // Define styles
    CellStyle headerStyle = CellStyle(
      bold: true,
      fontSize: 14,
      fontFamily: getFontFamily(FontFamily.Calibri),
    );

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

    // 1️⃣ Add customer details with bold style
    sheet.appendRow(
        [TextCellValue('Customer Name:'), TextCellValue(partyModel.partyName)]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;

    sheet.appendRow([TextCellValue('')]); // Empty row
    rowIndex++;

    sheet.appendRow([
      TextCellValue('Receivable:'),
      TextCellValue('₹ ${partyModel.outstandingBalance}')
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;

    sheet.appendRow([TextCellValue('')]); // Empty row
    rowIndex++;

    sheet.appendRow([
      TextCellValue('Financial Year:'),
      TextCellValue(formatDateRange(dateRange))
    ]);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
        .cellStyle = boldStyle;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
        .cellStyle = normalStyle;
    rowIndex++;

    sheet.appendRow([TextCellValue('')]); // Empty row
    rowIndex++;

    // 2️⃣ Add headers with header style
    sheet.appendRow([
      TextCellValue('Invoice No'),
      TextCellValue('Status'),
      TextCellValue('Date'),
      TextCellValue('Amount')
    ]);
    for (int col = 0; col < 4; col++) {
      sheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex))
          .cellStyle = headerStyle;
    }
    rowIndex++;

    // 3️⃣ Check if invoiceData is empty
    if (invoiceData.isEmpty) {
      // If no invoice data, display a message
      sheet.appendRow([TextCellValue('No invoice data available.')]);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
          .cellStyle = normalStyle;
      rowIndex++;
    } else {
      // 4️⃣ Add dynamic invoice data with normal style
      for (var item in invoiceData) {
        sheet.appendRow([
          TextCellValue(item.invoiceNumber.toString()),
          TextCellValue(item.status.name.toUpperCase()),
          TextCellValue(DateFormat('dd/MM/yyyy')
              .format(DateTime.parse(item.invoiceDate.toString()))),
          TextCellValue('₹${item.totalAmount.toString()}')
        ]);

        for (int col = 0; col < 4; col++) {
          sheet
              .cell(CellIndex.indexByColumnRow(
                  columnIndex: col, rowIndex: rowIndex))
              .cellStyle = normalStyle;
        }
        rowIndex++;
      }
    }

    // 5️⃣ Encode Excel file
    List<int>? excelBytes = excel.encode();
    if (excelBytes == null) return;

    // 6️⃣ Get writable directory
    Directory? directory = Directory('/storage/emulated/0/Download');
    String filePath = '${directory.path}/${partyModel.partyName}_invoices.xlsx';
    logger.d(filePath);

    // 7️⃣ Save file
    File file = File(filePath);
    await file.writeAsBytes(excelBytes);
    PermissionStatus status = await Permission.manageExternalStorage.request();

    // 8️⃣ Open file
    if (status.isGranted) {
      CustomSnackBar.showSnack(
        context: context,
        snackBarType: SnackBarType.success,
        message: 'Download successfully',
      );
      OpenFilex.open(filePath);
    } else {
      CustomSnackBar.showSnack(
        context: context,
        snackBarType: SnackBarType.error,
        message: 'Download fail',
      );
    }
  }

  Future<void> generateAndDownloadPDF(BuildContext context,
      {required List<InvoiceModel> invoiceData,
      required PartyModel partyModel,
      required DateTimeRange dateRange}) async {
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
              pw.Row(children: [
                pw.Text('Customer Name : ', style: headerStyle),
                pw.Text(partyModel.partyName, style: textStyle),
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Text('Receivable : ', style: headerStyle),
                pw.Text('₹ ${partyModel.outstandingBalance}', style: textStyle),
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Text('Financial Year : ', style: headerStyle),
                pw.Text(formatDateRange(dateRange), style: textStyle),
              ]),
              pw.SizedBox(height: 20),

              // Check if invoiceData is empty
              if (invoiceData.isEmpty)
                pw.Text('No invoice data available.', style: textStyle)
              else
                // Invoice Table
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3),
                    1: const pw.FlexColumnWidth(2),
                    2: const pw.FlexColumnWidth(3),
                    3: const pw.FlexColumnWidth(3),
                  },
                  children: [
                    // Table Header Row
                    pw.TableRow(
                      decoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Invoice No', style: headerStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Status', style: headerStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Date', style: headerStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Amount', style: headerStyle),
                        ),
                      ],
                    ),

                    // Table Data Rows
                    ...invoiceData.map((item) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(item.invoiceNumber.toString(),
                                style: textStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(item.status.name.toUpperCase(),
                                style: textStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(item.invoiceDate.toString())),
                              style: textStyle,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('₹ ${item.totalAmount.toString()}',
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
    Directory? directory = Directory('/storage/emulated/0/Download');
    String filePath = '${directory.path}/${partyModel.partyName}_invoice.pdf';

    // Save the file
    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    PermissionStatus status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      CustomSnackBar.showSnack(
        context: context,
        snackBarType: SnackBarType.success,
        message: 'Download successfully',
      );
      OpenFilex.open(filePath);
    } else {
      CustomSnackBar.showSnack(
        context: context,
        snackBarType: SnackBarType.error,
        message: 'Download fail',
      );
    }
    await OpenFilex.open(filePath);
  }

  Future<void> generateAndDownloadCSV(BuildContext context,
      {required List<InvoiceModel> invoiceData,
      required PartyModel partyModel,
      required DateTimeRange dateRange}) async {
    // Request storage permission
    // Create CSV Data
    List<List<dynamic>> csvData = [
      ['Customer Name:', partyModel.partyName], // Customer Name
      [],
      ['Receivable:', partyModel.outstandingBalance], // Receivable Amount
      [],
      ['Financial Year:', formatDateRange(dateRange)], // Due Date
      [],
      ['Invoice No', 'Status', 'Date', 'Amount'], // Table Headers
    ];

    // Add invoice data rows
    for (var item in invoiceData) {
      csvData.add([
        item.invoiceNumber.toString(),
        item.status.name.toUpperCase(),
        DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(item.invoiceDate.toString())), // Format date
        '₹${item.totalAmount.toString()}',
      ]);
    }

    // Convert List to CSV format
    String csv = const ListToCsvConverter().convert(csvData);

    // Save CSV file in Download folder
    Directory directory = Directory('/storage/emulated/0/Download');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    String filePath = '${directory.path}/${partyModel.partyName}_invoice.csv';
    File file = File(filePath);
    await file.writeAsString(csv);
    // 7️⃣ Open file
    PermissionStatus status = await Permission.manageExternalStorage.request();

    // 8️⃣ Open file
    if (status.isGranted) {
      CustomSnackBar.showSnack(
        context: context,
        snackBarType: SnackBarType.success,
        message: 'Download successfully',
      );
      OpenFilex.open(filePath);
    } else {
      CustomSnackBar.showSnack(
        context: context,
        snackBarType: SnackBarType.error,
        message: 'Download fail',
      );
    }
  }
}
