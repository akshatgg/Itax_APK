import 'package:flutter/material.dart';

import '../widgets/amount_input_field.dart';
import '../widgets/gradient_app_bar.dart';

void main() {
  runApp(const MaterialApp(home: ExemptionsDeductionsScreen()));
}

class ExemptionsDeductionsScreen extends StatelessWidget {
  const ExemptionsDeductionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        title: 'Exemptions & Deductions',
        onBack: () => Navigator.pop(context),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ExemptionsForm(),
      ),
    );
  }
}

class ExemptionsForm extends StatefulWidget {
  const ExemptionsForm({super.key});

  @override
  State<ExemptionsForm> createState() => _ExemptionsFormState();
}

class _ExemptionsFormState extends State<ExemptionsForm> {
  bool isExemptionsSelected = true;

  final List<Map<String, String>> exemptions = [
    {'label': 'Income from Salary', 'suffix': '₹'},
    {'label': 'Income from Interest', 'suffix': '%'},
    {'label': 'Rental Income Received', 'suffix': 'Y'},
    {'label': 'Income from Digital Assets', 'suffix': 'Y'},
    {'label': 'Exempt Allowance', 'suffix': 'Y'},
    {'label': 'Interest on Home Loan - Self Occupied', 'suffix': 'Y'},
    {'label': 'Other Income', 'suffix': 'Y'},
  ];

  final List<Map<String, String>> deductions = [
    {'title': '80C', 'description': 'Life Insurance, PPP,EPL,ELSS,NPS'},
    {'title': '80DD', 'description': 'Permanent physical disability'},
    {'title': '80DDB', 'description': 'Medical Treatment Expenses'},
    {
      'title': '80EE',
      'description': 'Home Loan Should be taken in Fin. year 2024–2025'
    },
    {'title': '80CCD(1B)', 'description': 'National Pension scheme–add'},
    {
      'title': '80EEA(1B)',
      'description': 'Interest on Loan for Affordable Housing'
    },
    {'title': 'Food Coupons', 'description': 'Food Coupons'},
    {'title': '80U', 'description': 'Deduction for Disabled Inviduals'},
    {
      'title': '80EEB',
      'description': 'Interest on Loan for purchase of Electric Vehicle'
    },
    {'title': '80E', 'description': 'Interest on Education Loan'},
    {'title': '80G-Eligible Deductions 50%', 'description': 'Donations'},
    {'title': '80G-Eligible Deductions 100%', 'description': 'Donations'},
    {
      'title': '80GGA',
      'description': 'Donation for Scientific Research and Rural'
    },
    {'title': '80GGC', 'description': 'Donation to Political Parties'},
    {'title': 'Other Exemptions', 'description': 'Other Exemptions'},
    {'title': '80TTA', 'description': 'Interest from Saving Accounts'},
    {
      'title': '80GGB',
      'description': 'Interest from Deposit for Senior Citizen'
    },
    {'title': '80CCD(2)', 'description': 'Employers Contribution to NPS'},
    {'title': 'Standard Deduction', 'description': 'Standard Deduction'},
  ];

  final Map<String, TextEditingController> deductionControllers = {};
  final Map<String, bool> deductionIsMonthly = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomToggleTabs(
          isExemptionsSelected: isExemptionsSelected,
          onTabSelected: (selected) {
            setState(() {
              isExemptionsSelected = selected;
            });
          },
        ),
        const SizedBox(height: 20),
        Expanded(
          child: isExemptionsSelected
              ? ListView.builder(
                  itemCount: exemptions.length,
                  itemBuilder: (context, index) {
                    final field = exemptions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InputField(
                        label: field['label']!,
                        suffix: field['suffix']!,
                      ),
                    );
                  },
                )
              : ListView.builder(
                  itemCount: deductions.length,
                  itemBuilder: (context, index) {
                    final item = deductions[index];
                    final title = item['title']!;
                    final description = item['description']!;
                    final combinedTitle = '$title\n$description';

                    deductionControllers.putIfAbsent(
                        title, () => TextEditingController());
                    deductionIsMonthly.putIfAbsent(title, () => true);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DeductionTile(
                        title: combinedTitle,
                        value: double.tryParse(
                                deductionControllers[title]?.text ?? '0') ??
                            0.0,
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24)),
                            ),
                            isScrollControlled: true,
                            builder: (_) {
                              return SafeArea(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 32,
                                        left: 16,
                                        right: 16,
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            16,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AmountInputField(
                                            label: title,
                                            controller:
                                                deductionControllers[title]!,
                                            isMonthly:
                                                deductionIsMonthly[title]!,
                                            onToggle: (val) {
                                              setState(() {
                                                deductionIsMonthly[title] = val;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: -50,
                                      width: MediaQuery.of(context).size.width,
                                      child: GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(Icons.close,
                                              color: Colors.white, size: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class CustomToggleTabs extends StatelessWidget {
  final bool isExemptionsSelected;
  final ValueChanged<bool> onTabSelected;

  const CustomToggleTabs({
    super.key,
    required this.isExemptionsSelected,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleButton('Exemptions', isExemptionsSelected, () {
          onTabSelected(true);
        }),
        const SizedBox(width: 12),
        _buildToggleButton('Deductions', !isExemptionsSelected, () {
          onTabSelected(false);
        }),
      ],
    );
  }

  Widget _buildToggleButton(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF3FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFD0D5DD) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String suffix;

  const InputField({
    super.key,
    required this.label,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            suffixText: suffix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: '0',
          ),
        ),
      ],
    );
  }
}

class DeductionTile extends StatelessWidget {
  final String title;
  final double value;
  final VoidCallback? onTap;

  const DeductionTile({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade500),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFECF3FC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                value.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
