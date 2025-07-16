import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/logger.dart';

class StateCityPicker extends StatefulWidget {
  final void Function(String) onStateChanged;
  final void Function(String) onCityChanged;
  final String predefinedState;
  final String predefinedCity;
  final bool showCities;
  final bool showStates;

  const StateCityPicker({
    super.key,
    required this.onStateChanged,
    required this.onCityChanged,
    this.predefinedState = 'State',
    this.predefinedCity = 'City',
    this.showCities = true,
    this.showStates = true,
  });

  @override
  State<StateCityPicker> createState() => _StateCityPickerState();
}

class _StateCityPickerState extends State<StateCityPicker> {
  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    selectedState = widget.predefinedState;
    selectedCity = widget.predefinedCity;
    logger.d(selectedState);

    // Delay to allow widget to build before setting values
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CSCPickerPlus(
      layout: Layout.vertical,
      cityDropdownLabel: selectedCity.toString(),
      stateDropdownLabel: selectedState.toString(),
      defaultCountry: CscCountry.India,
      disableCountry: true,
      showCities: widget.showCities,
      showStates: widget.showStates,
      flagState: CountryFlag.DISABLE,
      currentCity: selectedCity,
      currentState: selectedState,
      // Hide country flag
      countryStateLanguage: CountryStateLanguage.englishOrNative,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      onStateChanged: (value) {
        setState(() {
          selectedState = value;
        });
        widget.onStateChanged(value ?? selectedState.toString());
      },
      onCityChanged: (value) {
        setState(() {
          selectedCity = value;
        });
        widget.onCityChanged(value ?? selectedCity.toString());
      },
    );
  }
}
