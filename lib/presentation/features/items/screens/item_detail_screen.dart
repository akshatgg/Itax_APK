import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/data/apis/download/download_item_service.dart';
import '../../../../core/data/apis/models/items/item_model.dart';
import '../../../../core/utils/list_extenstion.dart';
import '../../../../core/utils/logger.dart';
import '../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../shared/utils/widget/custom_image.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';
import '../../parties/screens/widget/customer_detail_download_widget.dart';
import '../domain/item/item_bloc.dart';
import 'widgets/stock_in_out_widget.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key, required this.item});

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    final itemBloc = context.watch<ItemBloc>();
    final updatedItem =
        itemBloc.items.firstWhereOrNull((i) => i.id == item.id) ?? item;
    logger.i(updatedItem.fileMetadata);
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(220.px),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => RouterHelper.pop<void>(context),
                            child: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Item Details',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        commonBottomSheet(context,
                            child: CustomerDetailDownloadWidget(
                              list: true,
                              type: 'item',
                              onClickItem: (index) {
                                if (index == 0) {
                                  ItemServices().generateAndDownloadExcel(
                                    itemData: updatedItem,
                                  );
                                  RouterHelper.pop<void>(context);
                                }
                                if (index == 1) {
                                  ItemServices().generateAndDownloadPDF(
                                    item: updatedItem,
                                  );
                                  RouterHelper.pop<void>(context);
                                }
                                if (index == 2) {
                                  ItemServices().generateAndDownloadCSV(
                                    item: updatedItem,
                                  );
                                  RouterHelper.pop<void>(context);
                                }
                                if (index == 4) {
                                  _onDeleteItem(context, updatedItem);
                                }
                                if (index == 3) {
                                  RouterHelper.push(
                                      context, AppRoutes.addEditItem.name,
                                      extra: {
                                        'editingItem': updatedItem.toJson(),
                                      });
                                }
                              },
                            ));
                      },
                      child: const Icon(
                        Icons.more_horiz_outlined,
                        color: AppColor.white,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    if (updatedItem.fileMetadata != null)
                      CustomImageView(
                        height: 60.px,
                        width: 60.px,
                        radius: BorderRadius.circular(30.px),
                        file: File(updatedItem.fileMetadata!.filePath),
                      ),
                    SizedBox(
                      width: 3.w,
                    ),
                    SizedBox(
                      width: 3.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          updatedItem.itemName,
                          style: AppTextStyle.pw500
                              .copyWith(fontSize: 20.px, color: AppColor.white),
                        ),
                        Row(
                          children: [
                            Text(
                              '₹ ${updatedItem.price}',
                              style: AppTextStyle.pw600.copyWith(
                                  fontSize: 20.px, color: AppColor.white),
                            ),
                            Text(
                              ' (Sale Price)',
                              style: AppTextStyle.pw400.copyWith(
                                  fontSize: 12.px, color: AppColor.white),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    priceSegment(
                      title: 'Purchase Price',
                      price:
                          '₹ ${updatedItem.purchasePrice.toStringAsFixed(2)}',
                    ),
                    priceSegment(
                      title: 'Current Stock',
                      price: updatedItem.closingStock.toString(),
                    ),
                    priceSegment(
                      title: 'Stock Value',
                      price:
                          '₹ ${(updatedItem.closingStock * updatedItem.price).toStringAsFixed(2)}',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: BlocListener<ItemBloc, ItemState>(
            listener: (context, state) {
              if (state is ItemStockUpdateSuccess) {
                CustomSnackBar.showSnack(
                  context: context,
                  snackBarType: SnackBarType.success,
                  message: state.message,
                );
              }
              if (state is ItemDeleteOperationSuccess) {
                CustomSnackBar.showSnack(
                  context: context,
                  snackBarType: SnackBarType.success,
                  message: 'Item Deleted Successfully',
                );
                RouterHelper.pop<void>(context);
              }
              if (state is ItemDeleteOperationFailed) {
                CustomSnackBar.showSnack(
                  context: context,
                  snackBarType: SnackBarType.success,
                  message: 'Failed to delete item',
                );
              }
              if (state is ItemStockUpdateFailed) {
                CustomSnackBar.showSnack(
                  context: context,
                  snackBarType: SnackBarType.error,
                  message: 'Failed to add stock',
                );
              }
            },
            child: Container(
              color: AppColor.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Text(
                    'Item Details',
                    style: AppTextStyle.pw600
                        .copyWith(color: AppColor.black, fontSize: 16.px),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.px),
                        color: AppColor.greyContainer),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        detailSegmentWidget(
                          title: 'Type',
                          des: updatedItem.itemType.name
                              .toString()
                              .toUpperCase(),
                        ),
                        SizedBox(height: 2.h),
                        detailSegmentWidget(
                          title: 'Unit',
                          des: updatedItem.unit.code,
                        ),
                        SizedBox(height: 2.h),
                        detailSegmentWidget(
                          title: 'HSN/SAC Code',
                          des: updatedItem.hsnCode ?? '',
                        ),
                        SizedBox(height: 2.h),
                        detailSegmentWidget(
                          title: 'Tax Rate',
                          des: '${updatedItem.gst?.toStringAsFixed(2) ?? '0'}%',
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Description',
                          style: AppTextStyle.pw400
                              .copyWith(color: AppColor.black, fontSize: 16.px),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          updatedItem.description ?? '',
                          maxLines: 4,
                          style: AppTextStyle.pw600
                              .copyWith(color: AppColor.black, fontSize: 16.px),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onTap: () {
                            commonBottomSheet(
                              context,
                              child: BlocProvider.value(
                                value: context.read<ItemBloc>(),
                                child: StockInBottomSheet(
                                  itemModel: updatedItem,
                                  title: 'Stock Out',
                                  desc: 'Enter quantity of Sold items',
                                  hint: 'Sale Price',
                                  bName: 'Stock Out',
                                  isStockIn: false,
                                ),
                              ),
                            );
                          },
                          height: 47.px,
                          text: 'Stock Out',
                          buttonColor: AppColor.red,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: CustomElevatedButton(
                          onTap: () {
                            commonBottomSheet(
                              context,
                              child: BlocProvider.value(
                                value: context.read<ItemBloc>(),
                                child: StockInBottomSheet(
                                  title: 'Stock In',
                                  itemModel: updatedItem,
                                  desc: 'Enter quantity of Purchase items',
                                  hint: 'Purchase Price',
                                  bName: 'Stock In',
                                  isStockIn: true,
                                ),
                              ),
                            );
                          },
                          height: 47.px,
                          text: 'Stock In',
                          buttonColor: AppColor.green,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget priceSegment({String? price, String? title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: AppTextStyle.pw500
              .copyWith(fontSize: 14.px, color: AppColor.white),
        ),
        SizedBox(
          height: 1.h,
        ),
        Text(
          '$price',
          style: AppTextStyle.pw600
              .copyWith(fontSize: 14.px, color: AppColor.white),
        )
      ],
    );
  }

  Widget detailSegmentWidget({String? title, String? des}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? '',
          style: AppTextStyle.pw400
              .copyWith(color: AppColor.black, fontSize: 16.px),
        ),
        Text(
          des ?? '',
          style: AppTextStyle.pw600
              .copyWith(color: AppColor.black, fontSize: 16.px),
        )
      ],
    );
  }

  Future<void> _onDeleteItem(BuildContext context, ItemModel item) async {
    context.read<ItemBloc>().add(
          OnDeleteItem(itemModel: item),
        );
    RouterHelper.pop<void>(context);
  }
}
