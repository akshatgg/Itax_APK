import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/constants/enums/invoice_type.dart';
import '../../../../../core/constants/image_constants.dart';
import '../../../../../core/constants/strings_constants.dart';
import '../../../../../core/data/apis/models/invoice/invoice_item_model.dart';
import '../../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../../shared/utils/widget/custom_image.dart';
import '../../../items/domain/item/item_bloc.dart';

class AddItemInvoiceBottomSheet extends StatefulWidget {
  final void Function(List<InvoiceItemModel>) onItemAdded;
  final InvoiceType type;

  const AddItemInvoiceBottomSheet(
      {super.key, required this.onItemAdded, required this.type});

  @override
  State<AddItemInvoiceBottomSheet> createState() =>
      _AddItemInvoiceBottomSheetState();
}

class _AddItemInvoiceBottomSheetState extends State<AddItemInvoiceBottomSheet> {
  ValueNotifier<List<InvoiceItemModel>> selectedItems = ValueNotifier([]);
  Set<String> selectedItemIds = {}; // Track selected item IDs

  /// Calculate total quantity
  int get totalQuantity =>
      selectedItems.value.fold(0, (sum, item) => sum + item.quantity);

  /// Calculate total price
  double get totalPrice => selectedItems.value
      .fold(0, (sum, item) => sum + (item.quantity * item.rate));

  void toggleItemSelection(String itemId, InvoiceItemModel item) {
    setState(() {
      int existingIndex =
          selectedItems.value.indexWhere((element) => element.itemId == itemId);

      if (existingIndex != -1) {
        // If item already exists, update its quantity
        selectedItems.value = List.from(selectedItems.value)
          ..[existingIndex] = selectedItems.value[existingIndex].copyWith(
            quantity:
                selectedItems.value[existingIndex].quantity + item.quantity,
          );
      } else {
        // Otherwise, add the new item
        selectedItemIds.add(itemId);
        selectedItems.value = List.from(selectedItems.value)..add(item);
      }
    });
  }

  @override
  void dispose() {
    selectedItems.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 2.h),

              // Title
              const Text(
                AppStrings.addItemsToInvoice,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 2.h),

              // Scrollable Content
              BlocBuilder<ItemBloc, ItemState>(
                builder: (context, state) {
                  final items = state.items;

                  return SizedBox(
                    height: 60.h, // Fixed height to allow scrolling
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(items.length, (index) {
                          String itemId = items[index].id;
                          bool isSelected = selectedItemIds.contains(itemId);

                          return Container(
                            margin: EdgeInsets.only(bottom: 1.h),
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppColor.greyContainer,
                              borderRadius: BorderRadius.circular(10.px),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstants.itemBoxIcon,
                                    ),
                                    Text(
                                      items[index].itemName,
                                      style: AppTextStyle.pw600.copyWith(
                                        fontSize: 16.px,
                                        color: AppColor.darkGrey,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.type == InvoiceType.sales
                                              ? AppStrings.salePrice
                                              : AppStrings.purchase,
                                          style: AppTextStyle.pw400.copyWith(
                                            fontSize: 12.px,
                                            color: AppColor.grey,
                                          ),
                                        ),
                                        Text(
                                          widget.type == InvoiceType.sales
                                              ? '₹ ${items[index].price}'
                                              : '₹ ${items[index].purchasePrice}',
                                          style: AppTextStyle.pw500.copyWith(
                                            fontSize: 14.px,
                                            color: AppColor.darkGrey,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppStrings.currentStock,
                                          style: AppTextStyle.pw400.copyWith(
                                            fontSize: 12.px,
                                            color: AppColor.grey,
                                          ),
                                        ),
                                        Text(
                                          '${items[index].closingStock}',
                                          style: AppTextStyle.pw500.copyWith(
                                            fontSize: 14.px,
                                            color: AppColor.green,
                                          ),
                                        )
                                      ],
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: isSelected
                                            ? AppColor.appColor
                                            : AppColor.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.px),
                                        ),
                                        side: BorderSide(
                                          color: isSelected
                                              ? AppColor.appColor
                                              : AppColor.appColor,
                                        ),
                                      ),
                                      onPressed: () {
                                        toggleItemSelection(
                                          itemId,
                                          InvoiceItemModel(
                                            id: items[index].id,
                                            itemName: items[index].itemName,
                                            itemId: itemId,
                                            rate: widget.type ==
                                                    InvoiceType.sales
                                                ? items[index].price
                                                : items[index].purchasePrice,
                                            quantity: 1,
                                            placeOfSupply: '',
                                            taxPercent: 0,
                                            discount: 0,
                                            description: '',
                                            finalAmount: 0,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        isSelected
                                            ? AppStrings.added
                                            : AppStrings.addLarge,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColor.appColor,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 2.h),

              // Footer with Total & Add Button
              ValueListenableBuilder<List<InvoiceItemModel>>(
                valueListenable: selectedItems,
                builder: (context, items, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${items.length} Item  |  ${items.fold(0, (sum, item) => sum + item.quantity)} Qty',
                            style: AppTextStyle.pw500
                                .copyWith(color: AppColor.grey),
                          ),
                          Text(
                            '₹ ${items.fold(0.0, (double sum, item) => sum + (item.quantity * item.rate))}',
                            style: AppTextStyle.pw600
                                .copyWith(color: AppColor.darkGrey),
                          ),
                        ],
                      ),
                      CustomElevatedButton(
                        text: AppStrings.addSmall,
                        width: 200.px,
                        onTap: () {
                          Navigator.pop(context, selectedItems.value);
                        },
                        height: 44.px,
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ],
    );
  }
}
