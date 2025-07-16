import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:sizer/sizer.dart';

import 'core/constants/app_text_style.dart';
import 'core/constants/color_constants.dart';
import 'core/utils/input_formatter.dart';
import 'shared/utils/widget/custom_elevated_button.dart';
import 'shared/utils/widget/custom_textfield.dart';
import 'shared/utils/widget/snackbar/custom_snackbar.dart';

class InputExample extends StatelessWidget {
  const InputExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 35,
            children: [
              CustomTextfield(
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                textCapitalization: TextCapitalization.characters,
                controller: TextEditingController(),
                lable: 'first',
                hint: 'first',
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {},
              ),
              CustomTextfield(
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                textCapitalization: TextCapitalization.characters,
                controller: TextEditingController(),
                lable: 'second',
                hint: 'second',
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Hello'),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => ExampleSheet(),
              );
            },
            child: const Text('Press Here'),
          ),
        ],
      ),
    );
  }
}

class ExampleSheet extends StatelessWidget {
  ExampleSheet({super.key});

  final GlobalKey<OtpPinFieldState> controller = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Use Builder to get a context that's a child of Scaffold.of(context)
    return Builder(
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 5), // Shadow only at the top
              )
            ],
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // This is crucial to limit the height
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              // Subtitle
              Text(
                'Enter the 4 digits code that you received on your Mobile Number or Email.',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 2.h),
              // Email Input Field
              OtpPinField(
                key: controller,
                autoFillEnable: false,
                autoFocus: false,
                onSubmit: (text) {},
                onChange: (text) {},
                onCodeChanged: (code) {},
                otpPinFieldStyle: OtpPinFieldStyle(
                  showHintText: true,
                  filledFieldBorderColor: AppColor.appColor,
                  activeFieldBackgroundColor: AppColor.white,
                  filledFieldBackgroundColor: AppColor.white,
                  defaultFieldBackgroundColor: AppColor.white,
                  fieldBorderWidth: 1,
                  activeFieldBorderColor: AppColor.appColor,
                  defaultFieldBorderColor: Colors.grey.shade400,
                  textStyle: AppTextStyle.pw500,
                ),
                maxLength: 4,
                showCursor: true,
                cursorColor: AppColor.appColor,
                showCustomKeyboard: false,
                cursorWidth: 3,
                mainAxisAlignment: MainAxisAlignment.center,
                highlightBorder: true,
                showDefaultKeyboard: true,
                otpPinFieldDecoration:
                    OtpPinFieldDecoration.defaultPinBoxDecoration,
              ),
              SizedBox(height: 2.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t get OTP Code?',
                    style: AppTextStyle.pw500
                        .copyWith(fontSize: 14.px, color: AppColor.black),
                  ),
                  Text(
                    '  Resend OTP',
                    style: AppTextStyle.pw500
                        .copyWith(fontSize: 14.px, color: AppColor.appColor),
                  )
                ],
              ),
              SizedBox(height: 2.h),
              // Save Button
              CustomElevatedButton(
                text: 'Save',
                onTap: () {
                  CustomSnackBar.showSnack(
                    context: context,
                    message: 'OTP Verified!',
                    snackBarType: SnackBarType.success,
                  );
                },
                height: 44.px,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SearchDropdown extends StatefulWidget {
  const SearchDropdown({super.key});

  @override
  State<SearchDropdown> createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final List<String> _allItems = [
    'Monu Pathak',
    'Sanjay Enterprises',
    'Amit Kumar Singh',
    'Amir Faisal',
    'Sanal Kumar',
    'Ajay Kumar',
    'Arun Kumar',
    'Pawan Kumar',
  ];
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _allItems
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        top: 50,
        width: size.width,
        child: Material(
          elevation: 4.0,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: Text(
                      _filteredItems[index][0].toUpperCase(),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  title: Text(
                    _filteredItems[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    _controller.text = _filteredItems[index];
                    _removeOverlay();
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _filterItems,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }
}
