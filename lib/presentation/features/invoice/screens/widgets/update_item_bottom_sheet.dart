import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/data/apis/models/invoice/invoice_item_model.dart';
import '../../../../../core/utils/input_validations.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../router/router_helper.dart';
import '../../../../ui/create_sale_invoice/widget/all_bottom_sheet_widget.dart';

class UpdateItemBottomSheet extends StatefulHookWidget {
  final InvoiceItemModel invoiceItemModel;
  final void Function(InvoiceItemModel) onUpdate;

  const UpdateItemBottomSheet({
    super.key,
    required this.invoiceItemModel,
    required this.onUpdate,
  });

  @override
  State<UpdateItemBottomSheet> createState() => _UpdateItemBottomSheetState();
}

class _UpdateItemBottomSheetState extends State<UpdateItemBottomSheet> {
  TextEditingController itemRateController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemDiscountController = TextEditingController();
  TextEditingController itemTaxController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    itemRateController.text = widget.invoiceItemModel.rate.toString();
    itemQuantityController.text = widget.invoiceItemModel.quantity.toString();
    itemDiscountController.text = widget.invoiceItemModel.discount.toString();
    itemTaxController.text = widget.invoiceItemModel.taxPercent.toString();
    itemDescriptionController.text =
        widget.invoiceItemModel.itemName.toString();
  }

  @override
  void dispose() {
    super.dispose();
    itemQuantityController.dispose();
    itemDiscountController.dispose();
    itemTaxController.dispose();
    itemDescriptionController.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = useState<bool>(false);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Container(
                    height: 27.px,
                    width: 27.px,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0XFFCCCCCC),
                    ),
                    child: const Icon(Icons.close),
                  ),
                  onPressed: () => RouterHelper.pop<void>(context),
                ),
              ),
              // Drag Handle
              Container(
                decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      const Text(
                        'Update Item',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextfield(
                              keyboardType: TextInputType.number,
                              controller: itemRateController,
                              lable: 'Rate',
                              hint: 'Rate',
                              validator: (val) =>
                                  InputValidator.hasValue<String>(
                                val,
                                errorMessage: 'Please enter item rate',
                              ),
                              onChanged: (val) {
                                isUpdate.value = true;
                              },
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: CustomTextfield(
                              keyboardType: TextInputType.number,
                              controller: itemQuantityController,
                              lable: 'Quantity',
                              hint: 'Quantity',
                              validator: (val) =>
                                  InputValidator.hasValue<String>(
                                val,
                                errorMessage: 'Please enter item Quantity',
                              ),
                              onChanged: (val) {
                                isUpdate.value = true;
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextfield(
                              controller: itemDiscountController,
                              keyboardType: TextInputType.number,
                              lable: 'Discount(Rs)',
                              hint: 'Discount(Rs)',
                              validator: (val) =>
                                  InputValidator.hasValue<String>(
                                val,
                                errorMessage: 'Please enter item discount',
                              ),
                              onChanged: (val) {
                                isUpdate.value = true;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildAmount(),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: CustomTextfield(
                              keyboardType: TextInputType.number,
                              controller: itemTaxController,
                              lable: 'Tax(%)',
                              hint: 'Tax(%)',
                              validator: (val) =>
                                  InputValidator.hasValue<String>(
                                val,
                                errorMessage: 'Please enter item tax',
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      CustomTextfield(
                        controller: itemDescriptionController,
                        keyboardType: TextInputType.text,
                        lable: 'Description',
                        hint: 'Description',
                        validator: (val) => InputValidator.hasValue<String>(
                          val,
                          errorMessage: 'Please enter item description',
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.px),
                          color: AppColor.greyContainer,
                        ),
                        child: _buildSummary(),
                      ),
                      SizedBox(height: 2.h),
                      // Save Button
                      CustomElevatedButton(
                        text: 'Update',
                        onTap: _onUpdate,
                        height: 44.px,
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmount() {
    final rate = double.tryParse(itemRateController.text.trim()) ?? 0.0;
    final quantity = int.tryParse(itemQuantityController.text.trim()) ?? 0;
    final total = rate * quantity;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 1.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.px),
        border: Border.all(
          color: AppColor.grey,
        ),
      ),
      child: Text(
        '₹ ${total.toStringAsFixed(2)}',
        style: AppTextStyle.pw500.copyWith(
          fontSize: 14.px,
          color: AppColor.grey,
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final rate = double.tryParse(itemRateController.text.trim()) ?? 0.0;
    final quantity = int.tryParse(itemQuantityController.text.trim()) ?? 0;
    final discount = double.tryParse(itemDiscountController.text.trim()) ?? 0.0;
    final tax = double.tryParse(itemTaxController.text.trim()) ?? 0.0;
    final total = rate * quantity;
    final taxAmount = total * tax / 100;
    final finalTotal = total + taxAmount - discount;
    return Column(
      children: [
        detailWidget(
          title: 'Amount',
          desc: '₹ ${rate.toStringAsFixed(2)}',
          dark: false,
        ),
        SizedBox(height: 1.h),
        detailWidget(
          title: 'Discount',
          desc: '₹ ${discount.toStringAsFixed(2)}',
          dark: false,
        ),
        SizedBox(height: 1.h),
        detailWidget(
          title: 'Tax Rate(%)',
          desc: '₹ ${taxAmount.toStringAsFixed(2)}',
          dark: false,
        ),
        SizedBox(height: 1.h),
        detailWidget(
            title: 'Amount',
            desc: '₹ ${finalTotal.toStringAsFixed(2)}',
            dark: true),
        SizedBox(height: 1.h),
      ],
    );
  }

  void _onUpdate() {
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      logger.d('formState validation failed');
      return;
    }
    final rate = double.tryParse(itemRateController.text.trim()) ?? 0.0;
    final quantity = int.tryParse(itemQuantityController.text.trim()) ?? 0;
    final discount = double.tryParse(itemDiscountController.text.trim()) ?? 0.0;
    final tax = double.tryParse(itemTaxController.text.trim()) ?? 0.0;
    final total = rate * quantity;
    final taxAmount = total * tax / 100;
    final finalTotal = total + taxAmount - discount;

    final invoiceItemModel = widget.invoiceItemModel.copyWith(
      rate: rate,
      quantity: quantity,
      discount: discount,
      taxPercent: tax,
      description: itemDescriptionController.text.trim(),
      finalAmount: finalTotal,
    );
    logger.d('invoiceItemModel: ${invoiceItemModel.toJson()}');
    widget.onUpdate(invoiceItemModel);
    RouterHelper.pop<void>(context);
  }
}
