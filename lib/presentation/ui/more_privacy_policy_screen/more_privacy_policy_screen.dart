import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../shared/utils/widget/custom_app_bar_more.dart';

class MorePrivacyPolicyScreen extends StatefulWidget {
  const MorePrivacyPolicyScreen({super.key});

  @override
  State<MorePrivacyPolicyScreen> createState() =>
      _MorePrivacyPolicyScreenState();
}

class _MorePrivacyPolicyScreenState extends State<MorePrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBarMore(title: 'Privacy Policy'),
      body: SafeArea(
        child: Container(
          color: AppColor.greyContainer,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                    color: AppColor.green,
                    borderRadius: BorderRadius.circular(20.px)),
                child: Column(
                  children: [
                    Text(
                      'Privacy Policy',
                      style: AppTextStyle.pw700
                          .copyWith(color: AppColor.white, fontSize: 16.px),
                    ),
                    Text(
                      'iTaxEasy',
                      style: AppTextStyle.pw600
                          .copyWith(color: AppColor.white, fontSize: 14.px),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      commonWidget(
                          title: 'Introduction:',
                          desc:
                              'iTaxEasy is an online consulting platform offering solutions for routine compliances. By accessing or using this website, you agree to abide by these terms. If you do not agree, please discontinue use'),
                      SizedBox(
                        height: 1.h,
                      ),
                      commonWidget(
                          title: '1. Copyright & Trademarks:',
                          desc:
                              'All site content is protected under copyright and trademark laws. You may use the material for personal, non-commercial purposes, but must not modify or redistribute without authorization. By submitting materials to iTaxEasy, you grant a non-exclusive, royalty-free license to use and display them.'),
                      SizedBox(
                        height: 1.h,
                      ),
                      commonWidget(
                          title: '2. Site Usage:',
                          desc:
                              'iTaxEasy does not guarantee the accuracy or safety of information or services on the site, which may include third-party content. Use the site at your own risk and ensure appropriate data protection measures.'),
                      SizedBox(
                        height: 1.h,
                      ),
                      commonWidget(
                          title: '3. Limitation of Liability:',
                          desc:
                              'iTaxEasy is not liable for any direct, indirect, or consequential damages arising from your use of the site'),
                      SizedBox(
                        height: 1.h,
                      ),
                      commonWidget(
                          title: '4. Indemnification:',
                          desc:
                              'You agree to indemnify iTaxEasy against losses,damages,or costs resulting from your violation of this policy'),
                      SizedBox(
                        height: 1.h,
                      ),
                      commonWidget(
                          title: '5. Termination:',
                          desc:
                              'Either Party may terminate this agreement with 30 day notice.Certain clauses, such as copyright and liability remain post Termination')
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget commonWidget({required String title, required String desc}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
          color: AppColor.white, borderRadius: BorderRadius.circular(20.px)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != ''
              ? Text(
                  title,
                  style: AppTextStyle.pw700
                      .copyWith(color: AppColor.black, fontSize: 16.px),
                )
              : const SizedBox(),
          Text(
            desc,
            textAlign: TextAlign.justify,
            style: AppTextStyle.pw400
                .copyWith(color: AppColor.grey, fontSize: 14.px),
          )
        ],
      ),
    );
  }
}
