import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../shared/utils/widget/custom_app_bar_more.dart';

class MoreAboutUsScreen extends StatefulWidget {
  const MoreAboutUsScreen({super.key});

  @override
  State<MoreAboutUsScreen> createState() => _MoreAboutUsScreenState();
}

class _MoreAboutUsScreenState extends State<MoreAboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: const CustomAppBarMore(title: 'About Us'),
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
                      'About Us',
                      style: AppTextStyle.pw700
                          .copyWith(color: AppColor.white, fontSize: 16.px),
                    ),
                    Text(
                      'Welcome to iTaxEasy!',
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
                        title: '',
                        desc: 'At iTaxEasy, we aim to '
                            'simplify compliance and taxation for individuals and businesses. '
                            'As a trusted online consulting platform, we provide a one-stop '
                            'solution for all your routine compliance needs, ensuring accuracy, '
                            'efficiency, and peace of mind.'),
                    SizedBox(
                      height: 1.h,
                    ),
                    commonWidget(
                        title: 'Our Mission:',
                        desc: 'To empower'
                            ' businesses and individuals by offering seamless '
                            'solutions for compliance, taxation, and financial management. '
                            'We strive to save your time and effort, allowing you to focus on '
                            'what truly matters.'),
                    SizedBox(
                      height: 1.h,
                    ),
                    commonWidget(
                        title: 'What We Do:',
                        desc:
                            'Provide expert guidance on tax and compliance matters.Offer user-friendly tools for managing routine compliance requirements.Ensure that your filings and submissions are accurate and timely. Simplify complex financial processes with clarity and ease.'),
                    SizedBox(
                      height: 1.h,
                    ),
                    commonWidget(
                        title: 'Why Choose Us:',
                        desc: 'Expertise:'
                            'Our team comprises seasoned professionals with deep domain knowledge.\nInnovation: Our technology-driven approach ensures efficient and hassle-free solutions.\nConvenience: Access our services anytime, anywhere through our online platform \nReliability: We prioritize precision and customer satisfaction above all.'),
                    SizedBox(
                      height: 1.h,
                    ),
                    commonWidget(
                        title: 'Our Commitment to You:',
                        desc:
                            'At iTaxEasy, your satisfaction is our priority. We are dedicated to delivering transparent, reliable, and effective services tailored to your needs. Whether you are an individual taxpayer or a growing business, we are here to make compliance easy for you.'),
                    SizedBox(
                      height: 1.h,
                    ),
                    commonWidget(
                        title: 'Get in Touch:',
                        desc:
                            'Ready to experience hassle-free compliance? Contact us today and let iTaxEasy take the stress out of your financial and compliance needs. Together, we can build a smarter, simpler future for your business!')
                  ],
                ),
              ))
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
