import 'package:flutter/material.dart';

enum ToastType { success, error }

class CustomAnimatedToast {
  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.error,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    final color = type == ToastType.error ? Colors.black : Colors.black;

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 20,
        right: 20,
        child: _ToastWidget(
          message: message,
          color: color,
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () => overlayEntry.remove());
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final Color color;

  const _ToastWidget({
    required this.message,
    required this.color,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    _offset = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: widget.color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Text(
            widget.message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}