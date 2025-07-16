import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/data/apis/models/party/party_model.dart';
import '../../../../router/router_helper.dart';
import '../../../../router/routes.dart';

class PartyDetail extends StatelessWidget {
  const PartyDetail({super.key, required this.partyModel});

  final PartyModel partyModel;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 20),
    child: GestureDetector(
      onTap: () => RouterHelper.push(
        context,
        AppRoutes.partyDetail.name,
        extra: {
          'party': partyModel.toJson(),
        },
      ),
      child: Row(
        children: [
          Container(
            height: 30.px,
            width: 30.px,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: AppColor.greyContainer, shape: BoxShape.circle),
            child: Text(
              partyModel.partyName.isNotEmpty ? partyModel.partyName[0] : '',
              style: AppTextStyle.pw500
                  .copyWith(color: AppColor.black, fontSize: 14.px),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
              child: Text(
                partyModel.partyName,
                style: AppTextStyle.pw500
                    .copyWith(color: AppColor.black, fontSize: 14.px),
              )),
          Text(
            '₹ ${partyModel.outstandingBalance.abs().toStringAsFixed(2)}',
            style: AppTextStyle.pw700
                .copyWith(color: AppColor.black, fontSize: 15.px),
          )
        ],
      ),
    ),);
  }
}
