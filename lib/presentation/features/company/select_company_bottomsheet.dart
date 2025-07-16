import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/strings_constants.dart';
import '../../../core/data/apis/models/company/company_model.dart';
import '../../../shared/utils/widget/custom_image.dart';
import '../../router/router_helper.dart';
import '../../router/routes.dart';
import 'domain/company_bloc.dart';

class SelectBusinessScreen extends StatefulWidget {
  final List<CompanyModel> companyModel;

  const SelectBusinessScreen({super.key, required this.companyModel});

  @override
  State<SelectBusinessScreen> createState() => _SelectBusinessScreenState();
}

class _SelectBusinessScreenState extends State<SelectBusinessScreen> {
  int selectedBusinessIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.px),
          topRight: Radius.circular(10.px),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppStrings.selectBusiness,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(widget.companyModel.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: widget.companyModel[index].companyImage?.filePath
                                .isEmpty ??
                            false
                        ? const Icon(Icons.business, color: Colors.black87)
                        : CustomImageView(
                            file: File(widget.companyModel[index].companyImage
                                    ?.filePath ??
                                ''),
                          ),
                  ),
                  title: Text(
                    widget.companyModel[index].companyName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<int>(
                        value: index,
                        groupValue: selectedBusinessIndex,
                        onChanged: (val) {
                          if (val == null) {
                            return;
                          }
                          selectedBusinessIndex = val;

                          context
                              .read<CompanyBloc>()
                              .add(OnUpdateCurrentCompany(index: val));
                          RouterHelper.pop<void>(context);
                        },
                        activeColor: Colors.blue,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _onDeletePressed(widget.companyModel[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 2.h),
          Center(
            child: TextButton(
              onPressed: () {
                RouterHelper.push(context, AppRoutes.addCompany.name);
              },
              child: const Text(
                AppStrings.addNewCompany,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue,
                ),
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
