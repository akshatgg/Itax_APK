import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/constants/enums/invoice_type.dart';
import '../../../../../core/data/apis/models/invoice/invoice_item_model.dart';
import '../../../../../core/utils/get_it_instance.dart';
import '../../../../../core/utils/logger.dart';
import '../../../items/domain/item/item_bloc.dart';
import 'add_item_invoice_bottom_sheet.dart';
import 'segment_widget.dart';

class InvoiceSegmentWidget extends StatelessWidget {
  final ValueNotifier<List<InvoiceItemModel>> selectedItems;
  final void Function(List<InvoiceItemModel>) addItemsToCart;
  final void Function(int) removeItemFromCart;
  final void Function(int) updateItemBottomSheet;
  final InvoiceType invoiceType;

  const InvoiceSegmentWidget({
    super.key,
    required this.selectedItems,
    required this.addItemsToCart,
    required this.removeItemFromCart,
    required this.updateItemBottomSheet,
    required this.invoiceType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        segmentWidget(
          title: 'Items',
          onAdd: () async {
            showModalBottomSheet<List<InvoiceItemModel>>(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder: (context) => SafeArea(
                child: BlocProvider.value(
                  value: getIt.get<ItemBloc>(),
                  child: AddItemInvoiceBottomSheet(
                    type: invoiceType,
                    onItemAdded: addItemsToCart,
                  ),
                ),
              ),
            ).then((selectedItems) {
              if (selectedItems != null && selectedItems.isNotEmpty) {
                logger.d(selectedItems);
                addItemsToCart(selectedItems); // Correctly adding items
              }
            });
          },
        ),
        ValueListenableBuilder<List<InvoiceItemModel>>(
          valueListenable: selectedItems,
          builder: (context, items, _) {
            if (items.isNotEmpty) {
              return SizedBox(
                // height: 30.h,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(height: 1.h),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          padding: EdgeInsets.all(3.w),
                          decoration: const BoxDecoration(
                            color: AppColor.greyContainer,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    items[index].itemName.toString(),
                                    style: AppTextStyle.pw600
                                        .copyWith(color: AppColor.darkGrey),
                                  ),
                                  Text(
                                    '₹ ${items[index].finalAmount}',
                                    style: AppTextStyle.pw600
                                        .copyWith(color: AppColor.darkGrey),
                                  )
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${items[index].quantity} x ₹ ${items[index].rate}',
                                      style: AppTextStyle.pw500
                                          .copyWith(color: AppColor.grey),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => updateItemBottomSheet(index),
                                    child: Text(
                                      'Edit',
                                      style: AppTextStyle.pw500.copyWith(
                                          color: AppColor.appColor,
                                          fontSize: 14.px),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  GestureDetector(
                                    onTap: () => removeItemFromCart(index),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: AppColor.red,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
