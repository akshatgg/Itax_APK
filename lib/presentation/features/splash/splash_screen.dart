import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/data/repos/dashboard_data_repo.dart';
import '../../../core/utils/get_it_instance.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/utils/widget/custom_image.dart';
import '../../router/router_helper.dart';
import '../../router/routes.dart';
import '../company/domain/company_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double rotationAngle = 0;

  @override
  void initState() {
    logger.i('initState splash');
    context.read<CompanyBloc>().add(const OnGetCompany());
    getIt.get<DashboardDataRepo>().getDashboardData();
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() {
      rotationAngle = 135 * (pi / 180);
    });

    await Future<void>.delayed(const Duration(seconds: 2));
    setState(() {
      rotationAngle = 360 * (pi / 180);
    });

    await Future<void>.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    RouterHelper.push(context, AppRoutes.splashNext.name);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () => Focus.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColor.black,
          body: SafeArea(
            child: Center(
              child: AnimatedRotation(
                turns: rotationAngle / (2 * pi),
                duration: const Duration(seconds: 1),
                child: CustomImageView(
                  imagePath: ImageConstants.splashLogo,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
