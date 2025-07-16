import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/constants/image_constants.dart';

Future<void> generateInvoice() async {
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

  List<PdfInvoiceItemModel> invoiceItems = [
    PdfInvoiceItemModel(
        itemName: 'Nike',
        id: '0',
        rate: 1000,
        hsn: '45678',
        per: 'Nos',
        amount: 1200),
    PdfInvoiceItemModel(
        itemName: 'Nike1',
        id: '0',
        quantity: 10,
        rate: 1000,
        hsn: '45678',
        per: 'Nos',
        amount: 1200)
  ];
  final pdf = pw.Document();
  final ByteData data =
      await rootBundle.load(ImageConstants.splashLogo); // Load from assets
  final data1 = data.buffer.asUint8List();

  final image = pw.MemoryImage(data1);
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                  color: PdfColors.black, width: 1), // Outer border
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black)),
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Text('TAX INVOICE',
                            style: pw600.copyWith(fontSize: 10)),
                        pw.SizedBox(width: 30),
                        pw.Text('ORIGINAL FOR RECIPIENT',
                            style: pw600.copyWith(fontSize: 10)),
                      ]),
                ),
                pw.Container(
                    decoration: const pw.BoxDecoration(
                        border: pw.Border(
                            bottom: pw.BorderSide(color: PdfColors.black))),
                    child: pw.Row(children: [
                      pw.Container(
                        decoration: const pw.BoxDecoration(
                            border: pw.Border(
                                right: pw.BorderSide(color: PdfColors.black))),
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.all(10),
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        bottom: pw.BorderSide(
                                            color: PdfColors.black))),
                                child: pw.Row(children: [
                                  pw.Container(
                                    color: PdfColors.white,
                                    width: 100, // Set width
                                    height: 100, // Set height
                                    child: pw.Image(image),
                                  ),
                                  pw.SizedBox(width: 30),
                                  pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text('DMart',
                                          style: pw600.copyWith(fontSize: 12)),
                                      pw.Text('GSTIN: 27BLEEP3383G2UT',
                                          style: pw500.copyWith(fontSize: 10)),
                                      pw.Text('35/4, Datta Nagar',
                                          style: pw400.copyWith(fontSize: 8)),
                                      pw.Text('Pune, Maharashtra, 411045',
                                          style: pw400.copyWith(fontSize: 8)),
                                      pw.Text('Mobile: 9876543210',
                                          style: pw400.copyWith(fontSize: 8)),
                                    ],
                                  ),
                                ]),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Customer Details:', style: pw400),
                                    pw.Text('Mahesh Kumar',
                                        style: pw600.copyWith(fontSize: 12)),
                                    pw.Text('Billing Address:',
                                        style: pw500.copyWith(fontSize: 10)),
                                    pw.Text('Phase 3, Rajiv Gandhi Nagar',
                                        style: pw400),
                                    pw.Text('Noida, Uttar Pradesh, 432001',
                                        style: pw400),
                                    pw.Text('Ph: 9876543210', style: pw400),
                                  ],
                                ),
                              )
                            ]),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(left: 10),
                              child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Expanded(
                                      child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text('Invoice #:', style: pw400),
                                            pw.Text('INV-14',
                                                style: pw600.copyWith(
                                                    fontSize: 10)),
                                          ]),
                                    ),
                                    pw.Expanded(
                                      child: pw.Column(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.start,
                                          children: [
                                            pw.Text('Invoice Date: ',
                                                style: pw400),
                                            pw.Text('22 Mar 2022',
                                                style: pw600.copyWith(
                                                    fontSize: 10)),
                                          ]),
                                    )
                                  ]),
                            ),
                            pw.Divider(color: PdfColors.black),
                            pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 10),
                                child: pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Expanded(
                                        child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text('Place of Supply:',
                                                  style: pw400),
                                              pw.Text('Noida',
                                                  style: pw600.copyWith(
                                                      fontSize: 10)),
                                            ]),
                                      ),
                                      pw.Expanded(
                                          child: pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.start,
                                              children: [
                                            pw.Text('Due Date: ', style: pw400),
                                            pw.Text('22 Mar 2022',
                                                style: pw600.copyWith(
                                                    fontSize: 10)),
                                          ]))
                                    ])),
                            pw.Divider(color: PdfColors.black),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(10),
                                child: pw.Column(
                                  children: [
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text('Shipping Address:',
                                            style: pw500),
                                        pw.Text('Phase 3, Rajiv Gandhi Nagar',
                                            style: pw400),
                                        pw.Text('Noida, Uttar Pradesh, 432001',
                                            style: pw400),
                                        pw.Text('Ph: 9876543210', style: pw400),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      )
                    ])),

                // Table Header
                pw.Table(
                  border: const pw.TableBorder(
                    left: pw.BorderSide(),
                    // Left border
                    right: pw.BorderSide(),
                    // Right border
                    verticalInside: pw.BorderSide(color: PdfColors.grey),
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
                      children: [
                        pw.Text('#',
                            textAlign: pw.TextAlign.center, style: pw600),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 4),
                          child: pw.Text('Item',
                              textAlign: pw.TextAlign.left, style: pw600),
                        ),
                        pw.Padding(
                            padding: padding,
                            child: pw.Text('HSN/SAC',
                                textAlign: pw.TextAlign.right, style: pw600)),
                        pw.Padding(
                          padding: padding,
                          child: pw.Text('Qty',
                              textAlign: pw.TextAlign.right, style: pw600),
                        ),
                        pw.Padding(
                          padding: padding,
                          child: pw.Text('Rate',
                              textAlign: pw.TextAlign.right, style: pw600),
                        ),
                        pw.Padding(
                          padding: padding,
                          child: pw.Text('Per',
                              textAlign: pw.TextAlign.right, style: pw600),
                        ),
                        pw.Padding(
                          padding: padding,
                          child: pw.Text('Amount',
                              textAlign: pw.TextAlign.right, style: pw600),
                        )
                      ],
                    ),

                    // Dynamic Rows
                    for (var i = 0; i < invoiceItems.length; i++)
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: padding,
                            child: pw.Text('${i + 1}',
                                style: pw500.copyWith(fontSize: 8),
                                textAlign: pw.TextAlign.center),
                          ),
                          pw.Padding(
                            padding: padding,
                            child: pw.Text(invoiceItems[i].itemName,
                                style: pw500.copyWith(fontSize: 8),
                                textAlign: pw.TextAlign.left),
                          ),
                          pw.Padding(
                            padding: padding,
                            child: pw.Text(invoiceItems[i].hsn ?? ' ',
                                style: pw500.copyWith(fontSize: 8),
                                textAlign: pw.TextAlign.right),
                          ),
                          pw.Padding(
                            padding: padding,
                            child: pw.Text(
                                '${invoiceItems[i].quantity} ${invoiceItems[i].per}',
                                style: pw500.copyWith(fontSize: 8),
                                textAlign: pw.TextAlign.right),
                          ),
                          pw.Padding(
                            padding: padding,
                            child: pw.Text(
                                invoiceItems[i].rate.toStringAsFixed(2),
                                style: pw500.copyWith(fontSize: 8),
                                textAlign: pw.TextAlign.right),
                          ),
                          pw.Padding(
                            padding: padding,
                            child: pw.Text(invoiceItems[i].per ?? '',
                                textAlign: pw.TextAlign.right,
                                style: pw500.copyWith(fontSize: 8)),
                          ),
                          pw.Padding(
                            padding: padding,
                            child: pw.Text(
                                invoiceItems[i].amount.toStringAsFixed(2),
                                style: pw500.copyWith(fontSize: 8),
                                textAlign: pw.TextAlign.right),
                          ),
                        ],
                      ),
                    pw.TableRow(
                      children: [
                        pw.SizedBox(),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 20, right: 4),
                          child: pw.Text('Taxable Amount',
                              textAlign: pw.TextAlign.right,
                              style: pw600.copyWith(fontSize: 8)),
                        ),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 20, right: 4),
                          child: pw.Text('22,220.00',
                              style: pw600.copyWith(fontSize: 8),
                              textAlign: pw.TextAlign.right),
                        )
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.SizedBox(),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 10, right: 4),
                          child: pw.Text(
                            'CGST 9%',
                            style: pw600.copyWith(fontSize: 8),
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 10, right: 4),
                          child: pw.Text('2,000.00',
                              style: pw600.copyWith(fontSize: 8),
                              textAlign: pw.TextAlign.right),
                        )
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.SizedBox(),
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(top: 10, right: 4),
                            child: pw.Text('SGST 9%',
                                textAlign: pw.TextAlign.right,
                                style: pw600.copyWith(fontSize: 8))),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(top: 10, right: 4),
                            child: pw.Text('2,000.00',
                                style: pw600.copyWith(fontSize: 8),
                                textAlign: pw.TextAlign.right)),
                      ],
                    ),
                    // Divider Line
                    pw.TableRow(
                      children: List.generate(7, (index) => pw.Divider()),
                    ),
                    // Total Row
                    pw.TableRow(
                      children: [
                        pw.SizedBox(),
                        pw.Padding(
                          padding: padding,
                          child: pw.Text('Total',
                              textAlign: pw.TextAlign.right, style: pw600),
                        ),
                        pw.SizedBox(),
                        pw.Padding(
                            padding: padding,
                            child: pw.Text('19.00',
                                textAlign: pw.TextAlign.right, style: pw600)),
                        pw.SizedBox(),
                        pw.SizedBox(),
                        pw.Padding(
                            padding: padding,
                            child: pw.Text('₹ 26,220.00',
                                textAlign: pw.TextAlign.right, style: pw600)),
                      ],
                    ),
                  ],
                ),
                pw.Padding(
                  padding:
                      const pw.EdgeInsets.only(left: 10, top: 5, right: 10),
                  child: pw.Text(
                      'Total Amount (in words): INR Six Thousand, Nine Hundred Rupees Only',
                      style: pw400.copyWith(fontSize: 8)),
                ),
                pw.Divider(thickness: 0.5),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Padding(
                    padding:
                        const pw.EdgeInsets.only(left: 10, top: 0, right: 10),
                    child: pw.Text('Amount Payable: ₹ 26,900.00',
                        style: pw400.copyWith(fontSize: 8),
                        textAlign: pw.TextAlign.right),
                  ),
                ),
                pw.Divider(thickness: 0.5),
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(
                          bottom: pw.BorderSide(color: PdfColors.black))),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Bank Details:',
                              style: pw600.copyWith(fontSize: 8)),
                          pw.Text('Bank: Yes Bank',
                              style: pw600.copyWith(fontSize: 8)),
                          pw.Text('Account #: 09876787687687',
                              style: pw600.copyWith(fontSize: 8)),
                          pw.Text('IFSC: YESB9907',
                              style: pw600.copyWith(fontSize: 8)),
                          pw.Text('Branch: Noida',
                              style: pw600.copyWith(fontSize: 8)),
                        ],
                      ),
                      pw.Column(children: [
                        pw.Text('Pay using UPI',
                            style: pw600.copyWith(fontSize: 8)),
                        pw.Container(
                          width: 100,
                          height: 100,
                          color: PdfColors.grey200,
                          child: pw.Center(child: pw.Text('QR Code Here')),
                        ),
                      ]),
                      pw.Container(
                        child: pw.Column(
                            children: [pw.Text('For Company', style: pw400)]),
                      )
                    ],
                  ),
                ),

                pw.SizedBox(height: 10),

                // Notes and Terms
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Notes:', style: pw600.copyWith(fontSize: 8)),
                          pw.Text('Lorem Ipsum', style: pw400),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Terms and Conditions:',
                              style: pw600.copyWith(fontSize: 8)),
                          pw.Text(
                              '1. Reverse engineer, decompile, reverse compile.',
                              style: pw400.copyWith(fontSize: 7)),
                          pw.Text('2. Copy or reproduce in any form.',
                              style: pw400.copyWith(fontSize: 7)),
                          pw.Text('3. Publish, display, disclose, sell.',
                              style: pw400.copyWith(fontSize: 7)),
                          pw.Text('4. Create derivative works.',
                              style: pw400.copyWith(fontSize: 7)),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ));
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
