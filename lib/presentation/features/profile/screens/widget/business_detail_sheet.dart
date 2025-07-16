import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../../../../core/config/api/api_task.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/data/repos/services/gst_validation_service.dart';
import '../../../../../core/utils/input_formatter.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../../shared/utils/widget/custom_textfield.dart';

class BusinessDetailSheet extends StatefulWidget {
  final String gstValue;
  final String panValue;
  final BusinessModel? business;
  final void Function(
    BusinessModel business,
  ) onSave;

  const BusinessDetailSheet(
      {super.key,
      required this.business,
      required this.gstValue,
      required this.panValue,
      required this.onSave});

  @override
  State<BusinessDetailSheet> createState() => _BusinessDetailSheetState();
}

class _BusinessDetailSheetState extends State<BusinessDetailSheet> {
  TextEditingController gstController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController tradeNameController = TextEditingController();
  TextEditingController tanController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController businessAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    logger.d(widget.business?.bName);
    gstController.text = widget.gstValue.toString();
    panController.text = widget.panValue.toString();
    statusController.text = widget.business?.bStatus ?? '';
    businessNameController.text = widget.business?.bName ?? '';
    businessAddressController.text = widget.business?.bAddress ?? '';
    tradeNameController.text = widget.business?.tradeName ?? '';
    tanController.text = widget.business?.tan ?? '';
    stateController.text = widget.business?.bState ?? '';
    logger.d(widget.business?.bAddress);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      'Business Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      spacing: 3.w,
                      children: [
                        Expanded(
                          child: CustomTextfield(
                            inputFormatters: [
                              UpperCaseTextFormatter(),
                            ],
                            textCapitalization: TextCapitalization.characters,
                            controller: gstController,
                            lable: 'GST Number',
                            hint: 'GST Number',
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) async {
                              if (value.isNotEmpty) {
                                GSTValidationService? gstValidationService;
                                logger.d(value);
                                var gstResponse = await gstValidationService!
                                    .validateGSTNumber('');
                                if (gstResponse.status == ApiStatus.success) {
                                  final gstResponseData = gstResponse.data;
                                  if (gstResponseData == null ||
                                      gstResponseData.flag == false) {
                                    logger.d('Invalid GST Number');
                                  } else {
                                    logger.d(gstResponseData);
                                  }
                                }

                                //       OnValidateGSTNumber(
                                //         gstin: value,
                              }
                            },
                          ),
                        ),
                        CustomElevatedButton(
                          buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.lightAppColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.px)),
                              side: const BorderSide(color: AppColor.appColor)),
                          width: 150.px,
                          height: 48.px,
                          textColor: AppColor.appColor,
                          text: 'Fetch Detail',
                          onTap: () async {
                            if (gstController.text.isNotEmpty) {
                              /* final GSTValidationService gstValidationService =
                                GSTValidationService(); */

                              const String clientId =
                                  'key_live_8vxVXIzH9aXX3k3mUM0gY7FwU5EzrMIf';
                              const String clientSecret =
                                  'secret_live_OM4NXPZJoyIIbMyuS98JfCW3Ur9dtZ3N';

                              final url = Uri.parse(
                                  'https://api.cashfree.com/verification/gstin');

                              final response = await http.post(
                                url,
                                headers: {
                                  'Content-Type': 'application/json',
                                  'x-client-id': clientId,
                                  'x-client-secret': clientSecret,
                                },
                                body: jsonEncode({
                                  'gstin': '24BRXPG8224M1Z5',
                                }),
                              );

                              if (response.statusCode == 200) {
                                final data = jsonDecode(response.body);
                                logger.d(data);
                              } else {
                                logger.d(
                                    '❌ Failed to verify GST: ${response.statusCode}');
                                logger.d(response.body);
                              }

                              // var gstResponse = await gstValidationService
                              //     .validateGSTNumber('24BRXPG8224M1Z5');
                              // if (gstResponse.status == ApiStatus.success) {
                              //   final gstResponseData = gstResponse.data;
                              //   if (gstResponseData == null ||
                              //       gstResponseData.flag == false) {
                              //     CustomSnackBar.showSnack(
                              //         context: context,
                              //         snackBarType: SnackBarType.error,
                              //         message: 'Invalid Gst Number');
                              //   } else {
                              //     logger.d(gstResponseData);
                              //     final data = gstResponse.data?.data;
                              //
                              //     if (data != null) {
                              //       final status = data.sts;
                              //       final businessName = data.lgnm;
                              //       final tradeName = data.tradeNam;
                              //       final typeOfBusiness = data.ctb;
                              //       final state = data.pradr?.addr?.stcd;
                              //       final addressParts = data.pradr?.addr;
                              //
                              //       final businessAddress =
                              //           '${addressParts?.bnm ?? ''}, ${addressParts?.st ?? ''}, ${addressParts?.loc ?? ''}, ${addressParts?.dst ?? ''}, ${state ?? ''} - ${addressParts?.pncd ?? ''}';
                              //
                              //       // Optional: If there's a TAN somewhere (not in current JSON), you'd extract it here.
                              //
                              //       print('Status: $status');
                              //       print('Business Name: $businessName');
                              //       print('Trade Name: $tradeName');
                              //       print('Business Type: $typeOfBusiness');
                              //       print('State: $state');
                              //       print('Business Address: $businessAddress');
                              //       String? gst = data.gstin;
                              //       String pan = gst?.substring(2, 12) ?? '';
                              //       panController.text = pan;
                              //       statusController.text = status ?? '';
                              //       businessNameController.text = businessName ?? '';
                              //       tradeNameController.text = tradeName ?? '';
                              //       stateController.text = state ?? '';
                              //       businessAddressController.text =
                              //           businessAddress ?? '';
                              //     }
                              //   }
                              // }
                              // CustomSnackBar.showSnack(
                              //     context: context,
                              //     snackBarType: SnackBarType.error,
                              //     message: 'Enter Gst Number');
                            }
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomTextfield(
                        controller: panController, lable: 'PAN', hint: 'PAN'),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomTextfield(
                        controller: statusController,
                        lable: 'Status',
                        hint: 'Status'),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomTextfield(
                        controller: businessNameController,
                        lable: 'Business Name',
                        hint: 'Business Name'),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomTextfield(
                        controller: tradeNameController,
                        lable: 'Trade Name',
                        hint: 'Trade Name'),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomTextfield(
                        controller: tanController, lable: 'TAN', hint: 'TAN'),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomTextfield(
                        controller: stateController,
                        lable: 'State',
                        hint: 'State'),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomTextfield(
                        controller: businessAddressController,
                        lable: 'Business Address',
                        hint: 'Business Address'),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomElevatedButton(
                      text: 'Save',
                      onTap: () async {
                        widget.onSave(BusinessModel(
                            gst: gstController.text,
                            pan: panController.text,
                            bStatus: statusController.text,
                            bAddress: businessAddressController.text,
                            bName: businessNameController.text,
                            tan: tanController.text,
                            tradeName: tradeNameController.text,
                            bState: stateController.text));
                        // RouterHelper.pop<void>(context);
                      },
                      height: 44.px,
                    ),
                    SizedBox(
                      height: 2.h,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BusinessModel {
  final String gst;
  final String pan;
  final String bStatus;
  final String bAddress;
  final String bName;
  final String tan;
  final String tradeName;
  final String bState;

  BusinessModel({
    required this.gst,
    required this.pan,
    required this.bStatus,
    required this.bAddress,
    required this.bName,
    required this.tan,
    required this.tradeName,
    required this.bState,
  });

  /// Converts the object into a Map (useful for JSON and structured logging)
  Map<String, dynamic> toJson() {
    return {
      'gst': gst,
      'pan': pan,
      'bStatus': bStatus,
      'bAddress': bAddress,
      'bName': bName,
      'tan': tan,
      'tradeName': tradeName,
      'bState': bState,
    };
  }

  /// Converts the object into a readable string (useful for logs)
  @override
  String toString() {
    return 'BusinessModel(gst: $gst, pan: $pan, bStatus: $bStatus, bAddress: $bAddress, bName: $bName, tan: $tan, tradeName: $tradeName, bState: $bState)';
  }
}
