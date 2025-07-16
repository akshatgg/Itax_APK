import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/data/apis/models/items/item_model.dart';
import '../../../../../core/utils/get_it_instance.dart';
import '../../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../../shared/utils/widget/custom_image.dart';
import '../../../../router/router_helper.dart';
import '../../../../router/routes.dart';
import '../../domain/item/item_bloc.dart';
import 'price_segment.dart';
import 'stock_in_out_widget.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail({
    super.key,
    required this.item,
  });

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: InkWell(
        onTap: () => RouterHelper.push(
          context,
          AppRoutes.itemDetail.name,
          extra: {
            'editItem': item.toJson(),
          },
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (item.fileMetadata != null)
                      CustomImageView(
                        height: 30.px,
                        width: 30.px,
                        fit: BoxFit.cover,
                        radius: BorderRadius.circular(5.px),
                        file: File(item.fileMetadata!.filePath),
                      ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Text(
                      item.itemName,
                      style: AppTextStyle.pw600
                          .copyWith(fontSize: 16.px, color: AppColor.black),
                    )
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.green, width: 2),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        commonBottomSheet(
                          context,
                          child: BlocProvider.value(
                            value: getIt.get<ItemBloc>(),
                            child: StockInBottomSheet(
                              title: 'Stock In',
                              itemModel: item,
                              desc: 'Enter quantity of Purchase items',
                              hint: 'Purchase Price',
                              bName: 'Stock In',
                              isStockIn: true,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.add),
                          Text(
                            'In',
                            style: AppTextStyle.pw500.copyWith(
                              fontSize: 14.px,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red, width: 2),
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        commonBottomSheet(
                          context,
                          child: BlocProvider.value(
                            value: getIt.get<ItemBloc>(),
                            child: StockInBottomSheet(
                              itemModel: item,
                              title: 'Stock Out',
                              desc: 'Enter quantity of Sold items',
                              hint: 'Sale Price',
                              bName: 'Stock Out',
                              isStockIn: false,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.add),
                          Text(
                            'Out',
                            style: AppTextStyle.pw500.copyWith(
                              fontSize: 14.px,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriceSegment(
                  title: 'Sale Price',
                  price: '₹ ${item.price.toStringAsFixed(2)}',
                ),
                PriceSegment(
                  title: 'Purchase Price',
                  price: '₹ ${item.purchasePrice.toStringAsFixed(2)}',
                ),
                PriceSegment(
                  title: 'Current Stock',
                  price: item.closingStock.toStringAsFixed(0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
