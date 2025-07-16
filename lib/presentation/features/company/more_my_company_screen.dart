import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/strings_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/data/apis/models/company/company_model.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/utils/widget/custom_app_bar_more.dart';
import '../../../shared/utils/widget/custom_floating_button.dart';
import '../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import '../../router/router_helper.dart';
import '../../router/routes.dart';
import 'domain/company_bloc.dart';

class MoreMyCompany extends StatefulWidget {
  const MoreMyCompany({super.key});

  @override
  State<MoreMyCompany> createState() => _MoreMyCompanyState();
}

class _MoreMyCompanyState extends State<MoreMyCompany> {
  @override
  void initState() {
    context.read<CompanyBloc>().add(const OnGetCompany());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final companyBloc = context.watch<CompanyBloc>();
    final company = companyBloc.state.company;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: const CustomAppBarMore(
          title: AppStrings.myCompanies,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                BlocListener<CompanyBloc, CompanyState>(
                  listener: (context, state) {
                    if (state is CompanyDeleteOperationSuccess) {
                      CustomSnackBar.showSnack(
                        context: context,
                        snackBarType: SnackBarType.success,
                        message: AppStrings.deletedSuccessfullyCompanies,
                      );
                    }
                    if (state is CompanyDeleteOperationFailed) {
                      CustomSnackBar.showSnack(
                        context: context,
                        snackBarType:
                            SnackBarType.error, // Change type if needed
                        message: AppStrings.deletedFailedCompanies,
                      );
                    }
                  },
                  child: Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return companyDetailWidget(
                          onTap: () {
                            logger.d(
                                'Passing company model: ${company[index].id}');
                            RouterHelper.push(
                                context, AppRoutes.moreMyCompanyDetail.name,
                                extra: {'company': company[index].toJson()});
                          },
                          onDelete: () {
                            _onDeletePressed(company[index]);
                          },
                          title: company[index].companyName,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(height: 1.h),
                            Divider(
                                color: AppColor.greyContainer, thickness: 2.px),
                            SizedBox(height: 1.h),
                          ],
                        );
                      },
                      itemCount: company.length,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: CustomFloatingButton(
          tag: AppStrings.tagAddCompany,
          title: AppStrings.addCompany,
          imagePath: ImageConstants.createInvoiceIcon,
          onTap: () {
            RouterHelper.push(context, AppRoutes.addCompany.name);
          },
        ),
      ),
    );
  }

  Widget companyDetailWidget({
    String? title,
    required VoidCallback onDelete,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
              height: 40.px,
              width: 50.px,
              color: AppColor.lightAppColor,
              child: const Icon(Icons.business, color: AppColor.appColor)),
          SizedBox(
            width: 3.w,
          ),
          Expanded(
            child: Text(
              title ?? '',
              style: AppTextStyle.pw500
                  .copyWith(color: AppColor.darkGrey, fontSize: 16.px),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.px),
            ),
            child: IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete,
                color: AppColor.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onDeletePressed(CompanyModel companyModel) async {
    final companyBloc = context.read<CompanyBloc>();
    companyBloc.add(OnDeleteCompany(companyModel: companyModel));
  }
}
