import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../core/constants/app_text_style.dart';
import '../../../../../../core/constants/color_constants.dart';
import '../../../../../../core/constants/strings_constants.dart';
import '../../../../../../core/utils/logger.dart';
import '../../../../../../shared/utils/widget/custom_drop_down_widget.dart';
import 'gst_list_widget.dart';

class GstRow extends StatefulHookWidget {
  final GstModel gstModel;
  final VoidCallback onDelete;
  final double totalAmount;
  final void Function(GstModel)? onGstChange;

  const GstRow({
    super.key,
    required this.gstModel,
    required this.onDelete,
    required this.totalAmount,
    this.onGstChange,
  });

  @override
  State<GstRow> createState() => _GstRowState();
}

class _GstRowState extends State<GstRow> {
  final amountNotifier = ValueNotifier<double>(0.0);
  final gstType = ValueNotifier<String>('');
  List<String> gstList = ['IGST', 'CGST', '18%', '2.5%', '1%'];

  @override
  void initState() {
    super.initState();
    gstType.addListener(_onGstChange);
  }

  @override
  void dispose() {
    gstType.removeListener(_onGstChange);
    amountNotifier.dispose();
    gstType.dispose();
    super.dispose();
  }

  void _onGstChange() {
    final index = gstList.indexOf(gstType.value);
    if (index == 0 || index == 1) {
      amountNotifier.value = widget.totalAmount * 0.09;
    } else if (index == 2) {
      amountNotifier.value = widget.totalAmount * 0.18;
    } else if (index == 3) {
      amountNotifier.value = widget.totalAmount * 0.025;
    } else if (index == 4) {
      amountNotifier.value = widget.totalAmount * 0.01;
    }
    logger.d('onGstChange: ${amountNotifier.value}');
    final updatedGstModel = widget.gstModel;
    updatedGstModel.gstAmount = amountNotifier.value;
    widget.onGstChange?.call(updatedGstModel);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: CustomDropdown(
              items: gstList,
              selectedValue: gstType,
              validator: (val) {
                if (val!.isEmpty) {
                  return AppStrings.pleaseSelectGst;
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Container(
              height: 44.px,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.px),
                  border: Border.all(color: AppColor.grey)),
              child: Row(
                children: [
                  Text(
                    amountNotifier.value.toStringAsFixed(2),
                    style: AppTextStyle.pw500.copyWith(
                      fontSize: 14.px,
                      color: AppColor.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 2.w),
          IconButton(
            onPressed: widget.onDelete,
            icon: const Icon(
              Icons.delete_outline,
              color: AppColor.red,
            ),
          ),
        ],
      ),
    );
  }
}
