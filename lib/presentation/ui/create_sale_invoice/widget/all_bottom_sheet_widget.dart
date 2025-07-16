import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/data/indian_states.dart';
import '../../../../core/utils/get_it_instance.dart';
import '../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../shared/utils/widget/custom_drop_down_widget.dart';
import '../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../shared/utils/widget/custom_image.dart';
import '../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../shared/utils/widget/dropdowns/search_dropdown.dart';
import '../../../../shared/utils/widget/search_field.dart';
import '../../../router/router_helper.dart';

void editAddressBottomSheet(
    BuildContext context,
    TextEditingController businessAddressController,
    TextEditingController pinCodeController,
    ValueNotifier<String> stateNotifier) {
  commonBottomSheet(context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
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
                const Text(
                  'Edit Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                CustomTextfield(
                  hint: 'Address',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                  controller: businessAddressController,
                  lable: 'Address',
                ),
                SizedBox(height: 2.h),
                AutoCompleteInput(
                  showAvatar: false,
                  showPrefix: false,
                  direction: OptionsViewOpenDirection.up,
                  items: getIt
                      .get<IndianStatesData>()
                      .state
                      .map((st) => st.name)
                      .toList(),
                  label: 'State',
                  hint: 'State',
                  fillColor: Colors.transparent,
                  initialValue: '',
                  onSelected: (p0) {
                    if (p0.isNotEmpty) {
                      stateNotifier.value = p0;
                    }
                  },
                ),
                SizedBox(height: 2.h),
                CustomTextfield(
                  hint: 'Pin code',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please enter pin code';
                    }
                    return null;
                  },
                  controller: pinCodeController,
                  lable: 'Pin code',
                ),

                SizedBox(height: 2.h),
                // Save Button
                CustomElevatedButton(
                  text: 'Save',
                  onTap: () {},
                  height: 44.px,
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          )
        ],
      ));
}

void addItemToInvoiceBottomSheet(BuildContext context) {
  commonBottomSheet(context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
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
                const Text(
                  'Add Items to Invoice',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Column(
                    children: List.generate(5, (index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                        color: AppColor.greyContainer,
                        borderRadius: BorderRadius.circular(10.px)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstants.itemBoxIcon,
                            ),
                            Text(
                              'Nick Football',
                              style: AppTextStyle.pw600.copyWith(
                                  fontSize: 16.px, color: AppColor.darkGrey),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sale Price',
                                  style: AppTextStyle.pw400.copyWith(
                                      fontSize: 12.px, color: AppColor.grey),
                                ),
                                Text(
                                  'Sale Price',
                                  style: AppTextStyle.pw500.copyWith(
                                      fontSize: 14.px,
                                      color: AppColor.darkGrey),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Stock',
                                  style: AppTextStyle.pw400.copyWith(
                                      fontSize: 12.px, color: AppColor.grey),
                                ),
                                Text(
                                  '500',
                                  style: AppTextStyle.pw500.copyWith(
                                      fontSize: 14.px, color: AppColor.green),
                                )
                              ],
                            ),
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: AppColor.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.px)),
                                    side: const BorderSide(
                                        color: AppColor.appColor)),
                                onPressed: () {},
                                child: const Text('ADD'))
                          ],
                        )
                      ],
                    ),
                  );
                })),

                SizedBox(height: 2.h),
                // Save Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '0 Item  |  0 Qty',
                          style:
                              AppTextStyle.pw500.copyWith(color: AppColor.grey),
                        ),
                        Text(
                          '₹ 0.00',
                          style: AppTextStyle.pw600
                              .copyWith(color: AppColor.darkGrey),
                        )
                      ],
                    ),
                    CustomElevatedButton(
                      text: 'Add',
                      width: 200.px,
                      onTap: () {},
                      height: 44.px,
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          )
        ],
      ));
}

void updateItemBottomSheet(BuildContext context) {
  TextEditingController itemRateController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  TextEditingController itemDiscountController = TextEditingController();
  TextEditingController itemTaxController = TextEditingController();
  TextEditingController itemAmountController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  ValueNotifier<String> cityNotifier = ValueNotifier<String>('');

  commonBottomSheet(context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  const Text(
                    'Update Item',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: CustomTextfield(
                            controller: itemRateController,
                            lable: 'Rate',
                            hint: 'Rate',
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter item rate';
                              }
                              return null;
                            }),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.35,
                          child: CustomTextfield(
                              controller: itemQuantityController,
                              lable: 'Quantity',
                              hint: 'Quantity',
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please enter item Quantity';
                                }
                                return null;
                              }),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: CustomTextfield(
                            controller: itemAmountController,
                            lable: 'Discount(Rs)',
                            hint: 'Discount(Rs)',
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter item discount';
                              }
                              return null;
                            }),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.35,
                          child: CustomDropdown(
                              items: ['item1', 'item2'],
                              selectedValue: cityNotifier),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: CustomTextfield(
                            controller: itemDiscountController,
                            lable: 'Amount',
                            hint: 'Amount',
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter item amount';
                              }
                              return null;
                            }),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Expanded(
                        child: SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.35,
                          child: CustomTextfield(
                              controller: itemTaxController,
                              lable: 'Tax(%)',
                              hint: 'Tax(%)',
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please enter item tax';
                                }
                                return null;
                              }),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.h),
                  CustomTextfield(
                      controller: itemDescriptionController,
                      lable: 'Description',
                      hint: 'Description',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter item description';
                        }
                        return null;
                      }),
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.px),
                        color: AppColor.greyContainer),
                    child: Column(
                      children: [
                        detailWidget(
                            title: 'Amount', desc: '₹ 5,000', dark: false),
                        SizedBox(
                          height: 1.h,
                        ),
                        detailWidget(
                            title: 'Discount', desc: '₹ 0', dark: false),
                        SizedBox(
                          height: 1.h,
                        ),
                        detailWidget(
                            title: 'Tax Rate(%)', desc: '₹ 0', dark: false),
                        SizedBox(
                          height: 1.h,
                        ),
                        detailWidget(
                            title: 'Amount', desc: '₹ 5,000', dark: true),
                        SizedBox(
                          height: 1.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Save Button
                  CustomElevatedButton(
                    text: 'Add',
                    onTap: () {},
                    height: 44.px,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          )
        ],
      ));
}

Widget detailWidget(
    {required String title, required String desc, required bool dark}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: dark
            ? AppTextStyle.pw600
                .copyWith(color: AppColor.darkGrey, fontSize: 14.px)
            : AppTextStyle.pw400.copyWith(color: AppColor.grey),
      ),
      Text(
        desc,
        textAlign: TextAlign.end,
        style: dark
            ? AppTextStyle.pw600
                .copyWith(color: AppColor.darkGrey, fontSize: 14.px)
            : AppTextStyle.pw400
                .copyWith(color: AppColor.grey, fontSize: 14.px),
      )
    ],
  );
}

void selectGstBottomSheet(
    BuildContext context, void Function(int index) onSelectType) {
  TextEditingController searchController = TextEditingController();
  List<String> gstList = ['IGST', 'CGST', 'GST 18%', 'GST 2.5%', 'GST 1%'];
  commonBottomSheet(context,
      child: Container(
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
            const Text(
              'Select GST & Taxes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
            InvoiceSearchTextfield(
                controller: searchController, hint: 'Search Gst'),
            SizedBox(height: 2.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(gstList.length, (index) {
                return GestureDetector(
                  onTap: () {
                    onSelectType(index);
                    RouterHelper.pop<void>(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    child: Text(
                      gstList[index],
                      style: AppTextStyle.pw400
                          .copyWith(color: AppColor.grey, fontSize: 16.px),
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
      ));
}
