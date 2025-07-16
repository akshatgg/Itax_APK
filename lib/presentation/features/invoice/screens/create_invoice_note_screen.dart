import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/invoice_type.dart';
import '../../../../core/data/apis/models/invoice/invoice_item_model.dart';
import '../../../../core/data/apis/models/invoice/notes_model.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
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
import '../domain/invoice/invoice_bloc.dart';
import '../domain/notes/notes_bloc.dart';
import 'widgets/edit_invoice_select_party_widget.dart';
import 'widgets/gst_widget/gst_list_widget.dart';
import 'widgets/invoice_header.dart';
import 'widgets/item_widget.dart';
import 'widgets/other_charge.dart';
import 'widgets/segment_widget.dart';
import 'widgets/update_item_bottom_sheet.dart';

class CreateNoteInvoice extends StatefulHookWidget {
  final InvoiceType invoiceType;
  final NotesModel? note;

  const CreateNoteInvoice({super.key, required this.invoiceType, this.note});

  @override
  State<CreateNoteInvoice> createState() => _CreateNoteInvoiceState();
}

class _CreateNoteInvoiceState extends State<CreateNoteInvoice> {
  ValueNotifier<bool> onNote = ValueNotifier<bool>(false);

  TextEditingController noteController = TextEditingController();
  final gstData = ValueNotifier<Map<String, double>>({});

  double initTotalAmount = 0.0;
  int initPartyIndex = -1;

  final List<GstModel> initialGstList = [];
  final List<OtherChargeModel> initialOtherChargesList = [];

  @override
  void initState() {
    super.initState();
    var partyBloc = context.read<PartiesBloc>();
    final partyList = widget.invoiceType == InvoiceType.debitNote
        ? partyBloc.suppliers
        : partyBloc.customers;
    if (widget.note != null) {
      noteController.text = widget.note!.notes;
      selectedItems.value = widget.note!.invoiceItems;
      gstData.value = widget.note!.gstPercentage;
      for (var gst in gstData.value.keys) {
        initialGstList.add(GstModel(
          gstAmount: widget.note!.gstPercentage[gst]!,
          gstType: gst,
        ));
      }
      for (var otherCharge in widget.note!.otherCharges.keys) {
        final otherChargeModel = OtherChargeModel();
        otherChargeModel.chargeNameController.text = otherCharge;
        otherChargeModel.chargeAmountController.text =
            widget.note!.otherCharges[otherCharge]!.toStringAsFixed(2);
        initialOtherChargesList.add(otherChargeModel);
      }
      selectedItems.value = widget.note!.invoiceItems;
      initTotalAmount = widget.note!.totalAmount;
      initPartyIndex =
          partyList.indexWhere((element) => element.id == widget.note!.partyId);
    }
  }

  @override
  void dispose() {
    gstData.dispose();
    noteController.dispose();
    selectedItems.dispose();
    onNote.dispose();
    super.dispose();
  }

  ValueNotifier<List<InvoiceItemModel>> selectedItems = ValueNotifier([]);

  void addItemsToCart(List<InvoiceItemModel> items) {
    selectedItems.value = List.from(selectedItems.value)..addAll(items);
  }

  void removeItemFromCart(int index) {
    selectedItems.value = List.from(selectedItems.value)..removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    var partyBloc = context.watch<PartiesBloc>();
    final partyList = widget.invoiceType == InvoiceType.debitNote
        ? partyBloc.suppliers
        : partyBloc.customers;

    final selectedPartyIndex = useState<int>(initPartyIndex);
    final totalAmount = useState<double>(initTotalAmount);
    final itemTotalAmount = useState<double>(widget.note != null
        ? selectedItems.value
            .map((t) => t.rate * t.quantity)
            .fold(0.0, (sum, add) => sum + add)
        : 0.0);
    final totalGstAmount = useState<double>(widget.note != null
        ? initialGstList
            .map((e) => e.gstAmount)
            .fold(0.0, (sum, add) => sum + add)
        : 0.0);
    final notesBloc = context.watch<NotesBloc>();

    final ValueNotifier<List<GstModel>> gstList =
        ValueNotifier<List<GstModel>>(initialGstList);
    final ValueNotifier<List<OtherChargeModel>> otherChargesList =
        ValueNotifier<List<OtherChargeModel>>(initialOtherChargesList);

    final invoiceDateNotifier = useState<DateTime>(
        widget.note != null ? widget.note!.invoiceDate : DateTime.now());
    final invoiceNoNotifier = useState<int>(widget.note != null
        ? widget.note!.invoiceNumber
        : notesBloc.lastNoteNumber + 1);
    final dueDateNotifier = useState<DateTime>(widget.note != null
        ? widget.note!.dueDate!
        : DateTime.now().add(const Duration(days: 45)));

    final otherChargesAmount = useState<double>(widget.note != null
        ? otherChargesList.value
            .map((e) => double.parse(e.chargeAmountController.text))
            .fold(0.0, (sum, add) => sum + add)
        : 0.0);

    final selectedInvoiceId = useState<String>(
        widget.note != null ? widget.note!.selectedInvoiceId : '');
    final returnReason =
        useState<String>(widget.note != null ? widget.note!.returnReason : '');
    final invoiceBloc = context.watch<InvoiceBloc>();
    final invoices = invoiceBloc.idWiseInvoices;

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
                tag: 'saleInvoice',
                title: 'Add Record',
                imagePath: '',
                onTap: () => RouterHelper.push(
                  context,
                  AppRoutes.addParty.name,
                ),
              )
            : null,
        body: SafeArea(
          child: BlocListener<NotesBloc, NotesState>(
            listener: (context, state) {
              if (state is NotesLoaded) {
                CustomSnackBar.showSnack(
                  context: context,
                  snackBarType: SnackBarType.success,
                  message: 'Note Created sucessfully',
                );
                RouterHelper.pop<void>(context);
              }
              if (state is NotesError) {
                CustomSnackBar.showSnack(
                  context: context,
                  snackBarType: SnackBarType.error,
                  message: 'Note Creation Failed',
                );
              }
            },
            child: Container(
              color: AppColor.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 1.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: InvoiceHeader(
                        invoiceDateNotifier: invoiceDateNotifier,
                        invoiceNoNotifier: invoiceNoNotifier,
                        dueDateNotifier: dueDateNotifier,
                      ),
                    ),
                    const Divider(
                      color: AppColor.greyContainer,
                      thickness: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: EditInvoiceSelectPartyWidget(
                        selectedPartyNotifier: selectedPartyIndex,
                        partyList: partyList,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: GestureDetector(
                        onTap: () {
                          selectReturnReasonBottomSheet(context,
                              (selectedMode) {
                            returnReason.value = selectedMode;
                          });
                        },
                        child: Container(
                          height: 47.px,
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.px),
                            border: Border.all(color: AppColor.grey),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                returnReason.value.isEmpty
                                    ? 'Return Reason'
                                    : returnReason.value,
                                style: AppTextStyle.pw500.copyWith(
                                  fontSize: 14.px,
                                  color: AppColor.grey,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                    selectedInvoiceId.value.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: TextButton(
                              onPressed: () async {
                                final result =
                                    await RouterHelper.pushData<String>(
                                  context,
                                  AppRoutes.unPaidInvoice.name,
                                  extra: {
                                    'party': partyList[selectedPartyIndex.value]
                                        .toJson(),
                                    'invoices': [selectedInvoiceId.value],
                                    'selectOnlyOne': true,
                                  },
                                );
                                if (result != null) {
                                  selectedInvoiceId.value = result;
                                  final invoice =
                                      invoices[selectedInvoiceId.value];
                                  if (invoice != null) {
                                    totalAmount.value = invoice.totalAmount;
                                    selectedItems.value = invoice.invoiceItems;
                                    gstData.value = invoice.gstPercentage;
                                    for (var element
                                        in invoice.otherCharges.entries) {
                                      final otherCharge = OtherChargeModel();
                                      otherCharge.chargeNameController.text =
                                          element.key;
                                      otherCharge.chargeAmountController.text =
                                          element.value.toString();
                                      otherChargesList.value.add(otherCharge);
                                    }
                                  }
                                }
                              },
                              child: Text(
                                'Select Invoice',
                                style: AppTextStyle.pw500.copyWith(
                                  color: AppColor.appColor,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Invoice # ${invoices[selectedInvoiceId.value]?.invoiceNumber ?? ''}',
                                  style: AppTextStyle.pw500.copyWith(
                                    color: AppColor.grey,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    selectedInvoiceId.value = '';
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                    const Divider(
                      color: AppColor.greyContainer,
                      thickness: 3,
                    ),
                    if (selectedPartyIndex.value != -1)
                      Column(
                        children: [
                          InvoiceSegmentWidget(
                            invoiceType: widget.invoiceType,
                            selectedItems: selectedItems,
                            addItemsToCart: (newItems) {
                              final List<InvoiceItemModel> updatedItems =
                                  List.empty(growable: true);
                              for (var item in newItems) {
                                var total = (item.rate * item.quantity);
                                final updatedItem = item.copyWith(
                                  finalAmount: total +
                                      (total * item.taxPercent / 100) -
                                      item.discount,
                                );
                                updatedItems.add(updatedItem);
                              }
                              selectedItems.value = [
                                ...selectedItems.value,
                                ...updatedItems
                              ];
                              totalAmount.value = selectedItems.value
                                  .map((t) => t.rate * t.quantity)
                                  .fold(0.0, (sum, add) => sum + add);
                            },
                            removeItemFromCart: (index) {
                              final current = selectedItems.value;
                              current.removeAt(index);
                              selectedItems.value = current;

                              totalAmount.value = selectedItems.value
                                  .map((t) => t.rate * t.quantity)
                                  .fold(0.0, (sum, add) => sum + add);
                            },
                            updateItemBottomSheet: (index) {
                              showModalBottomSheet<UpdateItemBottomSheet>(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => DraggableScrollableSheet(
                                  expand: true,
                                  initialChildSize: 0.7,
                                  maxChildSize: 0.9,
                                  builder: (
                                    BuildContext context,
                                    ScrollController scrollController,
                                  ) {
                                    return SafeArea(
                                      child: UpdateItemBottomSheet(
                                        invoiceItemModel:
                                            selectedItems.value[index],
                                        onUpdate: (updatedItem) {
                                          selectedItems.value[index] =
                                              updatedItem;
                                          totalAmount.value = selectedItems
                                              .value
                                              .map((t) => t.rate * t.quantity)
                                              .fold(
                                                  0.0, (sum, add) => sum + add);
                                          logger.d(
                                              'updatedItem: ${updatedItem.toJson()}');
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          const DividerWidget(),
                          GSTListWidget(
                            gstList: gstList,
                            totalAmount: totalAmount.value,
                            onGstListChange: (newGstList) {
                              totalGstAmount.value =
                                  newGstList.map((e) => e.gstAmount).fold(
                                        0.0,
                                        (sum, add) => sum + add,
                                      );
                              totalAmount.value =
                                  totalAmount.value + totalGstAmount.value;
                            },
                            onGstRemoved: (gstModel) {
                              logger.d('onGstRemoved: ${gstModel.gstAmount}');
                              totalGstAmount.value =
                                  totalGstAmount.value - gstModel.gstAmount;
                              totalAmount.value =
                                  totalAmount.value - gstModel.gstAmount;
                            },
                          ),
                          const DividerWidget(),
                          OtherChargesListWidget(
                            otherChargesList: otherChargesList,
                            onOtherChargesListChange: (newOtherChargesList) {
                              otherChargesList.value = newOtherChargesList;
                              otherChargesAmount.value = newOtherChargesList
                                  .map((e) => double.parse(
                                      e.chargeAmountController.text))
                                  .fold(0.0, (sum, add) => sum + add);

                              totalAmount.value = itemTotalAmount.value +
                                  totalGstAmount.value +
                                  otherChargesAmount.value;
                            },
                            onOtherChargesRemoved: (otherChargeModel) {
                              otherChargesAmount.value =
                                  otherChargesAmount.value -
                                      double.parse(otherChargeModel
                                          .chargeAmountController.text);

                              totalAmount.value = itemTotalAmount.value +
                                  totalGstAmount.value +
                                  otherChargesAmount.value;
                            },
                          ),
                          const DividerWidget(),
                          segmentWidget(
                              title: 'Notes',
                              onAdd: () {
                                onNote.value = !onNote.value;
                              }),
                          if (onNote.value)
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
                            ),
                          SizedBox(
                            height: 8.h,
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 80.px,
          color: AppColor.white,
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
                onTap: () => _createNote(
                  invoiceNoNotifier.value,
                  invoiceDateNotifier.value,
                  dueDateNotifier.value,
                  partyList[selectedPartyIndex.value],
                  selectedItems.value,
                  gstData.value,
                  otherChargesList.value,
                  totalAmount.value,
                  noteController.text,
                  returnReason.value,
                  selectedInvoiceId.value,
                ),
                rightIcon: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColor.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getByInvoiceType() {
    if (widget.invoiceType == InvoiceType.creditNote) {
      return 'Create Credit Note';
    }
    return 'Create Debit Invoice';
  }

  Future<void> selectReturnReasonBottomSheet(
      BuildContext context, void Function(String) onSelect) async {
    List<String> returnReasonList = widget.invoiceType == InvoiceType.creditNote
        ? [
            'Sales Return',
            'Overbilling',
            'Short Supply',
            'Quality Issues',
            'Discounts and Rebates',
            'Promotional Adjustments',
            'Other',
          ]
        : [
            'Purchase Return',
            'Overbilling',
            'Short Supply',
            'Quality Issues',
            'Discounts and Rebates',
            'Excess Tax Charged',
            'Service Issues',
            'Other',
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
              'Return Reason',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                returnReasonList.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      onSelect(returnReasonList[index]);
                      RouterHelper.pop<void>(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      child: Text(
                        returnReasonList[index],
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

  void _createNote(
    int invoiceNo,
    DateTime invoiceDate,
    DateTime dueDate,
    PartyModel party,
    List<InvoiceItemModel> items,
    Map<String, double> gstData,
    List<OtherChargeModel> otherCharges,
    double totalAmount,
    String note,
    String returnReason,
    String selectedInvoiceId,
  ) {
    final notesBloc = context.read<NotesBloc>();
    final Map<String, double> otherChargesMap = {};
    for (var charge in otherCharges) {
      otherChargesMap[charge.chargeNameController.text.trim()] =
          double.tryParse(charge.chargeAmountController.text.trim()) ?? 0.0;
    }

    final noteModel = NotesModel(
      id: widget.note?.id ?? '',
      invoiceNumber: invoiceNo,
      invoiceDate: invoiceDate,
      type: widget.invoiceType,
      partyId: party.id,
      partyName: party.partyName,
      invoiceItems: items,
      gstPercentage: gstData,
      otherCharges: otherChargesMap,
      dueDate: dueDate,
      notes: note,
      totalAmount: totalAmount,
      returnReason: returnReason,
      selectedInvoiceId: selectedInvoiceId,
    );
    if (widget.note != null) {
      notesBloc.add(UpdateNote(note: noteModel));
    } else {
      notesBloc.add(CreateNote(note: noteModel));
    }
  }
}
