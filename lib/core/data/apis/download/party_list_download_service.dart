// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../../utils/logger.dart';
import '../models/party/party_model.dart';

class PartyList {
  Future<void> generateAndDownloadExcel(BuildContext context, {required List<PartyModel> partyList}) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['PartyList'];

    final headerStyle = CellStyle(bold: true, fontSize: 14);
    final normalStyle = CellStyle(fontSize: 12);

    int rowIndex = 0;
    int srNo = 1;

    sheet.appendRow([
      TextCellValue('Sr No'),
      TextCellValue('Party Name'),
      TextCellValue('Party Type'),
      TextCellValue('Phone Number'),
      TextCellValue('Email'),
      TextCellValue('Amount'),
      TextCellValue('GST'),
      TextCellValue('PAN'),
      TextCellValue('Status'),
      TextCellValue('Billing Address'),
      TextCellValue('Billing PinCode'),
      TextCellValue('Billing State'),
      TextCellValue('Billing City'),
    ]);

    for (int col = 0; col < 13; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex)).cellStyle = headerStyle;
    }
    rowIndex++;

    for (var party in partyList) {
      sheet.appendRow([
        TextCellValue(srNo.toString()),
        TextCellValue(party.partyName),
        TextCellValue(party.type.name),
        TextCellValue(party.phone ?? 'N/A'),
        TextCellValue(party.email ?? 'N/A'),
        TextCellValue('₹${party.outstandingBalance}'),
        TextCellValue(party.gstin ?? 'N/A'),
        TextCellValue(party.pan ?? 'N/A'),
        TextCellValue(party.status ?? 'N/A'),
        TextCellValue(party.businessAddress ?? 'N/A'),
        TextCellValue(party.pinCode ?? 'N/A'),
        TextCellValue(party.state ?? 'N/A'),
        TextCellValue(party.city ?? 'N/A'),
      ]);

      for (int col = 0; col < 13; col++) {
        sheet.setColumnWidth(col, 20.0);
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex)).cellStyle = normalStyle;
      }

      rowIndex++;
      srNo++;
    }

    List<int>? excelBytes = excel.encode();
    if (excelBytes == null) {
      CustomSnackBar.showSnack(context: context, snackBarType: SnackBarType.error, message: 'Excel encoding failed');
      return;
    }

    if (!await Permission.manageExternalStorage.request().isGranted) {
      openAppSettings();
      return;
    }

    final downloadsDir = Directory('/storage/emulated/0/Download');
    final filePath = '${downloadsDir.path}/parties.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(excelBytes);

    CustomSnackBar.showSnack(context: context, snackBarType: SnackBarType.success, message: 'Downloaded successfully');
    OpenFilex.open(filePath);
  }

  Future<void> generateAndDownloadPDF(BuildContext context, {required List<PartyModel> partyData}) async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
    final poppinsRegular = pw.Font.ttf(fontData);

    final boldFontData = await rootBundle.load('assets/fonts/Poppins-Bold.ttf');
    final poppinsBold = pw.Font.ttf(boldFontData);

    final headerStyle = pw.TextStyle(fontSize: 14, font: poppinsBold, fontWeight: pw.FontWeight.bold);
    final textStyle = pw.TextStyle(font: poppinsRegular, fontSize: 14);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Text('Party List', style: headerStyle)),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Sr No', style: headerStyle)),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Party Name', style: headerStyle)),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Phone', style: headerStyle)),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Email', style: headerStyle)),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Party Type', style: headerStyle)),
                      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('Amount', style: headerStyle)),
                    ],
                  ),
                  ...partyData.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    var party = entry.value;
                    return pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(index.toString(), style: textStyle)),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(party.partyName, style: textStyle)),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(party.phone ?? '', style: textStyle)),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(party.email ?? '', style: textStyle)),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(party.type.name, style: textStyle)),
                        pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text('₹ ${party.outstandingBalance}', style: textStyle)),
                      ],
                    );
                  })
                ],
              ),
            ],
          );
        },
      ),
    );

    if (!await Permission.manageExternalStorage.request().isGranted) {
      openAppSettings();
      return;
    }

    final directory = Directory('/storage/emulated/0/Download');
    final filePath = '${directory.path}/PartyList.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    CustomSnackBar.showSnack(
      context: context,
      snackBarType: SnackBarType.success,
      message: 'Download successfully',
    );

    OpenFilex.open(filePath);
  }

  Future<void> generateAndDownloadCSV(BuildContext context, {required List<PartyModel> party}) async {
    List<List<dynamic>> csvData = [
      [
        'Sr No',
        'Party Name',
        'Phone',
        'Email',
        'Party Type',
        'Gst',
        'PAN',
        'Status',
        'Billing Address',
        'Billing PinCode',
        'Billing State',
        'Billing City',
      ],
    ];

    int srNo = 1;
    for (var item in party) {
      csvData.add([
        srNo++,
        item.partyName,
        item.phone ?? 'N/A',
        item.email ?? 'N/A',
        item.type.name,
        item.gstin ?? 'N/A',
        item.pan ?? 'N/A',
        item.status ?? 'N/A',
        item.businessAddress ?? 'N/A',
        item.pinCode ?? 'N/A',
        item.state ?? 'N/A',
        item.city ?? 'N/A',
      ]);
    }

    String csv = const ListToCsvConverter().convert(csvData);

    if (!await Permission.manageExternalStorage.request().isGranted) {
      openAppSettings();
      return;
    }

    final directory = Directory('/storage/emulated/0/Download');
    final filePath = '${directory.path}/parties.csv';
    final file = File(filePath);
    await file.writeAsString(csv);

    CustomSnackBar.showSnack(
      context: context,
      snackBarType: SnackBarType.success,
      message: 'Download successfully',
    );

    OpenFilex.open(filePath);
  }
}
