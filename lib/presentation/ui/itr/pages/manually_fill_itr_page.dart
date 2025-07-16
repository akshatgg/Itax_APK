import 'package:flutter/material.dart';

import '../widgets/custom_bottom_nav_itr.dart';
import '../widgets/custom_year_dropdown.dart';
import '../widgets/expandable_section_tile.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/info_card.dart';
import '../widgets/itr_section_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_bottom_sheet.dart';
import 'business_nd_profession_page.dart';
import 'capitals_gain_page.dart';
import 'exemptions_deductions_page.dart';
import 'income_from_house_party_page.dart';
import 'other_sources_page.dart';
import 'salary_less_tx_sd_nd_p_tax_page.dart';
import 'tax_payable_page.dart';
import 'taxes_paid_page.dart';

class ManuallyFillItrPage extends StatefulWidget {
  const ManuallyFillItrPage({super.key});

  @override
  State<ManuallyFillItrPage> createState() => _ManuallyFillItrPageState();
}

class _ManuallyFillItrPageState extends State<ManuallyFillItrPage> {
  String? selectedYear;

  final List<String> yearOptions = [
    'Select Year',
    '2018–19',
    '2019–20',
    '2020–21',
    '2021–22',
    '2022–23',
    '2023–24',
    '2024–25',
    '2025–26',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        title: 'Manually Fill ITR',
        onBack: () => Navigator.pop(context),
        actionWidgets: [
          selectedYear != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.more_horiz, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '($selectedYear)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.more_horiz, color: Colors.white, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'Select Year',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomYearDropdown(
                options: yearOptions,
                onChanged: (value) {
                  setState(() {
                    selectedYear = value;
                  });
                },
                wrapContent: true,
                value: selectedYear, // 👈 Important for this specific case
              ),
              const SizedBox(height: 24),
              ExpandableSectionTile(
                title: 'Profile Section',
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return SafeArea(
                        child: ProfileBottomSheet(
                          selectedYear: selectedYear,
                          yearOptions: yearOptions,
                          onYearChanged: (value) {
                            setState(() => selectedYear = value);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              ITRSectionTile(
                title: 'Salary Less SD & P Tax',
                value: 0.0,
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SalaryLessSDPTaxPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ITRSectionTile(
                title: 'Income from House Property',
                value: 0.0,
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IncomeFromHousePropertyPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ITRSectionTile(
                title: 'Capital Gains',
                value: 0.0,
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CapitalGainsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ITRSectionTile(
                title: 'Other Sources',
                value: 0.0,
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OtherSourcesPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ITRSectionTile(
                title: 'Business and Profession',
                value: 0.0,
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BusinessNdProfessionPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const InfoCard(label: 'Total Income', value: 0.0),
              const SizedBox(height: 20),
              ITRSectionTile(
                title: 'Exemption & Deduction',
                value: 0.0,
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExemptionsDeductionsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              ITRSectionTile(
                title: 'Tax Payable',
                value: 0.0,
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaxPayableScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const InfoCard(label: 'Net Income', value: 0.0),
              const SizedBox(height: 20),
              ITRSectionTile(
                title: 'Taxes Paid',
                value: 0.0,
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IncomeTaxCalculatorScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              const InfoCard(label: 'Refund', value: 0.0),
              const SizedBox(height: 30),
              PrimaryButton(
                label: 'Download JSON',
                onPressed: () {},
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavBarItr(
          currentIndex: 0,
          onItemSelected: (index) {
            // Handle bottom nav item if needed
          },
        ),
      ),
    );
  }
}
