import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/image_constants.dart';
import 'custom_image.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstants.noDataIcon,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'No Data Available',
            style: AppTextStyle.pw500.copyWith(fontSize: 16.px),
          ),
          Text(
            'No data available. Please try again after making relevant changes.',
            style: AppTextStyle.pw400.copyWith(),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
