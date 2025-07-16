import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../shared/utils/widget/custom_app_bar.dart';
import '../../../shared/utils/widget/gradient_widget.dart';
import '../../../shared/utils/widget/show_alert.dart';
import '../../router/router_helper.dart';
import '../../router/routes.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'More',
          showBackButton: true,
          onBackTap: () {
            GoRouter.of(context).go(AppRoutes.dashboardView.path);
          },
        ),
        body: Container(
          color: AppColor.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*  SizedBox(
                height: 2.h,
              ),
             Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                // height: 80.px,
                decoration: BoxDecoration(
                    color: AppColor.green,
                    borderRadius: BorderRadius.circular(12.px)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Premium Membership',
                      style: AppTextStyle.pw600.copyWith(fontSize: 18.px),
                    ),
                    Text(
                      'Upgrade for more features',
                      style: AppTextStyle.pw400
                          .copyWith(fontSize: 14.px, color: AppColor.white),
                    )
                  ],
                ),
              ), */
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account',
                      style: AppTextStyle.pw600
                          .copyWith(color: AppColor.darkGrey, fontSize: 16.px),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    infoWidget(
                        onTap: () {
                          RouterHelper.push(
                              context, AppRoutes.moreMyCompany.name);
                        },
                        title: 'My Companies',
                        icon: Icons.group_outlined),
                    SizedBox(
                      height: 2.h,
                    ),
                    // infoWidget(
                    //     onTap: () {
                    //       RouterHelper.push(
                    //           context, AppRoutes.moreManageUser.name);
                    //     },
                    //     title: 'Manage Users',
                    //     icon: Icons.group_outlined),
                    // SizedBox(
                    //   height: 2.h,
                    // ),
                    // infoWidget(
                    //     onTap: () {
                    //       RouterHelper.push(
                    //           context, AppRoutes.moreGstSetUp.name);
                    //     },
                    //     title: 'GSP Setup',
                    //     icon: Icons.settings_outlined),
                    // SizedBox(
                    //   height: 2.h,
                    // ),
                  ],
                ),
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
                      'Other',
                      style: AppTextStyle.pw600
                          .copyWith(color: AppColor.darkGrey, fontSize: 16.px),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    // infoWidget(
                    //     onTap: () {},
                    //     title: 'Inventory Settings',
                    //     icon: Icons.settings_outlined),
                    // SizedBox(
                    //   height: 2.h,
                    // ),
                    infoWidget(
                        onTap: () {
                          helpBottomSheet(context);
                        },
                        title: 'Help & Support',
                        icon: Icons.help_outline),
                    SizedBox(
                      height: 2.h,
                    ),
                    infoWidget(
                        onTap: () {
                          RouterHelper.push(
                              context, AppRoutes.morePrivacyPolicy.name);
                        },
                        title: 'Privacy Policy',
                        icon: Icons.privacy_tip_outlined),
                    SizedBox(
                      height: 2.h,
                    ),
                    infoWidget(
                        onTap: () {
                          RouterHelper.push(
                              context, AppRoutes.moreAboutUs.name);
                        },
                        title: 'About Us',
                        icon: Icons.info_outline),
                    SizedBox(
                      height: 2.h,
                    ),
                    // infoWidget(
                    //     onTap: () {},
                    //     title: 'Setting Policy',
                    //     icon: Icons.settings_outlined),
                    // SizedBox(
                    //   height: 2.h,
                    // ),
                    GestureDetector(
                      onTap: () async {
                        showLogOutDialog(context,
                            title: 'Are you sure you want to log out?',
                            onCancel: () {
                          RouterHelper.pop<void>(context);
                        }, onYes: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            RouterHelper.push(context, AppRoutes.signIn.name);
                          }
                        });
                      },
                      child: Text(
                        'Log Out',
                        style: AppTextStyle.pw500
                            .copyWith(color: AppColor.red, fontSize: 15.px),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoWidget(
      {required VoidCallback onTap, String? title, IconData? icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColor.darkGrey,
          ),
          SizedBox(
            width: 2.w,
          ),
          Expanded(
            child: Text(
              title ?? '',
              style: AppTextStyle.pw400
                  .copyWith(color: AppColor.darkGrey, fontSize: 16.px),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 20.px,
            color: AppColor.darkGrey,
          )
        ],
      ),
    );
  }

  void helpBottomSheet(BuildContext context) {
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
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.whatsapp,
                      color: AppColor.green, size: 25.px),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    'WhatsApp Support',
                    style: AppTextStyle.pw400.copyWith(color: AppColor.grey),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Icon(CupertinoIcons.phone,
                      color: AppColor.appColor, size: 25.px),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    'Call for Support',
                    style: AppTextStyle.pw400.copyWith(color: AppColor.grey),
                  ),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ));
  }
}
