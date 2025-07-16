import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/data/apis/models/items/item_model.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../router/router_helper.dart';
import '../../domain/item/item_bloc.dart';

class StockInBottomSheet extends StatefulWidget {
  final String title;
  final String desc;
  final String hint;
  final String bName;
  final ItemModel itemModel;
  final bool isStockIn;

  const StockInBottomSheet({
    super.key,
    required this.title,
    required this.itemModel,
    required this.desc,
    required this.hint,
    required this.bName,
    this.isStockIn = true,
  });

  @override
  State<StockInBottomSheet> createState() => _StockInBottomSheetState();
}

class _StockInBottomSheetState extends State<StockInBottomSheet> {
  TextEditingController pPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pPriceController.text = widget.isStockIn
        ? widget.itemModel.purchasePrice.toString()
        : widget.itemModel.price.toString();
  }

  @override
  void dispose() {
    super.dispose();
    pPriceController.dispose();
    quantityController.dispose();
    noteController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                // Subtitle
                Text(
                  widget.desc,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100.px,
                      child: TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter quantity';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
                        controller: quantityController,
                        textAlign: TextAlign.end,
                        style: AppTextStyle.pw500.copyWith(
                            fontSize: 40.px, color: AppColor.darkGrey),
                        decoration: InputDecoration(
                          hintStyle: AppTextStyle.pw500.copyWith(
                              fontSize: 40.px, color: AppColor.darkGrey),
                          hintText: '0',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 2.h,
                      width: 3.px,
                      color: AppColor.appColor,
                    ),
                    Text(
                      ' PCS',
                      style: AppTextStyle.pw500
                          .copyWith(color: AppColor.darkGrey, fontSize: 14.px),
                    )
                  ],
                ),
                CustomTextfield(
                  textInputAction: TextInputAction.next,
                  hint: widget.hint,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please enter price';
                    }
                    return null;
                  },
                  controller: pPriceController,
                  lable: widget.hint,
                ),
                SizedBox(height: 2.h),
                CustomTextfield(
                  textInputAction: TextInputAction.done,
                  hint: 'Note(Optional)',
                  controller: noteController,
                  lable: 'Note(Optional)',
                ),
                SizedBox(height: 2.h),
                CustomElevatedButton(
                  text: widget.bName,
                  onTap: () {
                    _onSaveItem(context);
                  },
                  height: 44.px,
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSaveItem(
    BuildContext context,
  ) {
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      logger.d('formState validation failed');
      return;
    }
    final itemBloc = context.read<ItemBloc>();
    final enteredQuantity =
        double.tryParse(quantityController.text.trim()) ?? 0;
    final updatedClosingStock = widget.isStockIn
        ? widget.itemModel.closingStock + enteredQuantity
        : widget.itemModel.closingStock - enteredQuantity;
    itemBloc.add(
      OnStockUpdateItem(
        itemModel: widget.itemModel.copyWith(
          closingStock: updatedClosingStock,
        ),
      ),
    );
    RouterHelper.pop<void>(context);
  }
}
