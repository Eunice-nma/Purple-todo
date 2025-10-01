import 'package:flutter/material.dart';

/// Displays a customizable dialog with rounded corners.
/// Supports background color, padding, and dismiss behavior.
/// Returns a value of type [T] when the dialog is closed.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget child,
  double radius = 16.0,
  Color? backgroundColor,
  bool dismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        backgroundColor: backgroundColor ?? Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      );
    },
  );
}
