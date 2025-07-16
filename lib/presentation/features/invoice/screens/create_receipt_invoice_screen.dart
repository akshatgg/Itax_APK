import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/invoice_type.dart';
import '../../../../core/data/apis/models/invoice/receipt_model.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
import '../../../../core/utils/date_utility.dart';
import '../../../../core/utils/get_fin_year.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../core/utils/input_validations.dart';
import '../../../../core/utils/list_extenstion.dart';
import '../../../../core/utils/logger.dart';
import '../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../shared/utils/widget/custom_floating_button.dart';
import '../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../shared/utils/widget/divider_widget.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';
import '../../parties/domain/parties/parties_bloc.dart';
import '../data/bank_details.dart';
import '../domain/invoice/invoice_bloc.dart';
import '../domain/receipt/receipt_bloc.dart';
import 'widgets/bank_detail_bottom_sheet.dart';
import 'widgets/edit_invoice_select_party_widget.dart';
import 'widgets/segment_widget.dart';

class CreateReceiptInvoice extends StatefulHookWidget {
  const CreateReceiptInvoice({
    super.key,
    required this.invoiceType,
    this.receipt,
  });

  final InvoiceType invoiceType;
  final ReceiptModel? receipt;

  @override
  State<CreateReceiptInvoice> createState() => _CreateReceiptInvoiceState();
}

class _CreateReceiptInvoiceState extends State<CreateReceiptInvoice> {
  TextEditingController amountController = TextEditingController();
  final ValueNotifier<String> selectedPaymentMode =
      ValueNotifier<String>('Payment Mode');

  final ValueNotifier<BankDetails?> bankDetails =
      ValueNotifier<BankDetails?>(null);
  TextEditingController noteController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  bool onNote = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double initTotalAmount = 0.0;
  int initPartyIndex = -1;
  Map<String, double> initInvoiceAmounts = {};

  @override
  void initState() {
    super.initState();
    var partyBloc = context.read<PartiesBloc>();
    final partyList = widget.invoiceType == InvoiceType.payment
        ? partyBloc.suppliers
        : partyBloc.customers;
    if (widget.receipt != null) {
      amountController.text = widget.receipt!.totalAmount.toString();
      noteController.text = widget.receipt!.notes;
      selectedPaymentMode.value = widget.receipt!.paymentMethod;
      bankDetails.value = BankDetails(
        bankName: widget.receipt!.bankName,
        accountNumber: widget.receipt!.accountNumber,
        ifscCode: widget.receipt!.ifscCode,
        date: widget.receipt!.selectDate != null
            ? DateTime.parse(widget.receipt!.selectDate!)
            : DateTime.now(),
      );
      upiIdController.text = widget.receipt!.upiId;
      initTotalAmount = widget.receipt!.totalAmount;
      initPartyIndex = partyList
          .indexWhere((element) => element.id == widget.receipt!.partyId);
      initInvoiceAmounts = widget.receipt!.invoiceIds;
    }
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    upiIdController.dispose();
    noteController.dispose();
    selectedPaymentMode.dispose();
    bankDetails.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var partyBloc = context.watch<PartiesBloc>();
    final partyList = widget.invoiceType == InvoiceType.payment
        ? partyBloc.suppliers
        : partyBloc.customers;
    final selectedPartyIndex = useState<int>(initPartyIndex);
    final invoiceAmounts = useState<Map<String, double>>(initInvoiceAmounts);
    final totalAmount = useState<double>(initTotalAmount);
    final invoices = context.watch<InvoiceBloc>().invoices;

    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: _getByInvoiceType(),
          child: GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 5.w),
              child: const Icon(
                Icons.more_horiz_outlined,
                color: AppColor.white,
              ),
            ),
          ),
        ),
        floatingActionButton: selectedPartyIndex.value == -1
            ? CustomFloatingButton(
                tag: 'receiptInvoice',
                title: 'Add Record',
                imagePath: '',
                onTap: () => RouterHelper.push(
                  context,
                  AppRoutes.addParty.name,
                ),
              )
            : null,
        body: SafeArea(
          child: BlocListener<ReceiptBloc, ReceiptState>(
            listener: (context, state) {
              if (state is ReceiptLoaded) {
                CustomSnackBar.showSnack(
                  context: context,
                  snackBarType: SnackBarType.success,
                  message: 'Receipt Created sucessfully',
                );
                RouterHelper.pop<void>(context);
              }
              if (state is ReceiptError) {
                CustomSnackBar.showSnack(
                  context: context,
                  snackBarType: SnackBarType.error,
                  message: 'Receipt Creation Failed',
                );
              }
            },
            child: Container(
              color: AppColor.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      const Divider(
                        color: AppColor.greyContainer,
                        thickness: 3,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EditInvoiceSelectPartyWidget(
                              selectedPartyNotifier: selectedPartyIndex,
                              partyList: partyList,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            if (selectedPartyIndex.value != -1)
                              Text(
                                'Closing Balance: ₹ ${partyList[selectedPartyIndex.value].outstandingBalance}',
                                style: AppTextStyle.pw500.copyWith(
                                    color: AppColor.darkGrey, fontSize: 11.px),
                              ),
                          ],
                        ),
                      ),
                      if (selectedPartyIndex.value != -1) ...[
                        const DividerWidget(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount',
                                style: AppTextStyle.pw500.copyWith(
                                    color: AppColor.darkGrey, fontSize: 16.px),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              CustomTextfield(
                                controller: amountController,
                                lable: 'Amount',
                                hint: 'Amount',
                                validator: (val) =>
                                    InputValidator.hasValue<double>(val),
                                onChanged: (val) {
                                  totalAmount.value =
                                      double.tryParse(val) ?? 0.0;
                                },
                              ),
                            ],
                          ),
                        ),
                        const DividerWidget(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment Mode',
                                style: AppTextStyle.pw500.copyWith(
                                    color: AppColor.darkGrey, fontSize: 16.px),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: selectedPaymentMode,
                                builder: (context, value, child) {
                                  return GestureDetector(
                                    onTap: () {
                                      selectPaymentModeBottomSheet(context,
                                          (selectedMode) {
                                        selectedPaymentMode.value =
                                            selectedMode;
                                      });
                                    },
                                    child: Container(
                                      height: 47.px,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.px),
                                        border:
                                            Border.all(color: AppColor.grey),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            value,
                                            style: AppTextStyle.pw500.copyWith(
                                              fontSize: 14.px,
                                              color: AppColor.grey,
                                            ),
                                          ),
                                          const Icon(Icons.keyboard_arrow_down),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        if (selectedPaymentMode.value == 'Bank Transfer' ||
                            selectedPaymentMode.value == 'Cheque/DD') ...[
                          const DividerWidget(),
                          ValueListenableBuilder(
                            valueListenable: bankDetails,
                            builder: (context, value, child) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Bank Details',
                                            style: AppTextStyle.pw500.copyWith(
                                              color: AppColor.darkGrey,
                                              fontSize: 16.px,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final details =
                                                await showModalBottomSheet<
                                                    BankDetails>(
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) => SafeArea(
                                                child: BankDetailBottomSheet(
                                                  bankName: bankDetails
                                                          .value?.bankName ??
                                                      '',
                                                  accountNumber: bankDetails
                                                          .value
                                                          ?.accountNumber ??
                                                      '',
                                                  ifscCode: bankDetails
                                                          .value?.ifscCode ??
                                                      '',
                                                  date: bankDetails.value?.date
                                                          .convertToDisplay() ??
                                                      '',
                                                ),
                                              ),
                                            );
                                            logger.d(details?.bankName);
                                            bankDetails.value = details ??
                                                BankDetails(
                                                  bankName: '',
                                                  accountNumber: '',
                                                  ifscCode: '',
                                                  date: DateTime.now(),
                                                );
                                          },
                                          child: Text(
                                            bankDetails.value?.bankName
                                                        .isNotEmpty ??
                                                    false
                                                ? 'Edit'
                                                : 'Add',
                                            style: AppTextStyle.pw500.copyWith(
                                              color: AppColor.appColor,
                                              fontSize: 16.px,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 3.px,
                                        ),
                                        if (bankDetails.value != null)
                                          GestureDetector(
                                            onTap: () {
                                              bankDetails.value = null;
                                            },
                                            child: const Icon(
                                              Icons.delete_outline,
                                              color: AppColor.red,
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (value != null) _buildBankDetails(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                        if (selectedPaymentMode.value == 'UPI') ...[
                          const DividerWidget(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: CustomTextfield(
                              controller: upiIdController,
                              lable: 'UPI ID',
                              hint: 'UPI ID',
                              validator: (val) =>
                                  InputValidator.hasValue<String>(val,
                                      errorMessage: 'Please add UPI ID'),
                            ),
                          ),
                        ],
                        const DividerWidget(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Unpaid Invoices',
                                style: AppTextStyle.pw500.copyWith(
                                    color: AppColor.darkGrey, fontSize: 16.px),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (selectedPartyIndex.value == -1) {
                                    return;
                                  }
                                  final result = await RouterHelper.pushData<
                                      Map<String, double>>(
                                    context,
                                    AppRoutes.unPaidInvoice.name,
                                    extra: {
                                      'party':
                                          partyList[selectedPartyIndex.value]
                                              .toJson(),
                                      'invoices':
                                          invoiceAmounts.value.keys.toList(),
                                      'selectOnlyOne': false,
                                    },
                                  );
                                  if (result != null) {
                                    invoiceAmounts.value = result;
                                    amountController.text = result.values
                                        .fold(
                                            0.0,
                                            (previousValue, element) =>
                                                previousValue + element)
                                        .toString();
                                    totalAmount.value = double.tryParse(
                                            amountController.text) ??
                                        0.0;
                                  }
                                },
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18.px,
                                ),
                              )
                            ],
                          ),
                        ),
                        if (invoiceAmounts.value.isNotEmpty) ...[
                          const DividerWidget(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Column(
                              children: [
                                for (var invoice
                                    in invoiceAmounts.value.entries)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '# ${invoices.firstWhereOrNull((element) => element.id == invoice.key)?.invoiceNumber}',
                                        style: AppTextStyle.pw500.copyWith(
                                          color: AppColor.darkGrey,
                                          fontSize: 16.px,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '₹ ${invoice.value.toStringAsFixed(2)}',
                                            style: AppTextStyle.pw500.copyWith(
                                              color: AppColor.darkGrey,
                                              fontSize: 16.px,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              invoiceAmounts.value =
                                                  invoiceAmounts.value
                                                    ..remove(invoice.key);
                                            },
                                            icon: Icon(
                                              Icons.delete_outline,
                                              size: 20.px,
                                              color: AppColor.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                        const DividerWidget(),
                        Column(
                          children: [
                            segmentWidget(
                              title: 'Notes',
                              onAdd: () {
                                setState(() {
                                  onNote = !onNote;
                                });
                              },
                            ),
                            if (onNote)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 1.h),
                                child: CustomTextfield(
                                  maxLine: 3,
                                  controller: noteController,
                                  lable: 'Note',
                                  hint: 'Note',
                                  validator: (val) {
                                    if (val!.isEmpty) {}
                                    return null;
                                  },
                                ),
                              )
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 70.px,
          color: AppColor.white,
          shadowColor: Colors.black54,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style:
                        AppTextStyle.pw500.copyWith(color: AppColor.darkGrey),
                  ),
                  Text(
                    '₹ ${totalAmount.value.toStringAsFixed(2)}',
                    style:
                        AppTextStyle.pw600.copyWith(color: AppColor.darkGrey),
                  )
                ],
              ),
              CustomElevatedButton(
                height: 44.px,
                width: 160.px,
                text: 'Create',
                onTap: () => _createReceipt(
                  selectedPaymentMode.value,
                  partyList[selectedPartyIndex.value],
                  invoiceAmounts.value,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 1.h,
        ),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
              color: AppColor.greyContainer,
              borderRadius: BorderRadius.circular(10.px)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bankDetails.value!.bankName,
                    style: AppTextStyle.pw600.copyWith(
                      color: AppColor.darkGrey,
                      fontSize: 16.px,
                    ),
                  ),
                  Text(
                    bankDetails.value!.date.convertToDisplay(),
                    style: AppTextStyle.pw600.copyWith(
                      color: AppColor.darkGrey,
                      fontSize: 16.px,
                    ),
                  )
                ],
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'A/c Number : ',
                        style: AppTextStyle.pw400
                            .copyWith(color: AppColor.grey, fontSize: 10.px)),
                    TextSpan(
                      text: bankDetails.value!.accountNumber,
                      style: AppTextStyle.pw400.copyWith(
                        color: AppColor.grey,
                        fontSize: 12.px,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'IFSC Code : ',
                          style: AppTextStyle.pw400.copyWith(
                            color: AppColor.grey,
                            fontSize: 10.px,
                          ),
                        ),
                        TextSpan(
                          text: bankDetails.value!.ifscCode,
                          style: AppTextStyle.pw400.copyWith(
                            color: AppColor.grey,
                            fontSize: 12.px,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Future<void> selectPaymentModeBottomSheet(
      BuildContext context, void Function(String) onSelect) async {
    List<String> paymentList = [
      'Cash',
      'Cheque/DD',
      'Bank Transfer',
      'UPI',
    ];
    commonBottomSheet(
      context,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.h,
            ),
            const Text(
              'Bank Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                paymentList.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      onSelect(paymentList[index]);
                      RouterHelper.pop<void>(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      child: Text(
                        paymentList[index],
                        style: AppTextStyle.pw400
                            .copyWith(color: AppColor.grey, fontSize: 16.px),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _getByInvoiceType() {
    if (widget.invoiceType == InvoiceType.receipt) {
      return 'Create Receipt';
    }
    return 'Create Payment';
  }

  void _createReceipt(
    String paymentMode,
    PartyModel party,
    Map<String, double> invoiceAmounts,
  ) {
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      logger.d('formState validation failed');
      return;
    }
    final receipt = ReceiptModel(
      id: widget.receipt != null ? widget.receipt!.id : generateId(),
      partyId: party.id,
      partyName: party.partyName,
      type: widget.invoiceType,
      notes: noteController.text,
      paymentMethod: paymentMode,
      bankName: bankDetails.value?.bankName ?? '',
      accountNumber: bankDetails.value?.accountNumber ?? '',
      ifscCode: bankDetails.value?.ifscCode ?? '',
      checkNumber: bankDetails.value?.checkNumber ?? '',
      invoiceDate: DateTime.now(),
      invoiceIds: invoiceAmounts,
      receiptNumber: 1,
      totalAmount: double.parse(amountController.text),
      selectDate: bankDetails.value?.date.convertToStore(),
      upiId: upiIdController.text,
      finYear: getFinYearFromDate(DateTime.now()),
    );
    logger.d(receipt);
    if (widget.receipt != null) {
      context.read<ReceiptBloc>().add(UpdateReceipt(receipt: receipt));
    } else {
      context.read<ReceiptBloc>().add(CreateReceipt(receipt: receipt));
    }
  }
}
