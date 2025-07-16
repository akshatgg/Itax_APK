import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/constants/strings_constants.dart';
import '../../../../../core/utils/date_utility.dart';
import '../../../../../core/utils/input_validations.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../router/router_helper.dart';
import '../../data/bank_details.dart';

class BankDetailBottomSheet extends StatefulWidget {
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String date;

  const BankDetailBottomSheet({
    super.key,
    this.ifscCode = '',
    this.accountNumber = '',
    this.bankName = '',
    this.date = '',
  });

  @override
  State<BankDetailBottomSheet> createState() => _BankDetailBottomSheetState();
}

class _BankDetailBottomSheetState extends State<BankDetailBottomSheet> {
  TextEditingController checkController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late final DateTime initInvoiceDate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dateController.text = widget.date;
    bankController.text = widget.bankName;
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    bankController.dispose();
    descriptionController.dispose();
    checkController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: Container(
                  height: 27.px,
                  width: 27.px,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0XFFCCCCCC)),
                  child: const Icon(Icons.close)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  const Text(
                    AppStrings.bankDetails,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  CustomTextfield(
                    controller: checkController,
                    lable: AppStrings.labelChequeNumber,
                    hint: AppStrings.hintChequeNumber,
                    validator: (val) => InputValidator.hasValue<String>(val,
                        errorMessage: AppStrings.pleaseAddChequeNumber),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextfield(
                    controller: dateController,
                    lable: AppStrings.labelSelectDate,
                    hint: AppStrings.hintSelectDate,
                    validator: (val) => InputValidator.hasValue<String>(val,
                        errorMessage: AppStrings.pleaseAddDate),
                    suffixWidget: GestureDetector(
                      onTap: () => _pickDate(dateController),
                      child: const Icon(Icons.calendar_month),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextfield(
                    controller: bankController,
                    lable: AppStrings.labelSelectBank,
                    hint: AppStrings.hintSelectBank,
                    validator: (val) => InputValidator.hasValue<String>(val,
                        errorMessage: AppStrings.pleaseAddBankName),
                    suffixWidget: GestureDetector(
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextfield(
                    controller: descriptionController,
                    lable: AppStrings.labelDescription,
                    hint: AppStrings.hintDescription,
                    validator: (val) => InputValidator.hasValue<String>(val,
                        errorMessage: AppStrings.pleaseAddDescription),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomElevatedButton(
                    onTap: () {
                      if (_formKey.currentState != null &&
                          !_formKey.currentState!.validate()) {
                        logger.d('formState validation failed');
                        return;
                      }
                      final bankDetails = BankDetails(
                        checkNumber: checkController.text,
                        bankName: bankController.text,
                        accountNumber: widget.accountNumber,
                        ifscCode: widget.ifscCode,
                        date: DateTime.parse(dateController.text),
                      );
                      RouterHelper.pop(context, data: bankDetails);
                    },
                    height: 45.px,
                    text: AppStrings.save,
                    buttonColor: AppColor.appColor,
                    textColor: AppColor.white,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _pickDate(TextEditingController controller) async {
    var dateTime = DateTime.now();
    var selectedDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(dateTime.getCenturyStartYear()),
      lastDate: DateTime(dateTime.getCenturyEndYear()),
    );
    if (selectedDate != null) {
      controller.text = selectedDate.convertToStore();
    }
  }
}
