// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../../constants/app_text_style.dart';
// import '../../../../constants/color_constants.dart';
// import '../../../../data/models/party_model.dart';
// import '../../../../router/router_helper.dart';
// import '../../../../utils/input_validations.dart';
// import '../../../../utils/logger.dart';
// import '../../../../widget/custom_elevated_button.dart';
// import '../../../../widget/custom_textfield.dart';
// import '../../data/business_details.dart';
//
// class BusinessDetailSheet extends StatefulWidget {
//   final PartyModel? partyModel;
//   final void Function(BusinessDetails businessDetails) onSave;
//
//   const BusinessDetailSheet({
//     super.key,
//     required this.onSave,
//     this.partyModel,
//   });
//
//   @override
//   State<BusinessDetailSheet> createState() => _BusinessDetailSheetState();
// }
//
// class _BusinessDetailSheetState extends State<BusinessDetailSheet> {
//   final TextEditingController _gstInController = TextEditingController();
//   final TextEditingController _panController = TextEditingController();
//   final TextEditingController _statusController = TextEditingController();
//   final TextEditingController _businessNameController = TextEditingController();
//   final TextEditingController _tanController = TextEditingController();
//   final TextEditingController _tradeNameController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     super.initState();
//     logger.d(widget.partyModel?.businessName);
//     _panController.text = widget.partyModel?.pan ?? '';
//     _businessNameController.text = widget.partyModel?.businessName ?? '';
//     _statusController.text = widget.partyModel?.status ?? '';
//     _gstInController.text = widget.partyModel?.gstin ?? '';
//     _tradeNameController.text = widget.partyModel?.tradeName ?? '';
//     _tanController.text = widget.partyModel?.tan ?? '';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Wrap(
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: IconButton(
//               icon: Container(
//                   height: 27.px,
//                   width: 27.px,
//                   decoration: const BoxDecoration(
//                       shape: BoxShape.circle, color: Color(0XFFCCCCCC)),
//                   child: const Icon(Icons.close)),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                   color: AppColor.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 5.w),
//                 child: Form(
//                   key: _formKey,
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).viewInsets.bottom),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 2.h),
//                         Center(
//                           child: Container(
//                             width: 40.px,
//                             height: 4.px,
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade400,
//                               borderRadius: BorderRadius.circular(2),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 3.h),
//                         // Title
//                         Text(
//                           'Business Info',
//                           style: AppTextStyle.pw700
//                               .copyWith(color: AppColor.black, fontSize: 18.px),
//                         ),
//                         SizedBox(height: 2.h),
//                         // GSTIN & Fetch Details Row
//                         Row(
//                           children: [
//                             Expanded(
//                               child: CustomTextfield(
//                                 hint: 'Enter GSTIN',
//                                 validator: (val) {
//                                   return null;
//                                 },
//                                 controller: _gstInController,
//                                 lable: 'Enter GSTIN',
//                               ),
//                             ),
//                             SizedBox(width: 3.w),
//                             ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0XFFE5EFFF),
//                                   foregroundColor: Colors.blue,
//                                   side: const BorderSide(
//                                       color: AppColor.appColor),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(15.px))),
//                               child: const Text('Fetch Details'),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 2.h),
//                         CustomTextfield(
//                           controller: _panController,
//                           hint: 'PAN',
//                           lable: 'PAN',
//                           validator: (value) =>
//                               InputValidator.hasValue<String>(value),
//                         ),
//                         SizedBox(height: 2.h),
//                         CustomTextfield(
//                           controller: _statusController,
//                           hint: 'Status',
//                           lable: 'Status',
//                         ),
//                         SizedBox(height: 2.h),
//                         CustomTextfield(
//                           controller: _businessNameController,
//                           hint: 'Business Name',
//                           lable: 'Business Name',
//                           validator: (value) =>
//                               InputValidator.hasValue<String>(value),
//                         ),
//                         SizedBox(height: 2.h),
//                         CustomTextfield(
//                           controller: _tradeNameController,
//                           hint: 'Trade Name',
//                           lable: 'Trade Name',
//                         ),
//                         SizedBox(height: 2.h),
//                         CustomTextfield(
//                           hint: 'TAN',
//                           lable: 'TAN',
//                           controller: _tanController,
//                         ),
//                         SizedBox(height: 2.h),
//                         // Save Button
//                         CustomElevatedButton(
//                           text: 'Save',
//                           height: 44.px,
//                           buttonColor: AppColor.appColor,
//                           textColor: AppColor.white,
//                           onTap: _onSave,
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _onSave() {
//     logger.d('onSave');
//     if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
//       logger.d('formState validation failed');
//       return;
//     }
//     logger.d('formState validation passed');
//     widget.onSave(
//       BusinessDetails(
//         gst: _gstInController.text.trim(),
//         pan: _panController.text.trim(),
//         status: _statusController.text.trim(),
//         businessName: _businessNameController.text.trim(),
//         tan: _tanController.text.trim(),
//         tradeName: _tradeNameController.text.trim(),
//       ),
//     );
//     RouterHelper.pop<void>(context);
//   }
// }
