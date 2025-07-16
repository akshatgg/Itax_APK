import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/invoice_status.dart';
import '../../../../core/constants/enums/invoice_type.dart';
import '../../../../core/data/apis/models/invoice/invoice_item_model.dart';
import '../../../../core/data/apis/models/invoice/invoice_model.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
import '../../../../core/utils/get_fin_year.dart';
import '../../../../core/utils/logger.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../shared/utils/widget/custom_floating_button.dart';
import '../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../shared/utils/widget/divider_widget.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';
import '../../company/domain/company_bloc.dart';
import '../../items/domain/item/item_bloc.dart';
import '../../parties/domain/parties/parties_bloc.dart';
import '../../pdf/template/pdf_templete_3.dart';
import '../domain/invoice/invoice_bloc.dart';
import 'widgets/edit_invoice_select_party_widget.dart';
import 'widgets/gst_widget/gst_list_widget.dart';
import 'widgets/invoice_header.dart';
import 'widgets/item_widget.dart';
import 'widgets/other_charge.dart';
import 'widgets/save_invoice_bottom_sheet.dart';
import 'widgets/segment_widget.dart';
import 'widgets/update_item_bottom_sheet.dart';

class CreateSaleInvoice extends StatefulHookWidget {
  const CreateSaleInvoice({
    super.key,
    required this.invoiceType,
    this.invoice,
  });

  final InvoiceType invoiceType;
  final InvoiceModel? invoice;

  @override
  State<CreateSaleInvoice> createState() => _CreateSaleInvoiceState();
}

class _CreateSaleInvoiceState extends State<CreateSaleInvoice> {
  ValueNotifier<bool> onNote = ValueNotifier<bool>(false);
  ValueNotifier<List<InvoiceItemModel>> selectedItems = ValueNotifier([]);

  TextEditingController noteController = TextEditingController();
  final gstData = ValueNotifier<Map<String, double>>({});

  final List<GstModel> initialGstList = [];
  final List<OtherChargeModel> initialOtherChargesList = [];

  @override
  void initState() {
    super.initState();
    if (widget.invoice != null) {
      selectedItems.value = widget.invoice!.invoiceItems;
      noteController.text = widget.invoice!.notes;
      gstData.value = widget.invoice!.gstPercentage;
      for (var gst in gstData.value.keys) {
        initialGstList.add(GstModel(
          gstAmount: widget.invoice!.gstPercentage[gst]!,
          gstType: gst,
        ));
      }
      for (var otherCharge in widget.invoice!.otherCharges.keys) {
        final otherChargeModel = OtherChargeModel();
        otherChargeModel.chargeNameController.text = otherCharge;
        otherChargeModel.chargeAmountController.text =
            widget.invoice!.otherCharges[otherCharge]!.toStringAsFixed(2);
        initialOtherChargesList.add(otherChargeModel);
      }
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

  void addItemsToCart(List<InvoiceItemModel> items) {
    selectedItems.value = List.from(selectedItems.value)..addAll(items);
  }

  void removeItemFromCart(int index) {
    selectedItems.value = List.from(selectedItems.value)..removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    final invoiceBloc = context.watch<InvoiceBloc>();
    var partyBloc = context.watch<PartiesBloc>();
    final items = context.watch<ItemBloc>().items;
    final company = context.watch<CompanyBloc>().currentCompany;

    final partyList = widget.invoiceType == InvoiceType.purchase
        ? partyBloc.suppliers
        : partyBloc.customers;
    final selectedPartyIndex = useState<int>(widget.invoice != null
        ? partyList.indexOf(partyList
            .firstWhere((element) => element.id == widget.invoice!.partyId))
        : -1);
    final gstList = useState<List<GstModel>>(initialGstList);
    final otherChargesList = useState<List<OtherChargeModel>>(
        widget.invoice != null ? initialOtherChargesList : []);
    final totalAmount = useState<double>(
        widget.invoice != null ? widget.invoice!.totalAmount : 0.0);
    final itemTotalAmount = useState<double>(widget.invoice != null
        ? widget.invoice!.invoiceItems
            .map((e) => e.finalAmount)
            .fold(0.0, (sum, add) => sum + add)
        : 0.0);
    final gstAmount = useState<double>(widget.invoice != null
        ? widget.invoice!.gstPercentage.values
            .fold(0.0, (sum, add) => sum + add)
        : 0.0);
    final otherChargesAmount = useState<double>(widget.invoice != null
        ? widget.invoice!.otherCharges.values.fold(0.0, (sum, add) => sum + add)
        : 0.0);

    final invoiceDateNotifier = useState<DateTime>(
        widget.invoice != null ? widget.invoice!.invoiceDate : DateTime.now());
    final invoiceNoNotifier = useState<int>(widget.invoice != null
        ? widget.invoice!.invoiceNumber
        : invoiceBloc.lastInvoiceNumber + 1);
    final dueDateNotifier = useState<DateTime>(widget.invoice != null
        ? widget.invoice!.dueDate!
        : DateTime.now().add(const Duration(days: 45)));

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
          child: BlocListener<InvoiceBloc, InvoiceState>(
            listener: (context, state) {
              if (state is InvoiceLoaded) {
                CustomSnackBar.showSnack(
                  context: context,
                  snackBarType: SnackBarType.success,
                  message: 'Invoice Created Successfully',
                );
                showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => SafeArea(
                    child: SaveInvoiceBottomSheet(
                      onSave: () {
                        RouterHelper.pop<void>(context);
                        RouterHelper.pop<void>(context);
                      },
                      onExport: () {
                        RouterHelper.pop<void>(context);
                        generateInvoice2(
                          state.invoices.last,
                          items,
                          partyList[selectedPartyIndex.value],
                          company!,
                        );
                      },
                    ),
                  ),
                );
              }
              if (state is InvoiceError) {
                CustomSnackBar.showSnack(
                  context: context,
                  snackBarType: SnackBarType.error,
                  message: 'Invoice Creation Failed ${state.errorMessage}',
                );
                RouterHelper.pop<void>(context);
              }
            },
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
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
                                itemTotalAmount.value = selectedItems.value
                                    .map((t) => t.rate * t.quantity)
                                    .fold(0.0, (sum, add) => sum + add);

                                totalAmount.value = itemTotalAmount.value +
                                    gstAmount.value +
                                    otherChargesAmount.value;
                              },
                              removeItemFromCart: (index) {
                                final current = selectedItems.value;
                                current.removeAt(index);
                                selectedItems.value = current;

                                itemTotalAmount.value = selectedItems.value
                                    .map((t) => t.rate * t.quantity)
                                    .fold(0.0, (sum, add) => sum + add);

                                totalAmount.value = itemTotalAmount.value +
                                    gstAmount.value +
                                    otherChargesAmount.value;
                              },
                              updateItemBottomSheet: (index) {
                                showModalBottomSheet<UpdateItemBottomSheet>(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) =>
                                      DraggableScrollableSheet(
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
                                            itemTotalAmount.value =
                                                selectedItems
                                                    .value
                                                    .map((t) => t.finalAmount)
                                                    .fold(
                                                        0.0,
                                                        (sum, add) =>
                                                            sum + add);

                                            totalAmount.value =
                                                itemTotalAmount.value +
                                                    gstAmount.value +
                                                    otherChargesAmount.value;
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
                              totalAmount: itemTotalAmount.value,
                              onGstListChange: (newGstList) {
                                gstAmount.value = newGstList
                                    .map((e) => e.gstAmount)
                                    .fold(0.0, (sum, add) => sum + add);
                                logger.d('gstAmount: $gstAmount');
                                totalAmount.value = itemTotalAmount.value +
                                    gstAmount.value +
                                    otherChargesAmount.value;
                              },
                              onGstRemoved: (gstModel) {
                                gstAmount.value =
                                    gstAmount.value - gstModel.gstAmount;

                                totalAmount.value = itemTotalAmount.value +
                                    gstAmount.value +
                                    otherChargesAmount.value;
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
                                    gstAmount.value +
                                    otherChargesAmount.value;
                              },
                              onOtherChargesRemoved: (otherChargeModel) {
                                otherChargesAmount.value =
                                    otherChargesAmount.value -
                                        double.parse(otherChargeModel
                                            .chargeAmountController.text);

                                totalAmount.value = itemTotalAmount.value +
                                    gstAmount.value +
                                    otherChargesAmount.value;
                              },
                            ),
                            const DividerWidget(),
                            segmentWidget(
                              title: 'Notes',
                              onAdd: () {
                                onNote.value = !onNote.value;
                              },
                            ),
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
                text: widget.invoice != null ? 'Update' : 'Create',
                onTap: () => _createInvoice(
                  invoiceNoNotifier.value,
                  invoiceDateNotifier.value,
                  dueDateNotifier.value,
                  partyList[selectedPartyIndex.value],
                  selectedItems.value,
                  gstData.value,
                  otherChargesList.value,
                  totalAmount.value,
                  noteController.text,
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
    if (widget.invoiceType == InvoiceType.purchase) {
      return 'Create Purchase Invoice';
    }
    return 'Create Sales Invoice';
  }

  void _createInvoice(
    int invoiceNumber,
    DateTime invoiceDate,
    DateTime dueDate,
    PartyModel party,
    List<InvoiceItemModel> invoiceItems,
    Map<String, double> gstPercentage,
    List<OtherChargeModel> otherCharges,
    double totalAmount,
    String notes,
  ) {
    final invoiceBloc = context.read<InvoiceBloc>();
    final Map<String, double> otherChargesMap = {};
    for (var charge in otherCharges) {
      otherChargesMap[charge.chargeNameController.text.trim()] =
          double.tryParse(charge.chargeAmountController.text.trim()) ?? 0.0;
    }
    var invoiceModel = InvoiceModel(
      invoiceNumber: invoiceNumber,
      invoiceDate: invoiceDate,
      type: widget.invoiceType,
      status: InvoiceStatus.unpaid,
      partyId: party.id,
      partyName: party.partyName,
      invoiceItems: invoiceItems,
      gstPercentage: gstPercentage,
      otherCharges: otherChargesMap,
      dueDate: dueDate,
      notes: notes,
      totalAmount: totalAmount,
      finYear: getFinYearFromDate(invoiceDate),
    );
    logger.d('creating invoiceModel: ${invoiceModel.toJson()}');
    if (widget.invoice != null) {
      invoiceModel = invoiceModel.copyWith(
        id: widget.invoice!.id,
        invoiceNumber: widget.invoice!.invoiceNumber,
        invoiceDate: widget.invoice!.invoiceDate,
        dueDate: widget.invoice!.dueDate,
      );
      invoiceBloc.add(
        UpdateInvoice(invoiceModel),
      );
    } else {
      invoiceBloc.add(
        CreateInvoice(invoiceModel),
      );
    }
  }
}
