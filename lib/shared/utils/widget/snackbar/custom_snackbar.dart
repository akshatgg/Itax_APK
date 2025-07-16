import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';

enum SnackBarType {
  warring(
    color: Colors.orange,
    acentColor: Colors.orangeAccent,
    icon: Icon(
      Icons.warning_rounded,
      color: Colors.white,
    ),
    snackLabel: 'Warning!',
    textColor: Colors.black,
  ),
  error(
    color: Colors.red,
    acentColor: Colors.redAccent,
    icon: Icon(
      Icons.report_rounded,
      color: Colors.white,
    ),
    snackLabel: 'Something went wrong!',
    textColor: Colors.white,
  ),
  success(
    color: Colors.green,
    acentColor: Colors.greenAccent,
    icon: Icon(
      Icons.cloud_done_rounded,
      color: Colors.white,
    ),
    snackLabel: 'Completed!!',
    textColor: Colors.black,
  );

  final Color color;
  final Color acentColor;
  final Icon icon;
  final String snackLabel;
  final Color textColor;

  const SnackBarType({
    required this.color,
    required this.acentColor,
    required this.icon,
    required this.snackLabel,
    required this.textColor,
  });
}

class CustomSnackBar {
  static void showSnack({
    required BuildContext context,
    required SnackBarType snackBarType,
    required String message,
  }) {
    final size = MediaQuery.of(context).size;
    SnackBar snackBar = SnackBar(
      content: SnackBarWidget(
        icon: snackBarType.icon,
        label: message,
        onPressed: () {},
        backgroundColor: snackBarType.acentColor,
        borderColor: snackBarType.color,
        isMobileView: true,
        textColor: snackBarType.textColor,
      ),
      duration: const Duration(seconds: 2),
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      dismissDirection: DismissDirection.down,
      width: size.width,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class SnackBarWidget extends StatefulWidget implements SnackBarAction {
  const SnackBarWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.textColor,
    this.disabledTextColor,
    this.backgroundColor = Colors.black,
    this.labelTextStyle,
    this.disabledBackgroundColor = Colors.black,
    this.maxLines,
    required this.borderColor,
    required this.isMobileView,
  });

  @override
  final Color? textColor;

  @override
  final Color? disabledTextColor;

  @override
  final String label;

  @override
  final VoidCallback onPressed;

  @override
  final Color backgroundColor;

  @override
  final Color disabledBackgroundColor;

  final TextStyle? labelTextStyle;
  final Icon icon;
  final int? maxLines;
  final Color borderColor;
  final bool isMobileView;

  @override
  State<SnackBarWidget> createState() => _SnackBarWidgetState();
}

class _SnackBarWidgetState extends State<SnackBarWidget> {
  var _fadeAnimationStart = false;
  var disposed = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!disposed) {
        setState(() {
          _fadeAnimationStart = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(4),
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: widget.borderColor, width: 1),
            color: widget.backgroundColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 15),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: widget.icon,
              ),
              const SizedBox(width: 20),
              AnimatedContainer(
                margin: EdgeInsets.only(
                    left: _fadeAnimationStart || widget.isMobileView ? 0 : 10),
                duration: const Duration(milliseconds: 400),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _fadeAnimationStart ? 1.0 : 0.0,
                  child: Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: widget.maxLines,
                    style: widget.labelTextStyle ??
                        TextStyle(
                          fontSize: 16,
                          color: widget.textColor ?? AppColor.black,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
