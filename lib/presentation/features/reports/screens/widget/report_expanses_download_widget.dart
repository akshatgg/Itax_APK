import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';

class ReportDetailDownloadWidget extends StatelessWidget {
  final bool list;
  final String type;
  final void Function(int) onClickItem;

  const ReportDetailDownloadWidget(
      {super.key,
        required this.onClickItem,
        required this.type,
        required this.list});

  @override
  Widget build(BuildContext context) {
    List<DetailData> detailList = [
      DetailData(title: 'Import Expenses', icon: Icons.import_export),
      DetailData(title: 'Import Report(JPG, JPEG, PNG)', icon: Icons.camera_alt),
      DetailData(title: 'Download (Excel)', icon: Icons.file_present),
      DetailData(title: 'Download (PDF)', icon: Icons.picture_as_pdf),
      DetailData(title: 'Download (CSV)', icon: Icons.file_copy_outlined),
      if (list)
        DetailData(
            title: type == 'customer'
                ? 'Edit Customer Details'
                : 'Edit Item Details',
            icon: Icons.edit),
      if (list)
        DetailData(
            title: type == 'customer' ? 'Delete Customer' : 'Delete Item',
            icon: Icons.delete)
    ];

    return Container(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(detailList.length, (index) {
              return GestureDetector(
                onTap: () => onClickItem(index),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  child: Row(
                    children: [
                      Icon(
                        detailList[index].icon,
                        color: detailList[index].title.contains('Delete')
                            ? AppColor.red
                            : AppColor.grey,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Text(
                        detailList[index].title,
                        style: AppTextStyle.pw400.copyWith(
                            color: detailList[index].title.contains('Delete')
                                ? AppColor.red
                                : AppColor.grey,
                            fontSize: 16.px),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }
}

class DetailData {
  final String title;
  final IconData icon;

  DetailData({required this.title, required this.icon});
}
