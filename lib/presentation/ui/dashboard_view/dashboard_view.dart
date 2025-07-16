// Imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/data/repos/user_repo.dart';
import '../../../core/utils/get_it_instance.dart';
import '../../../main.dart';
import '../../../shared/utils/widget/custom_app_bar_more.dart';
import '../../../shared/utils/widget/custom_image.dart';
import '../../../shared/utils/widget/search_field.dart';
import '../../features/profile/domain/user_bloc.dart';
import '../../features/profile/domain/user_event.dart';
import '../../features/profile/domain/user_state.dart';
import '../../router/router_helper.dart';
import '../../router/routes.dart';
import '../calculator/routes/calc_routes.dart';
import '../itr/widgets/file_itr_bottom_sheet.dart';
import '../view/page/converter_page.dart';
import '../view/page/ocr/ocr_page.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserEvent());
  }

  final List<DashBordData> serviceList = [
    DashBordData(
        image: ImageConstants.itrIcon,
        color: const Color(0XFFE9F4EE),
        title: 'ITR'),
    DashBordData(
        image: ImageConstants.gstrIcon,
        color: const Color(0XFFF6F3FC),
        title: 'GSTR'),
    DashBordData(
        image: ImageConstants.billShillIcon,
        color: const Color(0XFFEEF2FF),
        title: 'Bill-Shill'),
    DashBordData(
        image: ImageConstants.easyServiceIcon,
        color: const Color(0XFFFEF2FF),
        title: 'Easy Services'),
    DashBordData(
        image: ImageConstants.eInvoiceIcon,
        color: const Color(0XFFFFF1FC),
        title: 'E Invoice'),
    DashBordData(
        image: ImageConstants.invoiceIcon,
        color: const Color(0XFFFFFCE3),
        title: 'Invoice'),
  ];

  final List<DashBordData> viewList = [
    DashBordData(
        image: ImageConstants.pdfIcon,
        color: const Color(0XFFFFF2F2),
        title: 'Converter'),
    DashBordData(
        image: ImageConstants.ocrIcon,
        color: const Color(0XFFFFFCE3),
        title: 'OCR'),
    // DashBordData(
    //     image: ImageConstants.startUpIcon,
    //     color: const Color(0XFFECF4FF),
    //     title: 'STARTUP'),
  ];

  final List<DashBordData> calculatorList = [
    DashBordData(
        image: ImageConstants.itrIcon,
        color: const Color(0XFFE9F4EE),
        title: 'Bank \nCalculator'),
    DashBordData(
        image: ImageConstants.easyServiceIcon,
        color: const Color(0XFFFEF2FF),
        title: 'Income Tax \nCalculator'),
    DashBordData(
        image: ImageConstants.eInvoiceIcon,
        color: const Color(0XFFFFF1FC),
        title: 'Gst \nCalculator'),
    DashBordData(
        image: ImageConstants.easyServiceIcon,
        color: const Color(0XFFFEF2FF),
        title: 'Investment \nCalculator'),
    DashBordData(
        image: ImageConstants.eInvoiceIcon,
        color: const Color(0XFFFFF1FC),
        title: 'Loan \nCalculator'),
    DashBordData(
        image: ImageConstants.invoiceIcon,
        color: const Color(0XFFFFFCE3),
        title: 'Insurance \nCalculator'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: _buildDrawer(Theme.of(context).brightness == Brightness.dark),
        appBar: CustomAppBarMore(
          titleWidget: Row(
            children: [
              CustomImageView(
                width: 60.px,
                height: 25.px,
                imagePath: ImageConstants.splashLogo,
              )
            ],
          ),
          onCompany: () {},
          arrow: false,
          showBackButton: false,
          child: Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: Row(
              children: [
                Icon(Icons.qr_code_scanner,
                    color: Theme.of(context).iconTheme.color),
                SizedBox(width: 3.w),
                Icon(Icons.notifications,
                    color: Theme.of(context).iconTheme.color),
                SizedBox(width: 3.w),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoadedState) {
                      return GestureDetector(
                        onTap: () {
                          RouterHelper.push(context, AppRoutes.profile.name);
                        },
                        child: state.user.userImage?.isNotEmpty ?? false
                            ? ClipOval(
                                child: Image.memory(
                                  state.user.userImage!,
                                  height: 40.px,
                                  width: 40.px,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.person,
                                color: Theme.of(context).iconTheme.color),
                      );
                    } else if (state is UserErrorState &&
                        state.message == 'No user found') {
                      return Icon(Icons.person,
                          color: Theme.of(context).iconTheme.color);
                    } else {
                      return const SizedBox(); // Loading or other unknown state
                    }
                  },
                )
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: searchTextField(hint: 'Search', filter: false),
                ),
                SizedBox(height: 2.h),
                /* CustomImageView(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  radius: BorderRadius.circular(10.px),
                  imagePath: ImageConstants.dashBoardBannerIcon,
                ),*/
                SizedBox(height: 2.h),
                sectionHeader('Services'),
                SizedBox(height: 2.h),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 0.px,
                    crossAxisCount: 3,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: serviceList.length,
                  itemBuilder: (context, index) {
                    return itemDetailWidget(
                      onTap: () {
                        switch (serviceList[index].title) {
                          case 'Bill-Shill':
                            RouterHelper.push(context, AppRoutes.homeView.name);
                            break;
                          case 'ITR':
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const SafeArea(
                                child: FileItrBottomSheet(),
                              ),
                            );
                            break;
                          default:
                            break;
                        }
                      },
                      image: serviceList[index].image,
                      color: serviceList[index].color,
                      title: serviceList[index].title,
                    );
                  },
                ),
                sectionHeader('View'),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: viewList.map((item) {
                    return itemDetailWidget(
                      onTap: () {
                        switch (item.title) {
                          case 'Converter':
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConverterPage(),
                              ),
                            ); // Page1 route
                            break;
                          case 'OCR':
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OCRPage(),
                              ),
                            );
                            break;
                          // Add more cases here if needed
                          default:
                            break;
                        }
                      },
                      title: item.title,
                      image: item.image,
                      color: item.color,
                    );
                  }).toList(),
                ),
                SizedBox(height: 2.h),
                sectionHeader('Calculator'),
                SizedBox(height: 2.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0.px,
                    crossAxisSpacing: 10.px,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: calculatorList.length,
                  itemBuilder: (context, index) {
                    List<String> options = [];
                    switch (index) {
                      case 0:
                        options = [
                          'Simple Interest Calculator',
                          'Compound Interest Calculator'
                        ];
                        break;
                      case 1:
                        options = [
                          'HRA Calculator',
                          'Depreciation Calculator',
                          'Advance Tax Calculator (Old-Regime)',
                          'Tax Calculator',
                          'Capital Gain Calculator'
                        ];
                        break;
                      case 2:
                        options = ['GST Calculator'];
                        break;
                      case 3:
                        options = [
                          'Post Office MIS',
                          'CARG Calculator',
                          'RD Calculator',
                          'FD Calculator',
                          'Lump Sum Calculator',
                          'SIP Calculator'
                        ];
                        break;
                      case 4:
                        options = [
                          'Business Loan Calculator',
                          'Car Loan Calculator',
                          'Personal Loan Calculator',
                          'Home Loan Calculator',
                          'Loan Against Property'
                        ];
                        break;
                      case 5:
                        options = ['NPS Calculator'];
                        break;
                    }

                    return itemDetailWidget(
                      onTap: () {
                        showCalculatorOptionsBottomSheet(
                          context: context,
                          title: calculatorList[index].title,
                          options: options,
                        );
                      },
                      image: calculatorList[index].image,
                      color: calculatorList[index].color,
                      title: calculatorList[index].title,
                    );
                  },
                )
              ],
            ),
          ),
        ),

        //bottom app bar introduce karna h
      ),
    );
  }

  void showCalculatorOptionsBottomSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Wrap(
              children: [
                const Center(/* drag handle */),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    title.replaceAll('\n', ' '),
                    style: AppTextStyle.heading20,
                  ),
                ),
                ...options.map((calc) => ListTile(
                      title: Text(calc),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(ctx).pop(); // Close bottom sheet
                        final viewBuilder = calculatorRouteMap[calc];
                        if (viewBuilder != null) {
                          Navigator.of(context).push<Widget>(
                            MaterialPageRoute<Widget>(
                              builder: (_) => viewBuilder(),
                            ),
                          );
                        } else {
                          Get.snackbar(
                            'Error',
                            'No screen found for "$calc"',
                            backgroundColor: Colors.white,
                          );
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemDetailWidget({
    required VoidCallback onTap,
    Color? color,
    String? image,
    String? title,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60.px,
            width: 80.px,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.px),
              boxShadow: [
                const BoxShadow(color: Colors.black54, blurRadius: 4)
              ],
            ),
            child: CustomImageView(
              imagePath: image,
              fit: BoxFit.contain,
              height: 40.px,
              width: 40.px,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title ?? '',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyle.pw500.copyWith(
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Row(
      children: [
        Expanded(
            child: Divider(thickness: 5.px, color: AppColor.greyContainer)),
        Container(
          width: 140.px,
          height: 30.px,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.lightAppColor,
            border: Border.all(color: AppColor.appColor),
            borderRadius: BorderRadius.circular(20.px),
          ),
          child: Text(
            title,
            style: AppTextStyle.pw400.copyWith(color: AppColor.appColor),
          ),
        ),
        Expanded(
            child: Divider(thickness: 5.px, color: AppColor.greyContainer)),
      ],
    );
  }

  Widget _buildDrawer(bool isDark) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.brightness_6,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Toggle Theme',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap: () {
              themeNotifier.value = themeNotifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: isDark ? Colors.white : Colors.black,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            onTap: () async {
              await getIt.get<UserRepo>().storageService.clearAllUser();
              if (context.mounted) context.go(AppRoutes.signIn.path);
            },
          ),
        ],
      ),
    );
  }
}

class DashBordData {
  final String image;
  final Color color;
  final String title;

  DashBordData({
    required this.image,
    required this.color,
    required this.title,
  });
}
