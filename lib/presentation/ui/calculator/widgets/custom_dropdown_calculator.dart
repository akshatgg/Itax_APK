// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';

class CustomDropdownCalculator extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final Color borderColor;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  final Color selectedItemColor;
  final Color dropdownColor;

  const CustomDropdownCalculator({
    Key? key,
    required this.items,
    required this.initialValue,
    required this.onChanged,
    this.width,
    this.height,
    this.textStyle,
    this.backgroundColor = AppColor.white,
    this.borderColor = AppColor.black,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.selectedItemColor = AppColor.primary,
    this.dropdownColor = AppColor.white,
  }) : super(key: key);

  @override
  State<CustomDropdownCalculator> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdownCalculator> {
  late String selectedValue;
  bool dropdownOpened = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  void _toggleDropdown() {
    if (dropdownOpened) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      dropdownOpened = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      dropdownOpened = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: widget.width ?? size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, size.height + 5),
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            borderRadius: widget.borderRadius,
            child: Container(
              decoration: BoxDecoration(
                color: widget.dropdownColor,
                borderRadius: widget.borderRadius,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: widget.items.map((item) {
                  bool isSelected = item == selectedValue;
                  return Container(
                    color: isSelected
                        ? widget.selectedItemColor
                        : Colors.transparent,
                    child: ListTile(
                      title: Text(
                        item,
                        style: widget.textStyle?.copyWith(
                              color: isSelected ? AppColor.white : Colors.black,
                            ) ??
                            TextStyle(
                              fontSize: 14,
                              color: isSelected ? AppColor.white : Colors.black,
                            ),
                      ),
                      onTap: () {
                        setState(() => selectedValue = item);
                        widget.onChanged(item);
                        _closeDropdown();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: widget.padding,
          width: widget.width ?? double.infinity,
          height: widget.height ?? 44,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(color: widget.borderColor),
            borderRadius: widget.borderRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedValue,
                  overflow: TextOverflow.ellipsis,
                  style: widget.textStyle,
                ),
              ),
              Icon(
                dropdownOpened
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColor.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
