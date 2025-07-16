import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/color_constants.dart';
import '../../../../../shared/utils/widget/custom_textfield.dart';
import 'segment_widget.dart';

class OtherChargesListWidget extends StatelessWidget {
  final ValueNotifier<List<OtherChargeModel>> otherChargesList;
  final void Function(List<OtherChargeModel>) onOtherChargesListChange;
  final void Function(OtherChargeModel) onOtherChargesRemoved;

  const OtherChargesListWidget({
    super.key,
    required this.otherChargesList,
    required this.onOtherChargesListChange,
    required this.onOtherChargesRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title and Add Button
        segmentWidget(
          title: 'Other Charges',
          onAdd: () {
            otherChargesList.value = [
              ...otherChargesList.value,
              OtherChargeModel(),
            ];
          },
        ),
        SizedBox(height: 1.h),

        // Other Charges List
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: ValueListenableBuilder<List<OtherChargeModel>>(
            valueListenable: otherChargesList,
            builder: (context, charges, child) {
              return Column(
                children: charges.asMap().entries.map((entry) {
                  return OtherChargeRow(
                    otherChargeModel: entry.value,
                    onDelete: () {
                      otherChargesList.value = List.from(otherChargesList.value)
                        ..removeAt(entry.key);
                      onOtherChargesRemoved(entry.value);
                    },
                    onOtherChargeModelChange: (otherChargeModel) {
                      onOtherChargesListChange(otherChargesList.value);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class OtherChargeModel {
  TextEditingController chargeNameController = TextEditingController();
  TextEditingController chargeAmountController = TextEditingController();
}

class OtherChargeRow extends StatelessWidget {
  final OtherChargeModel otherChargeModel;
  final VoidCallback onDelete;
  final void Function(OtherChargeModel) onOtherChargeModelChange;

  const OtherChargeRow({
    super.key,
    required this.otherChargeModel,
    required this.onDelete,
    required this.onOtherChargeModelChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: CustomTextfield(
              controller: otherChargeModel.chargeNameController,
              lable: 'Other Charge',
              hint: 'Other Charge',
              onChanged: (val) {
                otherChargeModel.chargeNameController.text = val;
                onOtherChargeModelChange(otherChargeModel);
              },
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: CustomTextfield(
              controller: otherChargeModel.chargeAmountController,
              lable: 'Amount',
              hint: 'Amount',
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please enter amount';
                }
                return null;
              },
              onChanged: (val) {
                otherChargeModel.chargeAmountController.text = val;
                onOtherChargeModelChange(otherChargeModel);
              },
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_outline, color: AppColor.red),
          ),
        ],
      ),
    );
  }
}
