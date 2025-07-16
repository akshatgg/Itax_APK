import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/invoice_status.dart';
import '../../../../core/constants/enums/invoice_type.dart';
import '../../../../core/constants/enums/party_type.dart';
import '../../../../core/data/apis/download/download_customer_service.dart';
import '../../../../core/data/apis/models/invoice/invoice_model.dart';
import '../../../../core/data/apis/models/invoice/notes_model.dart';
import '../../../../core/data/apis/models/invoice/receipt_model.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
import '../../../../core/utils/date_utility.dart';
import '../../../../core/utils/list_extenstion.dart';
import '../../../../shared/utils/widget/calender_widget.dart';
import '../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../shared/utils/widget/custom_image.dart';
import '../../../../shared/utils/widget/date_range.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/no_data_widget.dart';
import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../../../shared/utils/widget/sort_by_bottom_model_sheet.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';
import '../../invoice/domain/invoice/invoice_bloc.dart';
import '../../invoice/domain/notes/notes_bloc.dart';
import '../../invoice/domain/receipt/receipt_bloc.dart';
import '../domain/parties/parties_bloc.dart';
import 'widget/customer_detail_download_widget.dart';

class PartyDetailScreen extends StatefulHookWidget {
  const PartyDetailScreen({super.key, required this.partyModel});

  final PartyModel partyModel;

  @override
  State<PartyDetailScreen> createState() => _PartyDetailScreenState();
}

class _PartyDetailScreenState extends State<PartyDetailScreen> {
  List<Widget> _getInvoiceWidgets(
    List<InvoiceModel> invoiceList,
    List<ReceiptModel> receiptList,
    List<NotesModel> notesList,
    DateTimeRange selectedDateRange,
    ValueNotifier<int> sortingTypeNotifier,
  ) {
    final List<Map<String, dynamic>> allEntries = [];

    // Filter and map invoices
    for (final invoice in invoiceList) {
      if (invoice.partyId == widget.partyModel.id &&
          invoice.invoiceDate.isAfter(selectedDateRange.start) &&
          invoice.invoiceDate.isBefore(selectedDateRange.end)) {
        allEntries.add({
          'invoiceNumber': invoice.invoiceNumber,
          'status': invoice.status,
          'totalAmount': invoice.totalAmount,
          'invoiceDate': invoice.invoiceDate,
          'type': invoice.type,
          'onTap': () {
            RouterHelper.push(
              context,
              AppRoutes.createSalesInvoice.name,
              extra: {'invoice': invoice.toJson(), 'type': invoice.type},
            );
          },
        });
      }
    }

    // Filter and map receipts
    for (final receipt in receiptList) {
      if (receipt.partyId == widget.partyModel.id &&
          receipt.invoiceDate.isAfter(selectedDateRange.start) &&
          receipt.invoiceDate.isBefore(selectedDateRange.end)) {
        allEntries.add({
          'invoiceNumber': receipt.receiptNumber,
          'status': receipt.type == InvoiceType.receipt
              ? InvoiceStatus.paid
              : InvoiceStatus.unpaid,
          'totalAmount': receipt.totalAmount,
          'invoiceDate': receipt.invoiceDate,
          'type': receipt.type,
          'onTap': () {
            RouterHelper.push(
              context,
              AppRoutes.createReceiptInvoice.name,
              extra: {'receipt': receipt.toJson(), 'type': receipt.type},
            );
          },
        });
      }
    }

    // Filter and map notes
    for (final note in notesList) {
      if (note.partyId == widget.partyModel.id &&
          note.invoiceDate.isAfter(selectedDateRange.start) &&
          note.invoiceDate.isBefore(selectedDateRange.end)) {
        allEntries.add({
          'invoiceNumber': note.invoiceNumber,
          'status': note.type == InvoiceType.creditNote
              ? InvoiceStatus.unpaid
              : InvoiceStatus.paid,
          'totalAmount': note.totalAmount,
          'invoiceDate': note.invoiceDate,
          'type': note.type,
          'onTap': () {
            RouterHelper.push(
              context,
              AppRoutes.createNoteInvoice.name,
              extra: {'note': note.toJson(), 'type': note.type},
            );
          },
        });
      }
    }

    // Sort based on sortingTypeNotifier
    switch (sortingTypeNotifier.value) {
      case 0: // Amount High to Low
        allEntries.sort((a, b) =>
            (b['totalAmount'] as num).compareTo(a['totalAmount'] as num));
        break;
      case 1: // Amount Low to High
        allEntries.sort((a, b) =>
            (a['totalAmount'] as num).compareTo(b['totalAmount'] as num));
        break;
      case 2: // Date Newest First
        allEntries.sort((a, b) => (b['invoiceDate'] as DateTime)
            .compareTo(a['invoiceDate'] as DateTime));
        break;
      case 3: // Date Oldest First
        allEntries.sort((a, b) => (a['invoiceDate'] as DateTime)
            .compareTo(b['invoiceDate'] as DateTime));
        break;
    }

    // Generate itemWidgets
    final invoiceWidgets = allEntries.map((entry) {
      return itemWidget(
        onTap: entry['onTap'] as VoidCallback,
        invoiceNumber: entry['invoiceNumber'] as int,
        status: entry['status'] as InvoiceStatus,
        totalAmount: entry['totalAmount'] as double,
        invoiceDate: entry['invoiceDate'] as DateTime,
        type: entry['type'] as InvoiceType,
      );
    }).toList();

    return invoiceWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final invoiceTypeNotifier = useState(0);
    final selectedDateRange = useState(getCurrentFinancialYearRange());
    final invoiceList = context.watch<InvoiceBloc>().state.invoices;
    final receiptList = context.watch<ReceiptBloc>().state.receipts;
    final notesList = context.watch<NotesBloc>().state.notes;
    final sortingTypeNotifier = useState(0);
    List<Widget> invoiceWidgets = _getInvoiceWidgets(invoiceList, receiptList,
        notesList, selectedDateRange.value, sortingTypeNotifier);

    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(215.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => RouterHelper.pop<void>(context),
                      child:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        widget.partyModel.type == PartyType.customer
                            ? 'Customer Details'
                            : 'Supplier Details',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    BlocListener<PartiesBloc, PartiesState>(
                        listener: (context, state) {
                      if (state is PartyDeleteOperationSuccess) {
                        CustomSnackBar.showSnack(
                          context: context,
                          snackBarType: SnackBarType.success,
                          message: 'Party delete Successfully',
                        );
                        RouterHelper.pop<void>(context);
                      }
                      if (state is PartyDeleteOperationFailed) {
                        CustomSnackBar.showSnack(
                          context: context,
                          snackBarType: SnackBarType.success,
                          message: 'Party delete Failed',
                        );
                        RouterHelper.pop<void>(context);
                      }
                    }, child: BlocBuilder<InvoiceBloc, InvoiceState>(
                      builder: (context, state) {
                        /* List<InvoiceModel> filteredInvoices = state.invoices
                            .where((invoice) =>
                                invoice.partyId == widget.partyModel.id)
                            .toList(); */
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return SortByBottomSheet(
                                  onClickItem: (index) {
                                    sortingTypeNotifier.value = index;
                                    RouterHelper.pop<void>(context);
                                  },
                                );
                              },
                            );
                          },
                          // commonBottomSheet(context,
                          // child: CustomerDetailDownloadWidget(
                          //   list: true,
                          //   type: 'customer',
                          //   onClickItem: (index) {
                          //     if (index == 0) {
                          //       CustomerServices().generateAndDownloadExcel(
                          //           context,
                          //           invoiceData: filteredInvoices,
                          //           partyModel: widget.partyModel,
                          //           dateRange: selectedDateRange.value);
                          //     }
                          //     if (index == 1) {
                          //       CustomerServices().generateAndDownloadPDF(
                          //           context,
                          //           partyModel: widget.partyModel,
                          //           invoiceData: filteredInvoices,
                          //           dateRange: selectedDateRange.value);
                          //     }
                          //     if (index == 2) {
                          //       CustomerServices().generateAndDownloadCSV(
                          //           context,
                          //           invoiceData: filteredInvoices,
                          //           partyModel: widget.partyModel,
                          //           dateRange: selectedDateRange.value);
                          //     }
                          //     if (index == 4) {
                          //       _onDeleteParty();
                          //     }
                          //     if (index == 3) {
                          //       RouterHelper.push(
                          //           context, AppRoutes.addParty.name,
                          //           extra: {
                          //             'party': widget.partyModel.toJson(),
                          //           });
                          //     }
                          //     RouterHelper.pop<void>(context);
                          //   },
                          // ));},
                          child: Icon(
                            CupertinoIcons.sort_up,
                            size: 25.px,
                            color: AppColor.white,
                          ),
                        );
                      },
                    ))
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              BlocBuilder<PartiesBloc, PartiesState>(
                builder: (context, state) {
                  final PartyModel updatedParty;
                  if (widget.partyModel.type == PartyType.customer) {
                    updatedParty = state.customers.firstWhereOrNull(
                            (i) => i.id == widget.partyModel.id) ??
                        widget.partyModel;
                  } else {
                    updatedParty = state.suppliers.firstWhereOrNull(
                            (i) => i.id == widget.partyModel.id) ??
                        widget.partyModel;
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      children: [
                        Container(
                          height: 60.px,
                          width: 60.px,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: AppColor.white, shape: BoxShape.circle),
                          child: Text(
                            updatedParty.partyName[0],
                            style: AppTextStyle.pw500.copyWith(
                                color: AppColor.black, fontSize: 28.px),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    updatedParty.partyName,
                                    style: AppTextStyle.pw400.copyWith(
                                        color: AppColor.white, fontSize: 20.px),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '₹ ${widget.partyModel.outstandingBalance}',
                                        style: AppTextStyle.pw600.copyWith(
                                            color: AppColor.white,
                                            fontSize: 20.px),
                                      ),
                                      Text(
                                        ' (${widget.partyModel.type == PartyType.customer ? 'Receivables' : 'Payables'})',
                                        style: AppTextStyle.pw400.copyWith(
                                            color: AppColor.white,
                                            fontSize: 12.px),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        CustomImageView(
                          onTap: () {
                            openWhatsApp('+91${widget.partyModel.phone}');
                          },
                          height: 20.px,
                          width: 20.px,
                          fit: BoxFit.cover,
                          imagePath: 'assets/images/whatsapp.png',
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'WhatsApp',
                          style: AppTextStyle.pw500
                              .copyWith(color: AppColor.white, fontSize: 12.px),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        makePhoneCall('+91${widget.partyModel.phone}');
                      },
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.phone,
                            color: AppColor.white,
                            size: 20.px,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Call',
                            style: AppTextStyle.pw500.copyWith(
                                color: AppColor.white, fontSize: 12.px),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        openEmail(widget.partyModel.email ?? '');
                      },
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.mail,
                            color: AppColor.white,
                            size: 20.px,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Email',
                            style: AppTextStyle.pw500.copyWith(
                                color: AppColor.white, fontSize: 12.px),
                          )
                        ],
                      ),
                    ),
                    BlocBuilder<InvoiceBloc, InvoiceState>(
                      builder: (context, state) {
                        List<InvoiceModel> filteredInvoices = state.invoices
                            .where((invoice) =>
                                invoice.partyId == widget.partyModel.id)
                            .toList();
                        return GestureDetector(
                          onTap: () {
                            commonBottomSheet(context,
                                child: CustomerDetailDownloadWidget(
                                  list: true,
                                  type: 'customer',
                                  onClickItem: (index) {
                                    if (index == 0) {
                                      CustomerServices()
                                          .generateAndDownloadExcel(
                                              context,
                                              invoiceData: filteredInvoices,
                                              partyModel: widget.partyModel,
                                              dateRange:
                                                  selectedDateRange.value);
                                    }
                                    if (index == 1) {
                                      CustomerServices().generateAndDownloadPDF(
                                          context,
                                          partyModel: widget.partyModel,
                                          invoiceData: filteredInvoices,
                                          dateRange: selectedDateRange.value);
                                    }
                                    if (index == 2) {
                                      CustomerServices().generateAndDownloadCSV(
                                          context,
                                          invoiceData: filteredInvoices,
                                          partyModel: widget.partyModel,
                                          dateRange: selectedDateRange.value);
                                    }
                                    if (index == 4) {
                                      _onDeleteParty();
                                    }
                                    if (index == 3) {
                                      RouterHelper.push(
                                          context, AppRoutes.addParty.name,
                                          extra: {
                                            'party': widget.partyModel.toJson(),
                                          });
                                    }
                                    RouterHelper.pop<void>(context);
                                  },
                                ));
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.more_horiz_outlined,
                                color: AppColor.white,
                                size: 20.px,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'More',
                                style: AppTextStyle.pw500.copyWith(
                                    color: AppColor.white, fontSize: 12.px),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        body: Container(
          color: AppColor.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  selectButton(
                    ontap: () => invoiceTypeNotifier.value = 0,
                    selected: invoiceTypeNotifier.value == 0,
                    title: 'All',
                  ),
                  selectButton(
                    ontap: () => invoiceTypeNotifier.value = 1,
                    selected: invoiceTypeNotifier.value == 1,
                    title: 'Paid',
                  ),
                  selectButton(
                    ontap: () => invoiceTypeNotifier.value = 2,
                    selected: invoiceTypeNotifier.value == 2,
                    title: 'Unpaid',
                  )
                ],
              ),
              SizedBox(height: 1.h),
              const Divider(
                color: AppColor.greyContainer,
              ),
              SizedBox(height: 2.h),
              ValueListenableBuilder(
                valueListenable: selectedDateRange,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      calenderRangeWidget(
                        selectedRange: value,
                        onTap: () {
                          pickDateRange(context, (DateTimeRange range) {
                            selectedDateRange.value = range;
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 2.h),
              invoiceWidgets.isEmpty
                  ? const Center(child: NoDataWidget())
                  : Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return invoiceWidgets[index];
                        },
                        separatorBuilder: (context, index) {
                          return Column(
                            children: [
                              SizedBox(height: 1.h),
                              const Divider(color: AppColor.greyContainer),
                              SizedBox(height: 1.h),
                            ],
                          );
                        },
                        itemCount: invoiceWidgets.length,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectButton({
    required VoidCallback ontap,
    required bool selected,
    String? title,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 38.px,
        width: 100.px,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0XFFE9F2FF) : const Color(0XFFF0F0F0),
          borderRadius: BorderRadius.circular(30.px),
          border: Border.all(
            color: selected ? AppColor.appColor : Colors.transparent,
          ),
        ),
        child: Text(
          title ?? '',
          style: AppTextStyle.pw500.copyWith(
            color: selected ? AppColor.appColor : AppColor.darkGrey,
            fontSize: 16.px,
          ),
        ),
      ),
    );
  }

  Widget itemWidget({
    required VoidCallback onTap,
    required int invoiceNumber,
    required InvoiceStatus status,
    required double totalAmount,
    required DateTime invoiceDate,
    required InvoiceType type,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('#$invoiceNumber', style: AppTextStyle.pw500),
                  SizedBox(
                    width: 2.w,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.px),
                        color: AppColor.greyContainer),
                    child: Text(
                      status.name.toString(),
                      style: AppTextStyle.pw400
                          .copyWith(fontSize: 10.px, color: AppColor.grey),
                    ),
                  )
                ],
              ),
              Text(
                '₹ ${totalAmount.toStringAsFixed(2)}',
                style: AppTextStyle.pw600
                    .copyWith(fontSize: 14.px, color: AppColor.black),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  invoiceDate.convertToDisplay(),
                  style: AppTextStyle.pw400.copyWith(
                    fontSize: 12.px,
                    color: AppColor.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.px),
                        color: const Color(0XFFEEF5FF)),
                    child: Text(
                      type.name,
                      style: AppTextStyle.pw500
                          .copyWith(fontSize: 14.px, color: AppColor.appColor),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onDeleteParty() async {
    context.read<PartiesBloc>().add(
          OnDeleteParty(partyModel: widget.partyModel),
        );
    // RouterHelper.push(context, AppRoutes.partyView.name);
  }

  void openWhatsApp(String phone) async {
    final Uri whatsappUri = Uri.parse('https://wa.me/$phone');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $whatsappUri');
    }
  }

  void openEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Hello', // Optional
        'body': 'I want to contact you regarding...', // Optional
      }),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      debugPrint('Could not launch email app');
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      debugPrint('Could not launch call');
    }
  }
}
