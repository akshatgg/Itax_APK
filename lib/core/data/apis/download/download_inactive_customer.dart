import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../models/party/party_model.dart';

class InActiveCustomer {
  String formatDateRange(DateTime range) {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    String startDate = formatter.format(range);
    return startDate;
  }

  Future<void> generateAndDownloadPDF({
    required List<PartyModel> partyData,
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

    // **Filter inactive customers**
    List<PartyModel> inactiveCustomers = partyData.where((customer) {
      if (customer.invoices.isNotEmpty) {
        DateTime lastSalesDate = customer.invoices
            .map((invoice) => invoice.invoiceDate)
            .reduce((a, b) => a.isAfter(b) ? a : b);

        return today.difference(lastSalesDate).inDays > 30;
      }
      return true; // Include customers with no sales history
    }).toList();

    // **Create PDF content**
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Inactive Customer List', style: headerStyle),
              pw.SizedBox(height: 20),

              // **Table Header**
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
                        child: pw.Text('Name', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Last Sales Date', style: headerStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Inactive Since', style: headerStyle),
                      ),
                    ],
                  ),

                  // **Table Data Rows**
                  ...inactiveCustomers.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    PartyModel customer = entry.value;

                    DateTime lastSalesDate = customer.invoices.isNotEmpty
                        ? customer.invoices
                            .map((invoice) => invoice.invoiceDate)
                            .reduce((a, b) => a.isAfter(b) ? a : b)
                        : today;

                    int inactiveDays = today.difference(lastSalesDate).inDays;

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(index.toString(), style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(customer.partyName, style: textStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            formatDateRange(lastSalesDate),
                            style: textStyle,
                          ),
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

    // **Save and Open PDF**
    Directory? directory = await getDownloadsDirectory();
    String filePath = '${directory?.path}/inactive_customers.pdf';

    File file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(filePath);
  }
}
