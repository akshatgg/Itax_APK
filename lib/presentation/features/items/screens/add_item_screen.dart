import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/item_type.dart';
import '../../../../core/constants/enums/item_unit.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/data/apis/models/items/item_model.dart';
import '../../../../core/utils/input_validations.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/ui_helper.dart';
import '../../../../shared/utils/widget/add_info_widget.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/custom_drop_down_widget.dart';
import '../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../shared/utils/widget/custom_image.dart';
import '../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/select_image.dart';
import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../../router/router_helper.dart';
import '../domain/item/item_bloc.dart';

class AddItemScreen extends StatefulHookWidget {
  const AddItemScreen({
    super.key,
    this.editingItem,
  });

  final ItemModel? editingItem;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemHSNController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _itemSalePriceController =
      TextEditingController();
  final TextEditingController _itemPurchasePriceController =
      TextEditingController();
  final TextEditingController _itemTaxController = TextEditingController();
  List<String> itemUnits = List.empty(growable: true);
  final ValueNotifier<bool> otherOptionExpansion = ValueNotifier(false);
  ValueNotifier<File?> metadataNotifier = ValueNotifier<File?>(null);

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    itemUnits = ItemUnit.values.map((t) => '${t.name} - ${t.code}').toList();
    super.initState();
    _itemNameController.text = widget.editingItem?.itemName ?? '';
    _itemHSNController.text = widget.editingItem?.hsnCode ?? '';
    _itemSalePriceController.text = widget.editingItem?.price.toString() ?? '';
    _itemPurchasePriceController.text =
        widget.editingItem?.purchasePrice.toString() ?? '';
    _itemTaxController.text = widget.editingItem?.gst.toString() ?? '';
    final path = widget.editingItem?.fileMetadata?.filePath;
    metadataNotifier.value = path != null ? File(path) : null;
  }

  @override
  void dispose() {
    metadataNotifier.dispose();
    otherOptionExpansion.dispose();
    _itemNameController.dispose();
    _itemHSNController.dispose();
    _itemSalePriceController.dispose();
    _itemPurchasePriceController.dispose();
    _itemTaxController.dispose();
    _descriptionController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final selectItemUnitNotifier = widget.editingItem?.id == null
        ? useState<String>(itemUnits[0])
        : useState<String>(
            '${widget.editingItem?.unit.name} - ${widget.editingItem?.unit.code}');

    final selectedItemType =
        useState<ItemType>(widget.editingItem?.itemType ?? ItemType.item);

    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
            title: 'Add New Item',
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: CustomImageView(
                  imagePath: ImageConstants.importIcon,
                  fit: BoxFit.contain,
                  height: 18.px,
                  width: 18.px,
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                'Import',
                style: AppTextStyle.pw400White.copyWith(fontSize: 14.px),
              ),
              SizedBox(
                width: 5.w,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocListener<ItemBloc, ItemState>(
            listener: (context, state) {
              if (state is ItemOperationSuccess) {
                showSuccessSnackBar(context: context, message: 'Item Added Successfully');
              }

              if (state is ItemOperationFailed) {
                showErrorSnackBar(context: context, message: state.reason);
              }
            },
            child: Container(
              color: AppColor.white,
              height: size.height,
              width: size.width,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2.h,
                          children: [
                            Text(
                              'Item Details',
                              style: AppTextStyle.pw600.copyWith(
                                  color: AppColor.black, fontSize: 16.px),
                            ),
                            CustomTextfield(
                              hint: 'Item Name',
                              validator: (value) =>
                                  InputValidator.hasValue<String>(value),
                              controller: _itemNameController,
                              lable: 'Item Name',
                              obsecure: false,
                            ),
                            CustomTextfield(
                              hint: 'HSN/SAC Code(Optional)',
                              controller: _itemHSNController,
                              lable: 'HSN/SAC Code(Optional)',
                              validator: (value) =>
                                  InputValidator.hasValue<String>(value),
                            ),
                            CustomDropdown(
                              items: itemUnits,
                              selectedValue: selectItemUnitNotifier,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Item Type',
                                  style: AppTextStyle.pw600.copyWith(
                                      color: AppColor.black, fontSize: 14.px),
                                ),
                                Row(
                                  children: [
                                    Radio<ItemType>(
                                      value: ItemType.item,
                                      fillColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                              (states) {
                                            if (states.contains(WidgetState.selected)) {
                                              return Colors.blue;
                                            }
                                            return Colors.grey;
                                          }),
                                      groupValue: selectedItemType.value,
                                      onChanged: (value) {
                                        if (value != null) {
                                          selectedItemType.value = value;
                                        }
                                      },
                                    ),
                                    Text(
                                      'Item',
                                      style: AppTextStyle.pw600.copyWith(
                                          color: AppColor.black, fontSize: 14.px),
                                    ),
                                    Radio<ItemType>(
                                      fillColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                              (states) {
                                            if (states.contains(WidgetState.selected)) {
                                              return Colors.blue;
                                            }
                                            return Colors.grey;
                                          }),
                                      value: ItemType.service,
                                      groupValue: selectedItemType.value,
                                      onChanged: (value) {
                                        if (value != null) {
                                          selectedItemType.value = value;
                                        }
                                      },
                                    ),
                                    Text(
                                      'Service',
                                      style: AppTextStyle.pw600.copyWith(
                                          color: AppColor.black, fontSize: 14.px),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 1.h),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 5,
                        color: AppColor.greyContainer,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2.h,
                          children: [
                            Text(
                              'Pricing',
                              style: AppTextStyle.pw600.copyWith(
                                color: AppColor.black,
                                fontSize: 16.px,
                              ),
                            ),
                            CustomTextfield(
                              keyboardType: TextInputType.number,
                              hint: 'Sale Price',
                              validator: (value) =>
                                  InputValidator.hasValue<double>(value),
                              controller: _itemSalePriceController,
                              lable: 'Sale Price',
                              obsecure: false,
                            ),
                            CustomTextfield(
                              keyboardType: TextInputType.number,
                              hint: 'Purchase Price',
                              validator: (value) =>
                                  InputValidator.hasValue<double>(value),
                              controller: _itemPurchasePriceController,
                              lable: 'Purchase Price',
                              obsecure: false,
                            ),
                            CustomTextfield(
                              keyboardType: TextInputType.number,
                              hint: 'Tax Rate%',
                              controller: _itemTaxController,
                              lable: 'Tax Rate%',
                              obsecure: false,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 5,
                        color: AppColor.greyContainer,
                      ),
                      SizedBox(height: 1.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ValueListenableBuilder(
                            valueListenable: otherOptionExpansion,
                            builder: (context, value, child) {
                              return Column(
                                children: [
                                  AddInfoWidget(
                                    title: 'Other Info(Optional)',
                                    onTap: () {
                                      otherOptionExpansion.value =
                                          !otherOptionExpansion.value;
                                    },
                                  ),
                                  if (value)
                                    Column(
                                      children: [
                                        SizedBox(height: 2.h),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200.px,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.px),
                                              color: AppColor.greyContainer),
                                          child: GestureDetector(
                                            onTap: () async {
                                              File? selectedImage1 =
                                                  await pickImage(context);
                                              if (selectedImage1 != null) {
                                                metadataNotifier.value =
                                                    selectedImage1;
                                              }
                                            },
                                            child:
                                                ValueListenableBuilder<File?>(
                                              valueListenable: metadataNotifier,
                                              builder: (context, value, child) {
                                                if (value != null) {
                                                  return Image.file(
                                                    value,
                                                    width: 150,
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                  );
                                                } else {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.image,
                                                        color: Colors.grey,
                                                        size: 40.px,
                                                      ),
                                                      Text(
                                                        'Add Image',
                                                        style: AppTextStyle
                                                            .pw600
                                                            .copyWith(
                                                          fontSize: 16.px,
                                                          color: AppColor.black,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        CustomTextfield(
                                          controller: _descriptionController,
                                          lable: 'Description',
                                          hint: 'Description',
                                        )
                                      ],
                                    )
                                ],
                              );
                            }),
                      ),
                      SizedBox(height: 2.h),
                      const Divider(
                        thickness: 5,
                        color: AppColor.greyContainer,
                      ),
                      SizedBox(height: 2.h),
                      CustomElevatedButton(
                        text: 'Save',
                        height: 44.px,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        onTap: () => _onSaveItem(
                          context,
                          selectItemUnitNotifier.value,
                          selectedItemType.value,
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSaveItem(
    BuildContext context,
    String selectItemUnit,
    ItemType selectItemType,
  ) {
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      logger.d('formState validation failed');
      return;
    }
    final itemBloc = context.read<ItemBloc>();
    final priceText = _itemSalePriceController.text.trim();
    final price = double.tryParse(priceText) ?? 0.0;

    final purchasePriceText = _itemPurchasePriceController.text.trim();
    final purchasePrice = double.tryParse(purchasePriceText) ?? 0.0;

    final taxText = _itemTaxController.text.trim();
    final taxRate = double.tryParse(taxText) ?? 0.0;
    logger.i(metadataNotifier.value);
    if (widget.editingItem?.id != null) {
      itemBloc.add(
        OnUpdateItem(
          image: metadataNotifier.value,
          itemModel: ItemModel(
            id: widget.editingItem?.id ?? '',
            itemName: _itemNameController.text.trim(),
            hsnCode: _itemHSNController.text.trim(),
            unit: ItemUnit.values[itemUnits.indexOf(selectItemUnit)],
            itemType: selectItemType,
            price: price,
            purchasePrice: purchasePrice,
            taxExempted: taxText.isEmpty || taxRate == 0,
            gst: taxRate,
            createdAt: widget.editingItem?.createdAt ?? DateTime.now(),
            updatedAt: DateTime.now(),
            openingStock: 0,
            closingStock: widget.editingItem?.closingStock ?? 0.0,
          ),
        ),
      );
      RouterHelper.pop<void>(context);
    } else {
      itemBloc.add(
        OnAddItem(
          image: metadataNotifier.value,
          itemModel: ItemModel(
            itemName: _itemNameController.text.trim(),
            hsnCode: _itemHSNController.text.trim(),
            unit: ItemUnit.values[itemUnits.indexOf(selectItemUnit)],
            itemType: selectItemType,
            price: price,
            purchasePrice: purchasePrice,
            taxExempted: taxText.isEmpty || taxRate == 0,
            gst: taxRate,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            openingStock: 0,
            closingStock: 0,
          ),
        ),
      );
      RouterHelper.pop<void>(context);
    }
  }
}
