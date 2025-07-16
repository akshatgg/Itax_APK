import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/base_calculator_provider.dart';
import '../ui/GST/GST_calc_view.dart';
import '../ui/bank/compound_interest_view.dart';
import '../ui/bank/simple_interest_view.dart';
import '../ui/income tax/HRA_calc_view.dart';
import '../ui/income tax/capital_gain_calc_view.dart';
import '../ui/income tax/depreciation_calc_view.dart';
import '../ui/income tax/tax_calc_view.dart';
import '../ui/insurance/NPS_calc_view.dart';
import '../ui/investment/CARG_calc_view.dart';
import '../ui/investment/FD_calc_view.dart';
import '../ui/investment/RD_calc_view.dart';
import '../ui/investment/SIP_calc_view.dart';
import '../ui/investment/lump_sum_calc_view.dart';
import '../ui/investment/post_office_MIS_view.dart';
import '../ui/loan/business_calc_view.dart';
import '../ui/loan/car_calc_view.dart';
import '../ui/loan/home_calc_view.dart';
import '../ui/loan/personal_calc_view.dart';
import '../ui/loan/property_calc_view.dart';

/// Wraps calculator views with their base provider.
Widget wrapWithProvider(Widget child) {
  return ChangeNotifierProvider(
    create: (_) => BaseCalculatorProvider(),
    child: child,
  );
}

/// Maps string keys to calculator views.
final Map<String, Widget Function()> calculatorRouteMap = {
  // ---------------- BANK ----------------
  'Simple Interest Calculator': () =>
      wrapWithProvider(const SimpleInterestView()),
  'Compound Interest Calculator': () =>
      wrapWithProvider(const CompoundInterestView()),

  // ---------------- INCOME TAX ----------------
  'HRA Calculator': () => wrapWithProvider(const HRAcalcView()),
  'Depreciation Calculator': () =>
      wrapWithProvider(const DepreciationCalcView()),
  'Tax Calculator': () => wrapWithProvider(const TaxtCalcView()),
  'Capital Gain Calculator': () =>
      wrapWithProvider(const CapitalGainCalcView()),
  'Advance Tech Calculator (Old-Regime)': () =>
      wrapWithProvider(const TaxtCalcView()),

  // ---------------- INVESTMENT ----------------
  'Post Office MIS': () => wrapWithProvider(const PostOfficeMISView()),
  'CARG Calculator': () => wrapWithProvider(const CARGcalcView()),
  'RD Calculator': () => wrapWithProvider(const RDcalcView()),
  'FD Calculator': () => wrapWithProvider(const FDcalcView()),
  'Lump Sum Calculator': () => wrapWithProvider(const LumpSumCalcView()),
  'SIP Calculator': () => wrapWithProvider(const SIPcalcView()),

  // ---------------- INSURANCE ----------------
  'NPS Calculator': () => wrapWithProvider(const NPSCalcView()),

  // ---------------- LOAN ----------------
  'Business Loan Calculator': () => wrapWithProvider(const BusinessCalcView()),
  'Car Loan Calculator': () => wrapWithProvider(const CarCalcView()),
  'Home Loan Calculator': () => wrapWithProvider(const HomeCalcView()),
  'Loan Against Property': () => wrapWithProvider(const PropertyCalcView()),
  'Personal Loan Calculator': () => wrapWithProvider(const PersonalCalcView()),

  // ---------------- GST ----------------
  'GST Calculator': () => wrapWithProvider(const GSTcalcView()),
};
