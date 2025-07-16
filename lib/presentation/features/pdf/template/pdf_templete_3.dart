import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/constants/image_constants.dart';
import '../../../../core/data/apis/models/company/company_model.dart';
import '../../../../core/data/apis/models/invoice/invoice_model.dart';
import '../../../../core/data/apis/models/items/item_model.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
import '../../../../core/utils/date_utility.dart';
import '../../../../core/utils/double_extension.dart';

Future<void> generateInvoice2(
  InvoiceModel invoice,
  List<ItemModel> items,
  PartyModel party,
  CompanyModel company,
) async {
  final w500 =
      pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Medium.ttf'));
  final w600 =
      pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-SemiBold.ttf'));
  final w400 =
      pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Regular.ttf'));
  pw.TextStyle pw500 = pw.TextStyle(fontSize: 10, font: w500);
  pw.TextStyle pw600 = pw.TextStyle(fontSize: 10, font: w600);
  pw.TextStyle pw400 = pw.TextStyle(fontSize: 10, font: w400);
  final pw.EdgeInsets padding = const pw.EdgeInsets.all(4);
  final PdfColor lightPink = const PdfColor.fromInt(0xFFF5CDCD);
  List<PdfInvoiceItemModel> invoiceItems = invoice.invoiceItems
      .map(
        (e) => PdfInvoiceItemModel(
          itemName: e.itemName,
          id: e.id,
          rate: e.rate,
          hsn: e.hashCode.toString(),
          per: e.taxPercent.toStringAsFixed(2),
          amount: e.finalAmount,
        ),
      )
      .toList();
  final List<Map<String, dynamic>> taxData = [invoice.gstPercentage];
  pw.Widget mainTableHeader({required String title, required bool right}) {
    return pw.Padding(
        padding: padding,
        child: pw.Text(title,
            textAlign: right ? pw.TextAlign.right : pw.TextAlign.center,
            style: pw600));
  }

  pw.Widget mainTableData({required String data, required bool left}) {
    return pw.Padding(
      padding: padding,
      child: pw.Text(data,
          style: pw500.copyWith(fontSize: 8),
          textAlign: left ? pw.TextAlign.left : pw.TextAlign.right),
    );
  }

  final pdf = pw.Document();
  final ByteData data =
      await rootBundle.load(ImageConstants.splashLogo); // Load from assets
  final data1 = data.buffer.asUint8List();

  final image = pw.MemoryImage(data1);
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              children: [
                pw.Text(
                  'TAX INVOICE',
                  style: pw600.copyWith(fontSize: 10),
                ),
                pw.Text(
                  '[ORIGINAL FOR RECIPIENT]',
                  style: pw400.copyWith(
                    fontSize: 10,
                    color: const PdfColor(135 / 255, 133 / 255, 151 / 255),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Table(
                      columnWidths: {
                        0: const pw.FixedColumnWidth(2),
                        1: const pw.FixedColumnWidth(2),
                      },
                      border: pw.TableBorder.all(), // Add border for visibility
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Container(
                                    padding: const pw.EdgeInsets.all(8),
                                    width: 70,
                                    height: 50,
                                    // Ensure proper width & height
                                    child: pw.Image(image),
                                  ),
                                  pw.Container(
                                    padding: const pw.EdgeInsets.all(8),
                                    child: pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          company.companyName,
                                          style: pw.TextStyle(
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.bold,
                                          ),
                                        ),
                                        pw.Text(
                                          company.companyAddress,
                                          style: const pw.TextStyle(
                                            fontSize: 8,
                                          ),
                                        ),
                                        pw.Row(
                                          children: [
                                            pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: [
                                                pw.Text(
                                                  'GSTIN:',
                                                  style: pw.TextStyle(
                                                      fontSize: 8,
                                                      fontWeight:
                                                          pw.FontWeight.bold),
                                                ),
                                                pw.Text(
                                                  company.companyGstin,
                                                  style: const pw.TextStyle(
                                                    fontSize: 8,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            pw.SizedBox(width: 5),
                                            pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: [
                                                pw.Text(
                                                  'Mobile:',
                                                  style: pw.TextStyle(
                                                      fontSize: 8,
                                                      fontWeight:
                                                          pw.FontWeight.bold),
                                                ),
                                                pw.Text(
                                                  company.companyPhone,
                                                  style: const pw.TextStyle(
                                                    fontSize: 8,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        pw.Row(children: [
                                          pw.Text(
                                            'Email:',
                                            style: pw600.copyWith(
                                              fontSize: 8,
                                            ),
                                          ),
                                          pw.Text(
                                            company.companyEmail,
                                            style: pw400.copyWith(
                                              fontSize: 8,
                                            ),
                                          ),
                                        ])
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            pw.Container(
                              child: pw.Table(
                                border: const pw.TableBorder(
                                    horizontalInside: pw.BorderSide(),
                                    verticalInside: pw.BorderSide()),
                                children: [
                                  pw.TableRow(
                                    children: [
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(10),
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text('Invoice #:', style: pw400),
                                            pw.Text(
                                              invoice.invoiceNumber.toString(),
                                              style:
                                                  pw600.copyWith(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(10),
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text('Invoice Date: ',
                                                style: pw400),
                                            pw.Text(
                                              invoice.invoiceDate
                                                  .convertToDisplay(),
                                              style:
                                                  pw600.copyWith(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.TableRow(
                                    children: [
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(10),
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text(
                                              'Place of Supply:',
                                              style: pw400,
                                            ),
                                            pw.Text(
                                              'Noida',
                                              style:
                                                  pw600.copyWith(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(10),
                                        child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text('Due Date: ', style: pw400),
                                            pw.Text(
                                              invoice.dueDate
                                                      ?.convertToDisplay() ??
                                                  '',
                                              style:
                                                  pw600.copyWith(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FixedColumnWidth(2),
                      1: const pw.FixedColumnWidth(2),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('BILL TO:', style: pw400),
                                pw.Text(
                                  party.partyName,
                                  style: pw600.copyWith(fontSize: 12),
                                ),
                                pw.Text(party.businessAddress ?? '',
                                    style: pw400),
                                pw.Text('Ph: ${party.phone}', style: pw400),
                              ],
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('SHIP TO:', style: pw400),
                                pw.Text(
                                  party.partyName,
                                  style: pw600.copyWith(fontSize: 12),
                                ),
                                pw.Text(party.businessAddress ?? '',
                                    style: pw400),
                                pw.Text('Ph: ${party.phone}', style: pw400),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  pw.Table(
                    border: const pw.TableBorder(
                      left: pw.BorderSide(),
                      // Left border
                      right: pw.BorderSide(),
                      // Right border
                      verticalInside: pw.BorderSide(color: PdfColors.black),
                      // Vertical lines between columns
                      top: pw.BorderSide.none,
                      // No top border
                      bottom: pw.BorderSide(),
                      // No bottom border
                      horizontalInside:
                          pw.BorderSide.none, // No horizontal lines inside
                    ),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(1), // #
                      1: const pw.FlexColumnWidth(3), // Item
                      2: const pw.FlexColumnWidth(2), // HSN/SAC
                      3: const pw.FlexColumnWidth(2), // Qty
                      4: const pw.FlexColumnWidth(2), // Rate
                      5: const pw.FlexColumnWidth(2), // Per
                      6: const pw.FlexColumnWidth(3), // Amount
                    },
                    children: [
                      // Header Row
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                            color: lightPink,
                            border: pw.Border.all(color: PdfColors.black)),
                        children: [
                          mainTableHeader(title: 'S.NO', right: false),
                          mainTableHeader(title: 'ITEM', right: false),
                          mainTableHeader(title: 'HSN/SAC', right: false),
                          mainTableHeader(title: 'QTY', right: false),
                          mainTableHeader(title: 'RATE', right: false),
                          mainTableHeader(title: 'TAX', right: false),
                          mainTableHeader(title: 'AMOUNT', right: false)
                        ],
                      ),

                      // Dynamic Rows
                      for (var i = 0; i < invoiceItems.length; i++)
                        pw.TableRow(
                          children: [
                            mainTableData(data: '${i + 1}', left: false),
                            mainTableData(
                                data: invoiceItems[i].itemName, left: true),
                            mainTableData(
                                data: invoiceItems[i].hsn ?? ' ', left: false),
                            mainTableData(
                              data:
                                  '${invoiceItems[i].quantity} ${invoiceItems[i].per}',
                              left: false,
                            ),
                            mainTableData(
                              data: invoiceItems[i].rate.toStringAsFixed(2),
                              left: false,
                            ),
                            mainTableData(
                                data: invoiceItems[i].per ?? '', left: false),
                            mainTableData(
                              data: invoiceItems[i].amount.toStringAsFixed(2),
                              left: false,
                            )
                          ],
                        ),
                      pw.TableRow(
                        children: List.generate(
                          7,
                          (_) => pw.SizedBox(height: 10),
                        ),
                      ),
                      pw.TableRow(
                        children: List.generate(
                          7,
                          (_) => pw.SizedBox(height: 10),
                        ),
                      ),
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: lightPink,
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        children: [
                          pw.SizedBox(),
                          mainTableHeader(title: 'table', right: true),
                          pw.SizedBox(),
                          mainTableHeader(title: '234', right: true),
                          pw.SizedBox(),
                          pw.SizedBox(),
                          mainTableHeader(title: '2345', right: true),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    border: const pw.TableBorder(
                      left: pw.BorderSide(),
                      // Left border
                      right: pw.BorderSide(),
                      // Right border
                      verticalInside: pw.BorderSide(color: PdfColors.black),
                      // Vertical lines between columns
                      top: pw.BorderSide.none,
                      // No top border
                      bottom: pw.BorderSide(),
                      // No bottom border
                      horizontalInside:
                          pw.BorderSide.none, // No horizontal lines inside
                    ),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(6), // #
                      1: const pw.FlexColumnWidth(6), // Item
                      2: const pw.FlexColumnWidth(3), // HSN/SAC
                      // Amount
                    },
                    children: [
                      // Header Row
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black)),
                        children: [
                          mainTableHeader(
                              title: 'RECEIVED AMOUNT', right: true),
                          mainTableHeader(title: '', right: true),
                          mainTableHeader(
                              title: '${invoice.totalAmount}', right: true),
                        ],
                      ),
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black)),
                        children: [
                          mainTableHeader(
                              title: 'PREVIOUS BALANCE', right: true),
                          mainTableHeader(title: '', right: true),
                          mainTableHeader(
                            title: '${party.outstandingBalance}',
                            right: true,
                          ),
                        ],
                      ),
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.black)),
                        children: [
                          mainTableHeader(
                              title: 'CURRENT BALANCE', right: true),
                          mainTableHeader(title: '', right: true),
                          mainTableHeader(
                            title:
                                '${invoice.totalAmount - party.outstandingBalance}',
                            right: true,
                          ),
                        ],
                      ),

                      // Dynamic Rows
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    width: PdfPageFormat.a4.width,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black),
                    ),
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      'Total Amount (in words): INR ${invoice.totalAmount.toWords()} Rupees Only',
                      style: pw400.copyWith(
                        fontSize: 8,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    columnWidths: {
                      0: const pw.FixedColumnWidth(2),
                      1: const pw.FixedColumnWidth(2),
                      2: const pw.FixedColumnWidth(2),
                      3: const pw.FixedColumnWidth(2),
                      4: const pw.FixedColumnWidth(2),
                    },
                    border: pw.TableBorder.all(color: PdfColors.black),
                    children: [
                      // Header row
                      pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: lightPink,
                        ),
                        children: [
                          _buildHeaderCell('HSN/SAC'),
                          _buildHeaderCell('Taxable Value'),
                          _buildComplexHeaderCell('CGST', ['Rate', 'Amount']),
                          _buildComplexHeaderCell('SGST', ['Rate', 'Amount']),
                          _buildHeaderCell('AMOUNT'),
                        ],
                      ),
                      // Data rows
                      ...taxData.map((row) => pw.TableRow(
                            children: [
                              _buildDataCell(row['hsn'].toString()),
                              _buildDataCell(row['taxableValue'].toString()),
                              _buildComplexDataCell(row['cgstRate'].toString(),
                                  row['cgstAmount'].toString()),
                              _buildComplexDataCell(row['sgstRate'].toString(),
                                  row['sgstAmount'].toString()),
                              _buildDataCell(row['amount'].toString()),
                            ],
                          )),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.black),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3), // #
                        1: const pw.FlexColumnWidth(3), // Item
                        2: const pw.FlexColumnWidth(3), // HSN/SAC
                        // Amount
                      },
                      children: [
                        pw.TableRow(children: [
                          /* pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Bank Details:',
                                style: pw600.copyWith(fontSize: 8)),
                            pw.SizedBox(height: 7),
                            pw.Row(children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Bank:',
                                        style: pw400.copyWith(fontSize: 8)),
                                    pw.Text('Account #: ',
                                        style: pw400.copyWith(fontSize: 8)),
                                    pw.Text('IFSC:',
                                        style: pw400.copyWith(fontSize: 8)),
                                    pw.Text('Branch: ',
                                        style: pw400.copyWith(fontSize: 8)),
                                  ]),
                              pw.SizedBox(width: 20),
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('${invoice.}',
                                        style: pw600.copyWith(fontSize: 8)),
                                    pw.Text('09876787687687',
                                        style: pw600.copyWith(fontSize: 8)),
                                    pw.Text('YESB9907',
                                        style: pw600.copyWith(fontSize: 8)),
                                    pw.Text('Noida',
                                        style: pw600.copyWith(fontSize: 8)),
                                  ])
                            ])
                          ],
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Pay using UPI',
                                        style: pw600.copyWith(fontSize: 8)),
                                    pw.Text('UPI ID:',
                                        style: pw400.copyWith(fontSize: 8)),
                                    pw.Text('87hy876543766@ybl',
                                        style: pw400.copyWith(fontSize: 8))
                                  ]),
                              pw.Center(
                                child: pw.Container(
                                  width: 50,
                                  height: 50,
                                  color: PdfColors.grey200,
                                ),
                              ),
                            ]),
                      ), */
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'Terms and Conditions:',
                                  style: pw600.copyWith(fontSize: 8),
                                ),
                                pw.Text(
                                  '1. Reverse engineer, decompile, reverse compile.',
                                  style: pw400.copyWith(fontSize: 7),
                                ),
                                pw.Text(
                                  '2. Copy or reproduce in any form.',
                                  style: pw400.copyWith(fontSize: 7),
                                ),
                                pw.Text(
                                  '3. Publish, display, disclose, sell.',
                                  style: pw400.copyWith(fontSize: 7),
                                ),
                                pw.Text(
                                  '4. Create derivative works.',
                                  style: pw400.copyWith(fontSize: 7),
                                ),
                              ],
                            ),
                          )
                        ])
                      ]),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black)),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Notes:',
                              style: pw600.copyWith(fontSize: 8),
                            ),
                            pw.Text(invoice.notes, style: pw400),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  // Save PDF File
  final output = await getExternalStorageDirectory();
  final file = File('${output!.path}/invoice.pdf');
  await file.writeAsBytes(await pdf.save());
  OpenFilex.open(file.path);
}

class PdfInvoiceItemModel {
  final String id;

  final String? itemId;
  final String? hsn;
  final int quantity;
  final String? per;
  final double rate;
  final double amount;
  final String itemName;

  PdfInvoiceItemModel(
      {this.id = '',
      this.itemId,
      this.quantity = 0,
      this.rate = 0.0,
      this.amount = 0.0,
      this.per = '',
      this.hsn = '',
      this.itemName = ''});

  PdfInvoiceItemModel copyWith(
      {String? id,
      String? itemId,
      int? quantity,
      double? rate,
      String? per,
      double? amount,
      String? hsn,
      String? itemName}) {
    return PdfInvoiceItemModel(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        quantity: quantity ?? this.quantity,
        rate: rate ?? this.rate,
        itemName: itemName ?? this.itemName,
        hsn: hsn ?? this.hsn,
        per: per ?? this.per,
        amount: amount ?? this.amount);
  }
}

pw.Widget _buildHeaderCell(String text) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(8),
    alignment: pw.Alignment.center,
    child: pw.Text(
      text,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
      textAlign: pw.TextAlign.center,
    ),
  );
}

pw.Widget _buildComplexHeaderCell(String title, List<String> subtitles) {
  return pw.Table(
    children: [
      pw.TableRow(
        children: [
          pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 2),
              child: pw.Center(
                  child: pw.Text(title,
                      style: pw.TextStyle(
                          fontSize: 8, fontWeight: pw.FontWeight.bold))))
        ],
      ),
      pw.TableRow(
        children: [
          pw.Table(
            columnWidths: {
              0: const pw.FixedColumnWidth(2),
              1: const pw.FixedColumnWidth(2),
            },
            border: const pw.TableBorder(
                top: pw.BorderSide(), verticalInside: pw.BorderSide()),
            children: [
              pw.TableRow(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      subtitles[0],
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    alignment: pw.Alignment.center,
                    child: pw.Text(
                      subtitles[1],
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

pw.Widget _buildDataCell(String text) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(8),
    alignment: pw.Alignment.center,
    child: pw.Text(
      text,
      style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.normal),
      textAlign: pw.TextAlign.center,
    ),
  );
}

pw.Widget _buildComplexDataCell(String rate, String amount) {
  return pw.Table(
    columnWidths: {
      0: const pw.FixedColumnWidth(2),
      1: const pw.FixedColumnWidth(2),
    },
    border: const pw.TableBorder(
        top: pw.BorderSide(), verticalInside: pw.BorderSide()),
    children: [
      pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Center(
              child: pw.Text(
                rate,
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Center(
              child: pw.Text(
                amount,
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
