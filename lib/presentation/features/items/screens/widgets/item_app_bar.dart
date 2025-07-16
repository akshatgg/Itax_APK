import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/data/apis/download/item_list_download_service.dart';
import '../../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../router/router_helper.dart';
import '../../../../router/routes.dart';
import '../../../parties/screens/widget/customer_detail_download_widget.dart';
import '../../domain/item/item_bloc.dart';

class ItemAppBar extends StatelessWidget {
  const ItemAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context)
                                .go(AppRoutes.dashboardView.path);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColor.white,
                            size: 25.px,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Items',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // CustomImageView(
                      //   fit: BoxFit.cover,
                      //   imagePath: 'assets/images/barcode.png',
                      //   height: 25.px,
                      //   width: 25.px,
                      // ),
                      // SizedBox(width: 2.w),
                      GestureDetector(
                        onTap: () {
                          commonBottomSheet(context,
                              child: CustomerDetailDownloadWidget(
                                list: false,
                                type: 'customer',
                                onClickItem: (index) {
                                  if (index == 0) {
                                    ItemListDownloadService()
                                        .generateAndDownloadExcel(
                                            item: state.items);
                                  }
                                  if (index == 1) {
                                    ItemListDownloadService()
                                        .generateAndDownloadPDF(
                                            item: state.items);
                                  }
                                  if (index == 2) {}

                                  RouterHelper.pop<void>(context);
                                },
                              ));
                        },
                        child: const Icon(
                          Icons.more_horiz_outlined,
                          color: AppColor.white,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 3.h),
          ],
        );
      },
    );
  }
}
