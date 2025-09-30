import 'package:flutter/material.dart';
import 'package:todo_sample_app/core/theme/theme_exports.dart';

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
  double radius = 20.0,
  Color? backgroundColor,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: backgroundColor ?? AppColors.whitefe,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(radius),
      ),
    ),
    isScrollControlled: isScrollControlled,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      );
    },
  );
}
