import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/constants/strings_constants.dart';
import '../../../../../core/utils/date_utility.dart';
import '../../../../../core/utils/input_validations.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../router/router_helper.dart';

class EditInvoiceHeaderBottomSheet extends StatefulHookWidget {
  const EditInvoiceHeaderBottomSheet({
    super.key,
    required this.onSave,
    required this.initialInvoiceDate,
    required this.initialInvoiceNumber,
    required this.initialDueDate,
  });

  final void Function(
    DateTime invoiceDate,
    int invoiceNumber,
    DateTime dueDate,
  ) onSave;

  final DateTime initialInvoiceDate;
  final int initialInvoiceNumber;
  final DateTime initialDueDate;

  @override
  State<EditInvoiceHeaderBottomSheet> createState() =>
      _EditInvoiceHeaderBottomSheetState();
}

class _EditInvoiceHeaderBottomSheetState
    extends State<EditInvoiceHeaderBottomSheet> {
  TextEditingController dateController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late final DateTime initInvoiceDate;
  late final int initInvoiceNumber;
  late final DateTime initDueDate;

  @override
  void initState() {
    super.initState();
    initInvoiceDate = widget.initialInvoiceDate;
    initInvoiceNumber = widget.initialInvoiceNumber;
    initDueDate = widget.initialDueDate;

    dateController.text = initInvoiceDate.convertToDisplay();
    invoiceNumberController.text = initInvoiceNumber.toString();
    dueDateController.text = initDueDate.convertToDisplay();
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    invoiceNumberController.dispose();
    dueDateController.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoiceDate = useState<DateTime>(initInvoiceDate);
    final dueDate = useState<DateTime>(initDueDate);

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
            onPressed: () => RouterHelper.pop<void>(context),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 2.h,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2.h,
              children: [
                Text(
                  AppStrings.editInvoiceDateAndNumber,
                  style: AppTextStyle.pw600.copyWith(
                    color: AppColor.appColor,
                    fontSize: 18.px,
                  ),
                ),
                CustomTextfield(
                  hint: AppStrings.hintSelectDate,
                  validator: (val) => InputValidator.hasValue<String>(val),
                  controller: dateController,
                  lable: AppStrings.labelSelectDate,
                  suffixWidget: GestureDetector(
                    onTap: () => _pickDate(dateController, invoiceDate),
                    child: const Icon(
                      Icons.calendar_month,
                      color: AppColor.grey,
                    ),
                  ),
                ),
                CustomTextfield(
                  hint: AppStrings.hintInvoiceNumber,
                  validator: (val) => InputValidator.hasValue<int>(val),
                  controller: invoiceNumberController,
                  lable: AppStrings.labelInvoiceNumber,
                  keyboardType: TextInputType.number,
                ),
                CustomTextfield(
                  hint: AppStrings.hintSelectDueDate,
                  validator: (val) => InputValidator.hasValue<String>(val),
                  controller: dueDateController,
                  lable: AppStrings.labelSelectDueDate,
                  suffixWidget: GestureDetector(
                    onTap: () => _pickDate(dueDateController, dueDate),
                    child: const Icon(
                      Icons.calendar_month,
                      color: AppColor.grey,
                    ),
                  ),
                ),
                // Save Button
                CustomElevatedButton(
                  text: AppStrings.save,
                  onTap: () => _onSave(invoiceDate, dueDate),
                  height: 44.px,
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _pickDate(
      TextEditingController controller, ValueNotifier<DateTime> date) async {
    var dateTime = date.value;
    var selectedDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(dateTime.getCenturyStartYear()),
      lastDate: DateTime(dateTime.getCenturyEndYear()),
    );
    if (selectedDate != null) {
      date.value = selectedDate;
      controller.text = selectedDate.convertToDisplay();
    }
  }

  void _onSave(
    ValueNotifier<DateTime> invoiceDate,
    ValueNotifier<DateTime> dueDate,
  ) {
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      logger.d(AppStrings.formStateValidationFailed);
      return;
    }
    var invoiceNumber = int.tryParse(invoiceNumberController.text.trim()) ?? 0;
    widget.onSave(invoiceDate.value, invoiceNumber, dueDate.value);
    RouterHelper.pop<void>(context);
  }
}
