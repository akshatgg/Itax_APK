// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/data/repos/company_repo.dart';
import '../../../core/data/repos/user_repo.dart';
import '../../../core/utils/get_it_instance.dart';
import '../../../core/utils/logger.dart';
import '../../router/router_helper.dart';
import '../../router/routes.dart';
import '../company/domain/company_bloc.dart';
import '../invoice/domain/invoice/invoice_bloc.dart';
import '../invoice/domain/notes/notes_bloc.dart';
import '../invoice/domain/receipt/receipt_bloc.dart';
import '../items/domain/item/item_bloc.dart';
import '../parties/domain/parties/parties_bloc.dart';
import '../reports/domain/day_book/day_book_bloc.dart';

class SplashScreenNext extends StatefulWidget {
  const SplashScreenNext({super.key});

  @override
  State<SplashScreenNext> createState() => _SplashScreenNextState();
}

class _SplashScreenNextState extends State<SplashScreenNext> {
  bool _showSubText = false;

  @override
  void initState() {
    super.initState();
    _preloadData();
    _startAnimation();
  }

  void _preloadData() {
    final companyBloc = context.read<CompanyBloc>();
    if (companyBloc.currentCompany != null) {
      context.read<ItemBloc>().add(const OnGetItem());
      context.read<PartiesBloc>().add(const OnGetParties());
      context.read<ReceiptBloc>().add(const OnGetReceipt());
      context.read<InvoiceBloc>().add(const GetAllInvoices());
      context.read<DayBookBloc>().add(const OnLoadDayBooks());
      context.read<NotesBloc>().add(const GetAllNotes());
    }
  }

  Future<void> _startAnimation() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    setState(() {
      _showSubText = true;
    });

    await Future<void>.delayed(const Duration(seconds: 1));
    await _checkLogin();
  }

  Future<void> _checkLogin() async {
    final userRepo = getIt.get<UserRepo>();
    final user = await userRepo.getUser(); // Must return from Hive/local

    final companyRepo = getIt.get<CompanyRepo>();
    await companyRepo.getAllCompany(); // ensure currentCompany is filled
    final companyId = companyRepo.currentCompany?.id;

    logger.d('User: $user');
    logger.d('Company: $companyId');

    if (user == null) {
      RouterHelper.push(context, AppRoutes.signIn.name);
    } else if (companyId == null) {
      RouterHelper.push(context, AppRoutes.profile.name);
    } else {
      RouterHelper.push(context, AppRoutes.dashboardView.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Focus.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.gradient1,
              AppColor.gradient2,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'iTax Easy',
                    style: AppTextStyle.pw800.copyWith(
                      color: AppColor.white,
                      fontSize: 45.px,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _showSubText ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Trust on we are here',
                        style: AppTextStyle.pw600.copyWith(
                          color: AppColor.white,
                          fontSize: 20.px,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
