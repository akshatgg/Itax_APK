import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/constants/strings_constants.dart';
import '../../../core/data/apis/models/company/company_model.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/utils/widget/custom_app_bar_more.dart';
import '../../../shared/utils/widget/custom_image.dart';
import '../../router/router_helper.dart';
import '../../router/routes.dart';

class MoreMyCompanyDetail extends StatefulWidget {
  final CompanyModel? companyModel;

  const MoreMyCompanyDetail({super.key, required this.companyModel});

  @override
  State<MoreMyCompanyDetail> createState() => _MoreMyCompanyDetailState();
}

class _MoreMyCompanyDetailState extends State<MoreMyCompanyDetail> {
  @override
  void initState() {
    super.initState();
    logger.d(widget.companyModel?.id);
  }

  @override
  Widget build(BuildContext context) {
    logger.d(widget.companyModel?.companyName);
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBarMore(
        title: AppStrings.companyDetails,
        child: GestureDetector(
          onTap: () => RouterHelper.push(context, AppRoutes.addCompany.name,
              extra: {'company': widget.companyModel?.toJson()}),
          child: Row(
            children: [
              const Icon(
                Icons.edit,
                color: AppColor.appColor,
              ),
              SizedBox(
                width: 3.w,
              ),
              Text(
                AppStrings.edit,
                style: AppTextStyle.pw500.copyWith(color: AppColor.appColor),
              ),
              SizedBox(
                width: 5.w,
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: AppColor.greyContainer,
            ),
            Positioned(
              top: 6.h,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 75.px,
                      width: 75.px,
                      // color: AppColor.white,
                      decoration: BoxDecoration(
                          color: AppColor.greyContainer,
                          borderRadius: BorderRadius.circular(12.px),
                          border: Border.all(color: AppColor.white, width: 5)),
                      child: Center(
                        child: CustomImageView(
                          width: 38.px,
                          height: 45.px,
                          fit: BoxFit.cover,
                          imagePath: ImageConstants.companyIcon,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Center(
                    child: Text(
                      AppStrings.companyDetailsTagline,
                      style: AppTextStyle.pw400
                          .copyWith(color: AppColor.grey, fontSize: 14.px),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  const Divider(
                    color: AppColor.greyContainer,
                  ),
                  // SizedBox(
                  //   height: 1.h,
                  // ),
                  infoWidget(
                      title: AppStrings.businessName,
                      detail: widget.companyModel?.companyName ?? ''),
                  SizedBox(
                    height: 2.h,
                  ),
                  // infoWidget(title: 'GST Number', detail: 'N/A'),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  infoWidget(
                      title: AppStrings.mobileNumber,
                      detail: widget.companyModel?.companyPhone ?? ''),
                  SizedBox(
                    height: 2.h,
                  ),
                  infoWidget(
                      title: AppStrings.emailId,
                      detail: widget.companyModel?.companyEmail ?? ''),
                  SizedBox(
                    height: 2.h,
                  ),
                  const Divider(
                    thickness: 3,
                    color: AppColor.greyContainer,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.businessAddress,
                          style: AppTextStyle.pw500.copyWith(
                              fontSize: 16.px, color: AppColor.darkGrey),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          widget.companyModel?.companyAddress ?? '',
                          style: AppTextStyle.pw500
                              .copyWith(color: AppColor.grey, fontSize: 12.px),
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: AppStrings.state,
                            style: AppTextStyle.pw500.copyWith(
                                color: AppColor.grey, fontSize: 12.px),
                          ),
                          TextSpan(
                            text: widget.companyModel?.companyState ?? '',
                            style: AppTextStyle.pw500.copyWith(
                                color: AppColor.darkGrey, fontSize: 12.px),
                          ),
                        ])),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: AppStrings.pincode,
                            style: AppTextStyle.pw500.copyWith(
                                color: AppColor.grey, fontSize: 12.px),
                          ),
                          TextSpan(
                            text: widget.companyModel?.companyPincode ?? '',
                            style: AppTextStyle.pw500.copyWith(
                                color: AppColor.darkGrey, fontSize: 12.px),
                          ),
                        ]))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoWidget({required String title, required String detail}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.pw400
                .copyWith(color: AppColor.grey, fontSize: 12.px),
          ),
          Text(
            detail,
            style: AppTextStyle.pw500
                .copyWith(color: AppColor.darkGrey, fontSize: 14.px),
          ),
        ],
      ),
    );
  }
}
