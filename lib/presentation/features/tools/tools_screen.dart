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

class ToolsView extends StatefulWidget {
  const ToolsView({super.key});

  @override
  State<ToolsView> createState() => _ToolsViewState();
}

class _ToolsViewState extends State<ToolsView> {
  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'Tools',
          showBackButton: false,
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
            ],
          ),
        ),
      ),
    );
  }

}
