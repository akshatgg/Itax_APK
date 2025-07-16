import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../shared/utils/widget/custom_image.dart';
import 'custom_year_dropdown.dart';

class ProfileBottomSheet extends StatelessWidget {
  final String? selectedYear;
  final List<String> yearOptions;
  final void Function(String?) onYearChanged;

  const ProfileBottomSheet({
    super.key,
    required this.selectedYear,
    required this.yearOptions,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildDropdownSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFC8F1BF),
            Color(0xFFE1F3DD),
            Color(0xFFDCF3D9),
          ],
        ),
        border: Border(
          bottom: BorderSide(color: AppColor.black),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: ImageConstants.capitalProfile,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProfileDetail(title: 'Name', detail: 'Shahbaz Alam'),
                _ProfileDetail(title: 'GSTIN', detail: '22AAAA0000A1Z5'),
                _ProfileDetail(title: 'Financial year', detail: '2024–25'),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(top: 36),
              child: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose year',
            style: AppTextStyle.pw500.copyWith(fontSize: 14.px),
          ),
          const SizedBox(height: 12),
          ...['Assessment Year', 'Financial Year'].map(
            (hint) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomYearDropdown(
                value: selectedYear,
                options: yearOptions,
                hint: hint,
                onChanged: (value) {
                  onYearChanged(value);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  final String title;
  final String detail;

  const _ProfileDetail({required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 103.px,
            child: Text(
              title,
              style: AppTextStyle.pw500.copyWith(color: AppColor.black),
            ),
          ),
          SizedBox(
            width: 140.px,
            child: Text(
              ': $detail',
              style: AppTextStyle.pw400.copyWith(
                color: AppColor.black,
                fontSize: 14.px,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
