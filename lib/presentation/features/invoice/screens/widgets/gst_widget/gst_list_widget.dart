import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../core/constants/strings_constants.dart';
import '../../../../../../core/utils/logger.dart';
import '../segment_widget.dart';
import 'gst_row_widget.dart';

class GSTListWidget extends StatelessWidget {
  final ValueNotifier<List<GstModel>> gstList;
  final double totalAmount;
  final void Function(List<GstModel>)? onGstListChange;
  final void Function(GstModel)? onGstRemoved;

  const GSTListWidget({
    super.key,
    required this.gstList,
    required this.totalAmount,
    this.onGstListChange,
    this.onGstRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        segmentWidget(
          title: AppStrings.gst,
          onAdd: () {
            gstList.value = [...gstList.value, GstModel()];
          },
        ),
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: ValueListenableBuilder<List<GstModel>>(
            valueListenable: gstList,
            builder: (context, gstItems, child) {
              return Column(
                children: gstItems
                    .map(
                      (entry) => GstRow(
                        gstModel: entry,
                        totalAmount: totalAmount,
                        onDelete: () {
                          final list = List<GstModel>.from(gstList.value);
                          list.remove(entry);
                          gstList.value = list;
                          onGstRemoved?.call(entry);
                          logger.d('onGstRemoved: ${entry.gstAmount}');
                        },
                        onGstChange: (gstModel) {
                          final index = gstList.value.indexOf(entry);
                          final list = List<GstModel>.from(gstList.value);
                          list.removeAt(index);
                          list.add(gstModel);
                          gstList.value = list;
                          logger.d('onGstChange: ${gstModel.gstAmount}');
                          onGstListChange?.call(gstList.value);
                        },
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GstModel {
  TextEditingController gstTypeController = TextEditingController();
  double gstAmount;

  GstModel({String gstType = '', this.gstAmount = 0}) {
    gstTypeController.text = gstType;
  }
}
